import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/error/app_exception.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';

import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

class ServiceSubCategoryScreen extends ConsumerStatefulWidget {
  const ServiceSubCategoryScreen({
    super.key,
    required this.serviceId,
    required this.serviceName,
  });
  final String serviceId;
  final String serviceName;

  @override
  ConsumerState<ServiceSubCategoryScreen> createState() =>
      _ServiceSubCategoryScreenState();
}

class _ServiceSubCategoryScreenState
    extends ConsumerState<ServiceSubCategoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(subCategoriesProvider.notifier).fetch(widget.serviceId);
    });
  }

  Widget _buildBody() {
    final state = ref.watch(subCategoriesProvider);

    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text((e is AppException) ? e.message : e.toString())),
      data: (categories) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: categories.map((category) {
            return InkWell(
              onTap: () {
                context.push(AppRoutes.bookingTime);
              },
              child: _buildCategoryItem(category.name, category.image ?? ""),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: 16.paddingAll,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Image.asset("assets/logo.png", height: 60),
                  Row(
                    children: [
                      _buildCircleIcon(Icons.search, () {
                        context.push(AppRoutes.search);
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
                children: [
                  Icon(Icons.arrow_back_ios_new),
                  16.horizontalSpace,
                  AppText.h1(widget.serviceName, color: AppColors.textgrey),
                ],
              ),
            ),

            24.verticalSpace,

            // Dynamic Categories using Wrap
            Padding(padding: 16.paddingH, child: _buildBody()),

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
  Widget _buildCategoryItem(String label, String icon) {
    double size = 50;
    return Container(
      width: size * 2,
      height: size * 2,
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(icon),
                fit: BoxFit.cover,
              ),
            ),
          ),
          AppText.bodySm(
            label,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w500,
          ),
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
