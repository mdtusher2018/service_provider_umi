import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/error/app_exception.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/animations.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/datetime_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/data/models/provider_models.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/core/theme/app_text_styles.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_rating_bar.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';

part '_buildComments.dart';
part '../../../guest/guest_login_dialog.dart';
part '_buildProfileHeader.dart';
part '_buildGallery.dart';
part '_app_bar.dart';
part '_buildQaSection.dart';
part '_buildFrequencyOverlay.dart';

class ProviderProfileOverviewScreen extends ConsumerStatefulWidget {
  final String providerId;
  const ProviderProfileOverviewScreen({super.key, required this.providerId});

  @override
  ConsumerState<ProviderProfileOverviewScreen> createState() =>
      _ProviderProfileOverviewScreenState();
}

class _ProviderProfileOverviewScreenState
    extends ConsumerState<ProviderProfileOverviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(providerProfileProvider.notifier).fetch(widget.providerId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(providerProfileProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: state.when(
        loading: () => Center(child: CircularProgressIndicator()),
        data: (providerProfile) => _buildProfileScreen(providerProfile),
        error: (e, _) => Center(
          child: AppText.h4((e is AppException) ? e.message : e.toString()),
        ),
      ),
    );
  }

  Widget _buildProfileScreen(ProviderProfile providerProfile) {
    return Stack(
      children: [
        Column(
          children: [
            _buildAppBar(mockProvider: providerProfile, ref: ref),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Column(
                  spacing: 16,
                  children: [
                    _buildProfileHeader(
                      ref: ref,
                      mockProvider: providerProfile,
                    ),

                    _buildAboutSection(providerProfile),
                    AppDivider(),
                    _buildGallery(ref),
                    AppDivider(),
                    _buildQaSection(mockProvider: providerProfile),

                    AppDivider(),
                    _buildRatingSection(providerProfile),
                    AppDivider(),
                    _buildComments(comments: providerProfile.comments),
                    AppDivider(),
                    100.verticalSpace,
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildBottomBar(providerProfile),
        ),
        if (ref.watch(frequencySheetProvider))
          _buildFrequencyOverlay(mockProvider: providerProfile, ref: ref),
      ],
    );
  }

  Widget _buildAboutSection(ProviderProfile providerProfile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.h3('About me'),
        10.verticalSpace,
        AppText.bodyMd(providerProfile.about),
        8.verticalSpace,
        GestureDetector(
          onTap: () {},
          child: AppText.labelMd('+View more', fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildRatingSection(ProviderProfile providerProfile) {
    return AppRatingBreakdown(
      overall: providerProfile.rating.average,
      totalReviews: providerProfile.rating.totalReviews,
      breakdown: providerProfile.rating.breakdown,
    );
  }

  Widget _buildBottomBar(ProviderProfile providerProfile) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: context.bottomPadding + 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText.h1(
                  '\$${providerProfile.hourlyRate.toStringAsFixed(0)}/h',
                ),
              ],
            ),
          ),

          20.horizontalSpace,
          Expanded(
            child: AppButton.primary(
              label: 'View availability',
              onPressed: () {
                if (ref.watch(appRoleProvider) == AppRole.guest) {
                  // Show dialog so guest understands they need to login
                  GuestLoginDialog.show(
                    context,
                    onLogin: () {
                      context.go(AppRoutes.login);
                    },
                    onRegister: () {
                      context.go(AppRoutes.login);
                    },
                  );
                  return;
                }
                ref.read(frequencySheetProvider.notifier).state = true;
              },
            ),
          ),
        ],
      ),
    );
  }
}
