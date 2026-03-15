import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/featured/HomeCareScreen.dart';
import 'package:service_provider_umi/featured/search_screen.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
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
                  Image.asset("assets/logo.png", height: 100),
                  Row(
                    spacing: 16,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.search, color: Colors.black),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SearchScreen();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.notifications_none_sharp,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            RadialMenu(),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: TextButton.icon(
                onPressed: () {
                  showAddAddress(context);
                },
                icon: const Icon(Icons.add, color: Colors.teal),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      "Add address",
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.keyboard_arrow_down_rounded),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAddAddress(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText.h2("Service address"),
                        const AppText.bodyMd(
                          "Select where you want to receive the service",
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.cancel),
                ],
              ),

              const AppDivider(height: 20),

              Row(
                spacing: 8,
                children: [
                  Icon(Icons.check_circle),
                  Expanded(
                    child: AppTextField(
                      hint: "Enter your address",
                      fillColor: AppColors.white,
                    ),
                  ),
                  Icon(Icons.edit),
                ],
              ),

              const AppDivider(height: 20),
              SizedBox(height: 16),

              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryFor(ref.watch(appRoleProvider)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: AppText.labelLg("Add address", color: AppColors.white),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class RadialMenu extends StatelessWidget {
  RadialMenu({super.key});

  final List<Map<String, dynamic>> menuItems = [
    {'name': 'Home', 'icon': Icons.home},
    {'name': 'Cleaning', 'icon': Icons.cleaning_services},
    {'name': 'Care', 'icon': Icons.favorite},
    {'name': 'Handyman', 'icon': Icons.build},
    {'name': 'Pets', 'icon': Icons.pets},
    {'name': 'Others', 'icon': Icons.card_giftcard},
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double radius = screenWidth * 0.3; // distance from center
    double center = screenWidth / 2; // dynamically calculate center

    return SizedBox(
      width: screenWidth,
      height: screenWidth,

      child: Stack(
        children: [
          // Dynamic Menu Items
          ...List.generate(menuItems.length, (index) {
            final angle = (2 * pi / menuItems.length) * index;
            final x = radius * cos(angle);
            final y = radius * sin(angle);

            return Positioned(
              left: center + x - 25, // subtract half of item size
              top: center + y - 30,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return HomeCareScreen();
                      },
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          menuItems[index]['icon'],
                          size: 28,
                          color: AppColors.black,
                        ),
                        const SizedBox(height: 4),
                        AppText(menuItems[index]['name']),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          // Center Fixed Button
          Positioned(
            left: center - 40, // half of button width
            top: center - 40, // half of button height
            child: ElevatedButton(
              onPressed: () {
                showCustomDialog(context);
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.support_agent, size: 40),
                  AppText('Support', textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: AlignmentGeometry.topRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close),
                  ),
                ),
                Image.asset("assets/support.png", width: 120),
                SizedBox(height: 16),

                SizedBox(height: 16),
                AppButton.primary(
                  label: 'Call',
                  prefixIcon: Icon(Icons.call, color: AppColors.white),
                  onPressed: () {
                    // Call action
                    Navigator.pop(context); // Close the dialog
                    print("Call pressed");
                  },
                ),
                SizedBox(height: 8),
                AppButton.primary(
                  label: 'Message',
                  prefixIcon: Icon(Icons.message, color: AppColors.white),
                  onPressed: () {
                    // Message action
                    Navigator.pop(context); // Close the dialog
                    print("Message pressed");
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
