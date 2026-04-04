import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/animations.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
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
part 'guest_login_dialog.dart';
part '_buildProfileHeader.dart';
part '_buildGallery.dart';
part '_app_bar.dart';
part '_buildQaSection.dart';
part '_buildFrequencyOverlay.dart';

// ─── Supporting data classes ──────────────────────────────────
class _ProviderData {
  final String name, specialty, bio, experience;
  final double rating, pricePerHour;
  final int reviewCount, serviceCount;
  final bool isQualified;
  const _ProviderData({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    required this.serviceCount,
    required this.pricePerHour,
    required this.bio,
    required this.experience,
    required this.isQualified,
  });
}

class _CommentData {
  final String author, timeAgo, text;
  final bool isVerified;
  const _CommentData({
    required this.author,
    required this.timeAgo,
    required this.isVerified,
    required this.text,
  });
}

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

  static const _mockProvider = _ProviderData(
    name: 'NB Sujon',
    specialty: 'Elderly care',
    rating: 5.0,
    reviewCount: 1,
    serviceCount: 2,
    pricePerHour: 10,
    bio:
        'Welcome to NB Sujon, where quality meets convenience! With a passion for excellence and a commitment to customer satisfaction, we specialize in delivering top-notch service.',
    experience: '6-10 years of experience',
    isQualified: false,
  );

  final _ratingBreakdown = const {
    'Service': 5.0,
    'Punctuality': 4.0,
    'Kindness': 3.0,
    'Value for money': 2.0,
    'Professionalism': 1.0,
  };

  final _comments = const [
    _CommentData(
      author: 'Ana',
      timeAgo: '6 Hours Ago',
      isVerified: true,
      text:
          'The service was outstanding! The provider was professional, arrived on time, and completed the job perfectly.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              _buildAppBar(mockProvider: _mockProvider, ref: ref),
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
                        mockProvider: _mockProvider,
                      ),

                      _buildAboutSection(),
                      AppDivider(),
                      _buildGallery(ref),
                      AppDivider(),
                      _buildQaSection(mockProvider: _mockProvider),

                      AppDivider(),
                      _buildRatingSection(),
                      AppDivider(),
                      _buildComments(comments: _comments),
                      AppDivider(),
                      100.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomBar()),
          if (ref.watch(frequencySheetProvider))
            _buildFrequencyOverlay(mockProvider: _mockProvider, ref: ref),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.h3('About me'),
        10.verticalSpace,
        AppText.bodyMd(_mockProvider.bio),
        8.verticalSpace,
        GestureDetector(
          onTap: () {},
          child: AppText.labelMd('+View more', fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return AppRatingBreakdown(
      overall: _mockProvider.rating,
      totalReviews: _mockProvider.reviewCount,
      breakdown: _ratingBreakdown,
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: context.bottomPadding + 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
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
                  '\$${_mockProvider.pricePerHour.toStringAsFixed(0)}/h',
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
