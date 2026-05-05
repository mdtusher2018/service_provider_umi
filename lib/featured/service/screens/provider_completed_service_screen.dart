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
      ref.read(bookingsProvider(BookingStatus.completed).notifier).fetch();
    });
  }

  void _onCardTap(BookingItem item, BuildContext context) {
    context.push(AppRoutes.bookingDetail, extra: item);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingsProvider(BookingStatus.completed));
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppAppBar(title: "Completed Services"),

      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: AppText.h3(e.toString())),
        data: (data) {
          if (data.bookings.isEmpty) {
            return const Center(child: AppText.bodyLg('No bookings found'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref
                  .read(bookingsProvider(BookingStatus.completed).notifier)
                  .fetch();
            },
            child: BookingList(
              items: data.bookings,
              emptyMessage: 'No bookings',
              emptySubtitle: 'Your bookings will appear here',
              onCardTap: (item) => _onCardTap(item, context),
            ),
          );
        },
      ),
    );
  }
}
