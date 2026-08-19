import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:service_provider_umi/core/error/app_exception.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/animations.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/datetime_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/utils/helpers/decode_helper.dart';
import 'package:service_provider_umi/data/models/provider_models.dart';
import 'package:service_provider_umi/data/models/user_models.dart';
import 'package:service_provider_umi/data/models/faq_model.dart';
import 'package:service_provider_umi/featured/favourites/riverpod/favourites_notifire.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';

import 'package:service_provider_umi/gen/assets.gen.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/core/theme/app_text_styles.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_error_widget.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import 'package:readmore/readmore.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
        loading: () => AppLoader(),
        data: (data) => _buildProfileScreen(data.$1, data.$2, data.$3),
        error: (e, _) => AppErrorWidget(
          error: e,
          onRetry: () => ref.read(providerProfileProvider.notifier).fetch(widget.providerId),
        ),
      ),
    );
  }

  Widget _buildProfileScreen(
    UserProfile profileData,
    List<ProviderComment> reviews,
    String chatId,
  ) {
    return Stack(
      children: [
        Column(
          children: [
            _buildAppBar(
              data: profileData,
              ref: ref,
              providerId: widget.providerId,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Column(
                  spacing: 8,
                  children: [
                    _buildProfileHeader(
                      ref: ref,
                      data: profileData,
                      chatId: chatId,
                    ),

                    _buildAboutSection(profileData),
                    // AppDivider(),
                    _buildGallery(
                      ref,
                      profileData.id,
                      profileData.serviceProviderInfo?.images ?? [],
                    ),
                    // AppDivider(),
                    /// Add faq section here
                    _buildQaSection(ref, profileData),
                    // AppDivider(),
                    // if (providerProfile.rating != null)
                    //   _buildRatingSection(providerProfile.rating!),
                    // AppDivider(),
                    _buildComments(comments: reviews),
                    // AppDivider(),
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
          child: _buildBottomBar(profileData),
        ),
        if (ref.watch(frequencySheetProvider))
          _buildFrequencyOverlay(
            ref: ref,
            providerId: widget.providerId,
            price:
                profileData.serviceProviderInfo?.perHourPrice.toString() ?? "0",
          ),
      ],
    );
  }

  Widget _buildAboutSection(UserProfile providerProfile) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [AppText.bodyLg('About me', fontWeight: FontWeight.w700, color: AppColors.textPrimary)]),
          10.verticalSpace,
          ReadMoreText(
            providerProfile.bio ?? 'N/A',
            trimMode: TrimMode.Line,
            trimLines: 2,
            colorClickableText: AppColors.primary,
            trimCollapsedText: '+View more',
            trimExpandedText: ' View less',
            moreStyle: AppTextStyles.bodyMd.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
            lessStyle: AppTextStyles.bodyMd.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildRatingSection(ProviderRating rating) {
  //   return AppRatingBreakdown(
  //     overall: rating.average,
  //     totalReviews: rating.totalReviews,
  //     breakdown: rating.breakdown,
  //   );
  // }

  Widget _buildBottomBar(UserProfile providerProfile) {
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
                  '\$${providerProfile.serviceProviderInfo?.perHourPrice.toStringAsFixed(0)}/h',
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
