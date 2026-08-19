import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:service_provider_umi/core/config/app_config.dart';
import 'package:service_provider_umi/core/error/app_exception.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/animations.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/data/models/category_models.dart';
import 'package:service_provider_umi/data/models/user_models.dart';
import 'package:service_provider_umi/featured/profile/riverpod/user_provider.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
import 'package:service_provider_umi/gen/assets.gen.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/shared/widgets/app_error_widget.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import 'package:service_provider_umi/l10n/app_localizations.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:service_provider_umi/featured/profile/riverpod/address_provider.dart';
import 'package:service_provider_umi/data/models/address_model.dart';

part '_radial_menu.dart';
part '_service_address_bottom_sheet.dart';

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
      ref.read(myProfileProvider.notifier).fetch();
      ref.read(addressProvider.notifier).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoriesProvider);
    final myProfileState = ref.watch(myProfileProvider);
    final userProfile = myProfileState.maybeWhen(
      success: (profile) => profile,
      orElse: () => null,
    );

    final addressesState = ref.watch(addressProvider);
    final selectedId = ref.watch(selectedAddressIdProvider);

    String? selectedAddressName;
    if (addressesState is AsyncData) {
      final addresses = addressesState.value ?? [];
      if (addresses.isNotEmpty) {
        AddressModel? current;
        if (selectedId != null) {
          current = addresses.firstWhere((a) => a.id == selectedId, orElse: () => addresses.first);
        } else {
          current = addresses.firstWhere((a) => a.isDefault, orElse: () => addresses.first);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(selectedAddressIdProvider.notifier).state = current?.id;
          });
        }
        selectedAddressName = current.displayAddress;
      }
    }

    selectedAddressName ??= userProfile?.locaation?.address ?? '+ ${AppLocalizations.of(context)!.addAddress}';

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
                            Image.asset(Assets.logoPng.keyName, height: 180),
                            Row(
                              spacing: 16,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.grey200, width: 1),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.search,
                                      color: AppColors.grey500,
                                    ),
                                    onPressed: () {
                                      if (kIsWeb) {
                                        context.go(AppRoutes.search);
                                      } else {
                                        context.push(AppRoutes.search);
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.grey200, width: 1),
                                  ),
                                  child: Stack(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.notifications_none_sharp,
                                          color: AppColors.grey500,
                                        ),
                                        onPressed: () {
                                          if (kIsWeb) {
                                            context.go(AppRoutes.userNotifications);
                                          } else {
                                            context.push(AppRoutes.userNotifications);
                                          }
                                        },
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 12,
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: AppColors.success,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: AppColors.white, width: 1),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      state.when(
                        loading: () => SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: const Center(child: AppLoader()),
                        ),
                        data: (categories) => RadialMenu(menuItems: categories),
                        error: (e, _) => AppErrorWidget(
                          error: e,
                          onRetry: () => ref.read(categoriesProvider.notifier).fetch(),
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
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: AppColors.background,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (_) => const ServiceAddressBottomSheet(),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AppText(
                          'Address: ',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        AppText(
                          selectedAddressName,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        4.horizontalSpace,
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  // Old address widget removed.
}
