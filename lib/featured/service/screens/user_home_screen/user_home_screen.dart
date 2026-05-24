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
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
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

  final _addressController = TextEditingController();
  LocationModel? _selectedAddress;
  Future<void> _buildAddressModelFromLatLng(
    String address,
    double lat,
    double lng,
  ) async {
    setState(() {
      _selectedAddress = LocationModel(
        type: 'Points',
        address: address,
        coordinates: [lng, lat],
      );
    });
  }

  Future<void> _save() async {
    await ref
        .read(updateProfileProvider.notifier)
        .update(UpdateProfileRequest(address: _selectedAddress));
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
                            Image.asset(Assets.logo.keyName, height: 180),
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
                        loading: () => const AppLoader(),
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
                    showAddAddress(ref);
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

  void showAddAddress(WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final updateState = ref.watch(updateProfileProvider);
        final isLoading = updateState is UserStateLoading;
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
                    child: GooglePlaceAutoCompleteTextField(
                      textEditingController: _addressController,
                      googleAPIKey: AppConfig.googleMapsApiKey,
                      inputDecoration: InputDecoration(
                        hintText: 'Search your address…',
                        hintStyle: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.grey400,
                          size: 20,
                        ),
                        suffixIcon: ValueListenableBuilder(
                          valueListenable: _addressController,
                          builder: (_, v, __) => v.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close, size: 18),
                                  color: AppColors.grey400,
                                  onPressed: () {
                                    _addressController.clear();
                                  },
                                )
                              : const SizedBox.shrink(),
                        ),
                        filled: true,
                        fillColor: AppColors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),

                      itemClick: (prediction) {
                        _addressController.text = prediction.description ?? '';
                      },

                      getPlaceDetailWithLatLng: (prediction) async {
                        final lat = double.tryParse(prediction.lat ?? '');
                        final lng = double.tryParse(prediction.lng ?? '');

                        if (lat == null || lng == null) return;

                        await _buildAddressModelFromLatLng(
                          prediction.description ?? "N/A",
                          lat,
                          lng,
                        );
                      },

                      isCrossBtnShown: false,
                    ),
                  ),
                  Icon(Icons.edit),
                ],
              ),

              const AppDivider(height: 20),
              16.verticalSpace,

              AppButton.primary(
                label: 'Save',
                isLoading: isLoading,
                onPressed: isLoading ? null : _save,
              ),
              16.verticalSpace,
            ],
          ),
        );
      },
    );
  }
}
