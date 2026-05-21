import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:service_provider_umi/core/logger/app_logger.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/data/models/booking_models.dart';
import 'package:service_provider_umi/featured/service/riverpod/profile_status_provider.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';

import 'package:service_provider_umi/featured/service/widgets/booking_card_widget.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import '../../../../../../core/di/app_role_provider.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';

// ─── Screen ───────────────────────────────────────────────────
class ServiceProviderHomeScreen extends ConsumerStatefulWidget {
  const ServiceProviderHomeScreen({super.key});

  @override
  ConsumerState<ServiceProviderHomeScreen> createState() =>
      _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<ServiceProviderHomeScreen> {
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final result = await ref.read(myProfileStatusProvider.notifier).fetch();
      AppLogger.info("Result: ==============>>>>>>> $result");
      if (result == false) {
        context.go(AppRoutes.workSchedule);
        return;
      }

      ref
          .read(bookingsProvider(BookingStatus.ongoing).notifier)
          .fetch(initial: true);
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
    final role = ref.watch(appRoleProvider);
    final primary = AppColors.primaryFor(role);
    final state = ref.watch(bookingsProvider(BookingStatus.ongoing));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(primary),
                Expanded(
                  child: state.when(
                    loading: () => const AppLoader(),
                    error: (e, _) => Center(child: AppText.h3(e.toString())),
                    data: (data) {
                      final bookings = data;

                      if (bookings.isEmpty) {
                        return const Center(
                          child: AppText.bodyLg('No bookings found'),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          await ref
                              .read(
                                bookingsProvider(
                                  BookingStatus.ongoing,
                                ).notifier,
                              )
                              .fetch(initial: true);
                        },
                        child: BookingList(
                          items: bookings,
                          emptyMessage: 'No bookings',
                          emptySubtitle: 'Your bookings will appear here',
                          onCardTap: (item) => _onCardTap(item, context),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color primary) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Calendar icon
          Icon(Icons.timer, color: AppColors.primaryFor(AppRole.provider)),
          10.horizontalSpace,
          AppText('Upcoming Bookings', style: AppTextStyles.h3),
          const Spacer(),
          // Date selector
          GestureDetector(
            // onTap: () => _selectDate(context), // Open the Date Picker
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: 8.circular,
                border: Border.all(color: AppColors.grey200),
              ),
              child: Row(
                children: [
                  AppText(
                    DateFormat('d MMM, yyyy').format(DateTime.now()),
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  // 4.horizontalSpace,
                  // const Icon(
                  //   Icons.keyboard_arrow_down_rounded,
                  //   color: AppColors.grey400,
                  //   size: 16,
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2020),
  //     lastDate: DateTime(2101),
  //     builder: (context, child) {
  //       return Theme(
  //         data: ThemeData.light().copyWith(
  //           primaryColor: AppColors.primary,
  //           buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
  //           colorScheme: ColorScheme.light(primary: AppColors.primary),
  //           // Customizing the header text style
  //           textTheme: TextTheme(
  //             headlineMedium: TextStyle(
  //               color: AppColors.textPrimary,
  //               fontSize: 18,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //           // Customize the Date Picker's Year and Month selection
  //           inputDecorationTheme: InputDecorationTheme(
  //             border: OutlineInputBorder(borderSide: BorderSide.none),
  //             focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
  //           ),
  //           dialogTheme: DialogThemeData(backgroundColor: AppColors.white),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );
  //   if (picked != null && picked != _selectedDate) {
  //     setState(() {
  //       _selectedDate = picked;
  //     });
  //   }
  // }
}
