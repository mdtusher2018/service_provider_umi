import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/error/app_exception.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/animations.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/data/models/service_models.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
part '_radial_menu.dart';

class UserHomeScreen extends ConsumerStatefulWidget {
  const UserHomeScreen({super.key});

  @override
  ConsumerState<UserHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<UserHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoriesProvider.notifier).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoriesProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: 20.paddingTop,
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref.read(categoriesProvider.notifier).fetch();
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: 16.paddingRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Logo
                            Image.asset("assets/logo.png", height: 180),
                            Row(
                              spacing: 16,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.search,
                                      color: AppColors.black,
                                    ),
                                    onPressed: () {
                                      context.push(AppRoutes.search);
                                    },
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.notifications_none_sharp,
                                      color: AppColors.black,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      state.when(
                        loading: () =>
                            Center(child: CircularProgressIndicator()),
                        data: (categories) => RadialMenu(menuItems: categories),
                        error: (e, _) => Center(
                          child: AppText.h4(
                            (e is AppException) ? e.message : e.toString(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            40.verticalSpace,
            if (ref.watch(appRoleProvider) == AppRole.user)
              Padding(
                padding: 16.paddingV,
                child: TextButton.icon(
                  onPressed: () {
                    showAddAddress(context);
                  },
                  icon: const Icon(Icons.add, color: AppColors.primary),
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        "Add address",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.horizontalSpace,
                      Icon(Icons.keyboard_arrow_down_rounded),
                    ],
                  ),
                ),
              ),

            if (ref.watch(appRoleProvider) == AppRole.guest) ...[
              Padding(
                padding: 20.paddingH,
                child: AppButton.primary(
                  label: "LOGIN",
                  textColor: AppColors.white,
                  onPressed: () {
                    context.go(AppRoutes.login);
                  },
                ),
              ),

              12.verticalSpace,

              Padding(
                padding: 20.paddingH,
                child: AppButton.outline(
                  label: "Create Account",
                  onPressed: () {
                    context.go(AppRoutes.login);
                  },
                ),
              ),
              20.verticalSpace,
            ],
            20.verticalSpace,
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
          padding: 20.paddingAll,
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
                  InkWell(
                    onTap: Navigator.of(context).pop,
                    child: Icon(Icons.cancel),
                  ),
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
              16.verticalSpace,

              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryFor(ref.watch(appRoleProvider)),
                  borderRadius: 12.circular,
                ),
                child: const Center(
                  child: AppText.labelLg("Add address", color: AppColors.white),
                ),
              ),
              16.verticalSpace,
            ],
          ),
        );
      },
    );
  }
}
