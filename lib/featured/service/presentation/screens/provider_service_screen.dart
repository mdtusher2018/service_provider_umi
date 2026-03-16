import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/featured/service/presentation/screens/booking_details_screen.dart';
import 'package:service_provider_umi/featured/service/presentation/screens/booking_card_widget.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
part 'provider_completed_service_screen.dart';

class ProviderServiceScreen extends ConsumerStatefulWidget {
  const ProviderServiceScreen({super.key});

  @override
  ConsumerState<ProviderServiceScreen> createState() =>
      _ProviderServiceScreenState();
}

class _ProviderServiceScreenState extends ConsumerState<ProviderServiceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _requests = const [
    BookingItem(
      id: '1',
      serviceTitle: 'Elderly care',
      imageUrl: '',
      timeRange: 'From 16:30 to 18:30',
      date: 'Monday, 1 Feb 2025',
      status: BookingStatus.pending,
    ),
  ];

  final _ongoing = const [
    BookingItem(
      id: '2',
      serviceTitle: 'Elderly care',
      imageUrl: '',
      timeRange: 'From 16:30 to 18:30',
      date: 'Monday, 1 Feb 2025',
      status: BookingStatus.ongoing,
    ),
  ];

  final _cancelled = const [
    BookingItem(
      id: '3',
      serviceTitle: 'Elderly care',
      imageUrl: '',
      timeRange: 'From 16:30 to 18:30',
      date: 'Monday, 1 Feb 2025',
      status: BookingStatus.cancelled,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onCardTap(BookingItem item, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return BookingDetailScreen(booking: item);
        },
      ),
    );
  }

  void _openCompleted() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProviderCompletedScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppAppBar(
        title: "Request",
        showBackButton: false,
        centerTitle: false,
        actions: [
          InkWell(
            onTap: _openCompleted,
            child: Icon(Icons.domain_verification_rounded),
          ),
          SizedBox(width: 16),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _ProviderTabBar(controller: _tabController),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  /// REQUEST
                  BookingList(
                    items: _requests,
                    emptyMessage: "No service requests",
                    emptySubtitle: "New requests will appear here",
                    onCardTap: (iteam) => _onCardTap(iteam, context),
                  ),

                  /// ONGOING
                  BookingList(
                    items: _ongoing,
                    emptyMessage: "No ongoing services",
                    emptySubtitle: "Accepted bookings will appear here",
                    onCardTap: (iteam) => _onCardTap(iteam, context),
                  ),

                  /// CANCELLED
                  BookingList(
                    items: _cancelled,
                    emptyMessage: "No cancelled bookings",
                    emptySubtitle: "Cancelled services will appear here",
                    onCardTap: (iteam) => _onCardTap(iteam, context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProviderTabBar extends StatelessWidget {
  final TabController controller;

  const _ProviderTabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final tabs = ["Request", "Ongoing", "Cancelled"];

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: tabs.asMap().entries.map((e) {
              final isSelected = controller.index == e.key;

              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.animateTo(e.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.grey200
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(
                      child: AppText.labelMd(
                        e.value,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
