part of 'provider_service_screen.dart';

class ProviderCompletedServiceScreen extends ConsumerStatefulWidget {
  const ProviderCompletedServiceScreen({super.key});

  @override
  ConsumerState<ProviderCompletedServiceScreen> createState() =>
      _ProviderCompletedServiceScreenState();
}

class _ProviderCompletedServiceScreenState
    extends ConsumerState<ProviderCompletedServiceScreen> {
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(bookingsProvider(BookingStatus.complete).notifier).fetch();
    });
  }

  void _onCardTap(BookingModel item, BuildContext context) {
    if (kIsWeb) {
      context.go(AppRoutes.bookingDetailPath(item.id));
    } else {
      context.push(AppRoutes.bookingDetailPath(item.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingsProvider(BookingStatus.complete));
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppAppBar(title: "Completed Services"),

      body: state.when(
        loading: () => const AppLoader(),
        error: (e, _) => Center(child: AppText.h3(e.toString())),
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: AppText.bodyLg('No bookings found'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref
                  .read(bookingsProvider(BookingStatus.complete).notifier)
                  .fetch();
            },
            child: BookingList(
              items: data,
              emptyMessage: 'No bookings',
              emptySubtitle: 'Your bookings will appear here',
              onCardTap: (item) => _onCardTap(item, context),
              onRatingTap: _showRatingDialog,
            ),
          );
        },
      ),
    );
  }

  void _showRatingDialog(BookingModel item) {
    showGeneralDialog(
      context: context,
      transitionDuration: dialogSlidingFadeTransitionDuration,
      transitionBuilder: dialogSlideFadeTransition,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (_, _, _) => RatingDialog(
        providerId: item.provider?.id ?? "N/A",
        onSubmit: () {
          context.pop();
        },
      ),
    );
  }
}
