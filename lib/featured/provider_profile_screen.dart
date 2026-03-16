import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/theme/app_role.dart';
import 'package:service_provider_umi/core/theme/app_text_styles.dart';
import 'package:service_provider_umi/featured/authentication/WelcomeScreen.dart';
import 'package:service_provider_umi/featured/schedule_screen.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_rating_bar.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

import 'package:service_provider_umi/shared/widgets/app_utils.dart';

class ProviderProfileScreen extends ConsumerStatefulWidget {
  final String providerId;
  const ProviderProfileScreen({super.key, required this.providerId});

  @override
  ConsumerState<ProviderProfileScreen> createState() =>
      _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends ConsumerState<ProviderProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorited = false;
  bool _showFrequencySheet = false;

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
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Column(
                    spacing: 16,
                    children: [
                      _buildProfileHeader(),

                      _buildAboutSection(),
                      AppDivider(),
                      _buildGallery(),
                      AppDivider(),
                      _buildQaSection(),

                      AppDivider(),
                      _buildRatingSection(),
                      AppDivider(),
                      _buildComments(),
                      AppDivider(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomBar()),
          if (_showFrequencySheet) _buildFrequencyOverlay(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
            Expanded(
              child: Center(
                child: AppText.h3("${_mockProvider.name}'s profile"),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.ios_share_outlined,
                color: AppColors.textPrimary,
              ),
              onPressed: () {},
            ),
            GestureDetector(
              onTap: () => setState(() => _isFavorited = !_isFavorited),
              child: Icon(
                _isFavorited
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: _isFavorited ? AppColors.error : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        AppAvatar(name: _mockProvider.name, size: AvatarSize.xl),
        const SizedBox(height: 12),
        AppText.h2(_mockProvider.name),
        const SizedBox(height: 4),
        AppText.labelLg(
          _mockProvider.specialty,
          color: AppColors.primaryFor(ref.watch(appRoleProvider)),
        ),
        const SizedBox(height: 16),

        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AppAvatar(
                imageUrl: "assets/icons/chat_icon.png",
                size: AvatarSize.md,
                backgroundColor: AppColors.primaryFor(
                  ref.watch(appRoleProvider),
                ),
              ),
              _StatDivider(),
              _StatItem(
                value: '${_mockProvider.rating} ⭐',
                label: '${_mockProvider.reviewCount} reviews',
              ),
              _StatDivider(),
              _StatItem(
                value: '${_mockProvider.serviceCount}',
                label: 'Service',
              ),
              _StatDivider(),
              _StatItem(
                value: '',
                icon: Icon(Icons.verified, color: AppColors.info),
                label: 'Verified',
                valueColor: AppColors.primaryFor(ref.watch(appRoleProvider)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.h3('About me'),
        const SizedBox(height: 10),
        AppText.bodyMd(_mockProvider.bio),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {},
          child: AppText.labelMd('+View more', fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildQaSection() {
    final qaItems = [
      (
        'How much experience do you have as a carer of the elderly?',
        _mockProvider.experience,
      ),
      (
        'Do you have a qualification, diploma or degree as a health worker?',
        _mockProvider.isQualified ? '✓ Yes' : '✓ No',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.h3('Some question about me'),
        const SizedBox(height: 12),
        ...qaItems.map(
          (qa) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.labelLg(
                  qa.$1,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 4),
                AppText.bodyMd(qa.$2),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: AppText.labelLg('View all'),
          ),
        ),
      ],
    );
  }

  Widget _buildGallery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.h3('Gallery'),
            GestureDetector(
              onTap: () {},
              child: AppText.labelMd('View gallery'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) => Container(
              width: 90,
              decoration: BoxDecoration(
                color: AppColors.primaryFor(ref.watch(appRoleProvider)),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(
                Icons.image_outlined,
                color: AppColors.primaryFor(ref.watch(appRoleProvider)),
                size: 32,
              ),
            ),
          ),
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

  Widget _buildComments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.h3('Comments'),
        const SizedBox(height: 12),
        ..._comments.map((c) => _CommentTile(comment: c)),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
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
          const SizedBox(width: 20),
          Expanded(
            child: AppButton.primary(
              label: 'View availability',
              onPressed: () {
                if (ref.watch(appRoleProvider) == AppRole.guest) {
                  // Show dialog so guest understands they need to login
                  GuestLoginDialog.show(
                    context,
                    onLogin: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return WelcomeScreen();
                          },
                        ),
                        (route) => false,
                      );
                    },
                    onRegister: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return WelcomeScreen();
                          },
                        ),
                        (route) => false,
                      );
                    },
                  );
                  return;
                }
                setState(() => _showFrequencySheet = true);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => _showFrequencySheet = false),
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {},
              child: _ServiceFrequencySheet(
                pricePerHour: _mockProvider.pricePerHour,
                onClose: () => setState(() => _showFrequencySheet = false),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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

// ─── Supporting widgets ───────────────────────────────────────

class _StatItem extends StatelessWidget {
  final String value, label;
  final Color? valueColor;
  final Widget? icon;
  const _StatItem({
    required this.value,
    required this.label,
    this.valueColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (value.isNotEmpty)
          AppText.h3(value, color: valueColor ?? AppColors.textPrimary),
        ?icon,
        const SizedBox(height: 2),
        AppText.bodySm(label),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: AppColors.border);
  }
}

class _CommentTile extends ConsumerWidget {
  final _CommentData comment;
  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(name: comment.author, size: AvatarSize.sm),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.labelLg(comment.author),
                  Row(
                    children: [
                      AppText.bodySm(comment.timeAgo),
                      if (comment.isVerified) ...[
                        const SizedBox(width: 6),
                        Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primaryFor(
                            ref.watch(appRoleProvider),
                          ),
                          size: 12,
                        ),
                        const SizedBox(width: 2),
                        AppText.bodySm(
                          'Verified service',
                          color: AppColors.primaryFor(
                            ref.watch(appRoleProvider),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppText.bodyMd(comment.text, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _ServiceFrequencySheet extends StatefulWidget {
  final double pricePerHour;
  final VoidCallback onClose;
  const _ServiceFrequencySheet({
    required this.pricePerHour,
    required this.onClose,
  });

  @override
  State<_ServiceFrequencySheet> createState() => _ServiceFrequencySheetState();
}

class _ServiceFrequencySheetState extends State<_ServiceFrequencySheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 20,
        left: 20,
        right: 20,
        top: 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.h3('Service frequency'),
              GestureDetector(
                onTap: widget.onClose,
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          AppText.bodySm('How many times do you want the service?'),
          const SizedBox(height: 16),

          // Weekly option
          _FreqOption(
            icon: Icons.refresh_rounded,
            title: 'Weekly',
            subtitle: 'Recurring service',
            bullets: [
              'Flexible terms: cancel or switch professionals free of charge',
              'Automatic booking and weekly payment.',
              'Cancel one-time service in 1 click',
            ],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ScheduleScreen(bookingMode: BookingMode.weekly);
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // Just once option
          _FreqOption(
            icon: Icons.looks_one_outlined,
            title: 'Just once',
            subtitle: 'One-Time service',

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ScheduleScreen(bookingMode: BookingMode.once);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FreqOption extends ConsumerWidget {
  final IconData icon;
  final String title, subtitle;
  final List<String> bullets;

  final VoidCallback onTap;

  const _FreqOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.bullets = const [],

    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryFor(ref.watch(appRoleProvider)),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.primaryFor(ref.watch(appRoleProvider)),
                  size: 22,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.labelLg(
                      title,
                      color: AppColors.primaryFor(ref.watch(appRoleProvider)),
                      fontWeight: FontWeight.w700,
                    ),
                    AppText.bodySm(subtitle),
                  ],
                ),
              ],
            ),
            if (bullets.isNotEmpty) ...[
              const SizedBox(height: 10),
              AppDivider(color: AppColors.grey300),
              const SizedBox(height: 10),
              ...bullets.map(
                (b) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_rounded,
                        color: AppColors.primaryFor(ref.watch(appRoleProvider)),
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: AppText.bodySm(b)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  GuestLoginDialog
//
//  Shows when a guest tries to tap a protected action.
//  Two CTAs: Log In → goes to login screen
//            Create Account → goes to register screen
// ─────────────────────────────────────────────────────────────

class GuestLoginDialog extends StatelessWidget {
  final VoidCallback? onLogin;
  final VoidCallback? onRegister;

  const GuestLoginDialog({super.key, this.onLogin, this.onRegister});

  /// Convenience: show from anywhere
  static Future<void> show(
    BuildContext context, {
    VoidCallback? onLogin,
    VoidCallback? onRegister,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) =>
          GuestLoginDialog(onLogin: onLogin, onRegister: onRegister),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── Close ────────────────────────────────
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.grey400,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 4),

            // ─── Icon ─────────────────────────────────
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),

            // ─── Title ────────────────────────────────
            AppText(
              'Login Required',
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // ─── Subtitle ─────────────────────────────
            AppText(
              'You need to be logged in to view availability '
              'and book a service. Please log in or create a '
              'free account.',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // ─── Log In button ────────────────────────
            AppButton.primary(label: "Log In"),
            const SizedBox(height: 10),

            // ─── Create Account button ────────────────
            AppButton.outline(label: "Create Account"),
          ],
        ),
      ),
    );
  }
}
