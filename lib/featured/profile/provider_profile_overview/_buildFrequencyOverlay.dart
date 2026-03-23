part of 'provider_profile_screen.dart';

final frequencySheetProvider = StateProvider<bool>((ref) => false);
Widget _buildFrequencyOverlay({
  required WidgetRef ref,
  required _ProviderData mockProvider,
}) {
  final showSheet = ref.watch(frequencySheetProvider);

  if (!showSheet) return const SizedBox.shrink();

  return Positioned.fill(
    child: GestureDetector(
      onTap: () {
        ref.read(frequencySheetProvider.notifier).state = false;
      },
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {}, // prevent closing when tapping sheet
            child: _ServiceFrequencySheet(
              pricePerHour: mockProvider.pricePerHour,
              onClose: () {
                ref.read(frequencySheetProvider.notifier).state = false;
              },
            ),
          ),
        ),
      ),
    ),
  );
}

class _ServiceFrequencySheet extends StatefulWidget {
  final double pricePerHour;
  final VoidCallback onClose;
  const _ServiceFrequencySheet({
    required this.pricePerHour,
    required this.onClose,
  });

  @override
  State<_ServiceFrequencySheet> createState() => _ServiceFrequencySheetState();
}

class _ServiceFrequencySheetState extends State<_ServiceFrequencySheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: context.bottomPadding + 20,
        left: 20,
        right: 20,
        top: 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.h3('Service frequency'),
              GestureDetector(
                onTap: widget.onClose,
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          AppText.bodySm('How many times do you want the service?'),
          16.verticalSpace,

          // Weekly option
          _FreqOption(
            icon: Icons.refresh_rounded,
            title: 'Weekly',
            subtitle: 'Recurring service',
            bullets: [
              'Flexible terms: cancel or switch professionals free of charge',
              'Automatic booking and weekly payment.',
              'Cancel one-time service in 1 click',
            ],
            onTap: () {
              context.push(
                AppRoutes.bookingSchedule,
                extra: BookingFrequency.weekly,
              );
            },
          ),
          12.verticalSpace,

          // Just once option
          _FreqOption(
            icon: Icons.looks_one_outlined,
            title: 'Just once',
            subtitle: 'One-Time service',

            onTap: () {
              context.push(
                AppRoutes.bookingSchedule,
                extra: BookingFrequency.once,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FreqOption extends ConsumerWidget {
  final IconData icon;
  final String title, subtitle;
  final List<String> bullets;

  final VoidCallback onTap;

  const _FreqOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.bullets = const [],

    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryFor(ref.watch(appRoleProvider)),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.primaryFor(ref.watch(appRoleProvider)),
                  size: 22,
                ),
                10.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.labelLg(
                      title,
                      color: AppColors.primaryFor(ref.watch(appRoleProvider)),
                      fontWeight: FontWeight.w700,
                    ),
                    AppText.bodySm(subtitle),
                  ],
                ),
              ],
            ),
            if (bullets.isNotEmpty) ...[
              10.verticalSpace,
              AppDivider(color: AppColors.grey300),
              10.verticalSpace,
              ...bullets.map(
                (b) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_rounded,
                        color: AppColors.primaryFor(ref.watch(appRoleProvider)),
                        size: 14,
                      ),
                      8.horizontalSpace,
                      Expanded(child: AppText.bodySm(b)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
