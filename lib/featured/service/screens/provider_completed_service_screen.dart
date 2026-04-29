part of 'provider_service_screen.dart';

class ProviderCompletedServiceScreen extends StatelessWidget {
  const ProviderCompletedServiceScreen({super.key});

  final List<BookingItem> _completed = const [
    BookingItem(
      bookingId: '10',
      serviceName: 'Elderly care',
      serviceImageUrl: '',
      startTime: '16:30',
      endTime: '19:30',
      bookingDate: 'Monday, 1 Feb 2025',
      bookingStatus: BookingStatus.completed,
      paidOnDate: 'Monday, 1 Feb 2025',
      price: 120,
    ),
  ];

  void _onCardTap(BookingItem item, BuildContext context) {
    context.push(AppRoutes.bookingDetail, extra: item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppAppBar(title: "Completed Services"),

      body: _completed.isEmpty
          ? const Center(child: AppText.bodyLg("No completed services"))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              itemCount: _completed.length,
              separatorBuilder: (_, __) => 12.verticalSpace,
              itemBuilder: (_, i) => BookingCard(
                item: _completed[i],
                onTap: () => _onCardTap(_completed[i], context),
              ),
            ),
    );
  }
}
