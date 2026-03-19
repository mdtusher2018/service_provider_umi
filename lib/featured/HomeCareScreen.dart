import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/featured/booking_time_screen.dart';
import 'package:service_provider_umi/featured/search_screen.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

class HomeCareScreen extends StatelessWidget {
  const HomeCareScreen({super.key});

  // Dynamic list of care categories
  final List<Map<String, dynamic>> careCategories = const [
    {"label": "Children", "icon": Icons.child_care},
    {"label": "Elders", "icon": Icons.elderly},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Image.asset("assets/logo.png", height: 60),
                  Row(
                    children: [
                      _buildCircleIcon(Icons.search, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SearchScreen();
                            },
                          ),
                        );
                      }),
                       16.horizontalSpace,
                      _buildCircleIcon(Icons.notifications_none_sharp, () {}),
                    ],
                  ),
                ],
              ),
            ),

            40.verticalSpace,

            // Header Row
            InkWell(
              onTap: () {
                context.pop();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Icon(Icons.arrow_back_ios_new),
                  16.horizontalSpace,
                  AppText.h1("Care", color: AppColors.textgrey),
                ],
              ),
            ),

            24.verticalSpace,

            // Dynamic Categories using Wrap
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 16, // horizontal spacing
                runSpacing: 16, // vertical spacing
                children: careCategories.map((category) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return BookingTimeScreen();
                          },
                        ),
                      );
                    },
                    child: _buildCategoryItem(
                      category["label"],
                      category["icon"],
                    ),
                  );
                }).toList(),
              ),
            ),

            const Spacer(flex: 3),

            const AppText(
              "Tallapoosa county, east-central Alabama, U.S",
              color: AppColors.textgrey,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  // Helper to build CircleAvatar categories
  Widget _buildCategoryItem(String label, IconData icon) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: AppColors.black),
          4.verticalSpace,
          AppText(label),
        ],
      ),
    );
  }

  // Helper to build top bar icons
  Widget _buildCircleIcon(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black),
        onPressed: onPressed,
      ),
    );
  }
}
