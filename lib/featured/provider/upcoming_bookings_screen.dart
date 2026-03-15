import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:service_provider_umi/featured/provider/booking_details_screen.dart';

import 'package:service_provider_umi/featured/service/presentation/screens/booking_card_widget.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import '../../../../core/di/app_role_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

// ─── Screen ───────────────────────────────────────────────────
class UpcomingBookingsScreen extends ConsumerStatefulWidget {
  const UpcomingBookingsScreen({super.key});

  @override
  ConsumerState<UpcomingBookingsScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<UpcomingBookingsScreen> {
  DateTime _selectedDate = DateTime(2024, 6, 14);
  final List<BookingItem> _bookings = [
    BookingItem(
      id: '1',
      serviceTitle: 'Elderly care',
      imageUrl: '',
      timeRange: 'From 16:30 to 18:30',
      date: 'Monday, 1 Feb 2025',
      status: BookingStatus.accepted,
    ),
    BookingItem(
      id: '2',
      serviceTitle: 'Home Cleaning',
      imageUrl: '',
      timeRange: 'From 10:00 to 12:00',
      date: 'Tuesday, 2 Feb 2025',
      status: BookingStatus.upcoming,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(appRoleProvider);
    final primary = AppColors.primaryFor(role);

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
                  child: _buildBookingList(), // Create booking list widget here
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
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.calendar_today_rounded,
              color: AppColors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          AppText('Upcoming Bookings', style: AppTextStyles.h3),
          const Spacer(),
          // Date selector
          GestureDetector(
            onTap: () => _selectDate(context), // Open the Date Picker
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Row(
                children: [
                  AppText(
                    DateFormat('d MMM, yyyy').format(_selectedDate),
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.grey400,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Booking List Widget
  Widget _buildBookingList() {
    return ListView.separated(
      padding: EdgeInsets.all(16),
      separatorBuilder: (context, index) {
        return SizedBox(height: 16);
      },
      itemCount: _bookings.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return BookingDetailScreen(booking: _bookings[index]);
                },
              ),
            );
          },
          child: BookingCard(item: _bookings[index]),
        );
      },
    );
  }

  // Method to show Date Picker and update selected date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primary,

            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: ColorScheme.light(primary: AppColors.primary),
            // Customizing the header text style
            textTheme: TextTheme(
              headlineMedium: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Customizing the dialog background color
            dialogBackgroundColor: AppColors.white,
            // Customize the Date Picker's Year and Month selection
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
