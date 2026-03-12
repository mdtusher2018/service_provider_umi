import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_colors.dart';
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
    'Punctuality': 5.0,
    'Kindness': 5.0,
    'Value for money': 5.0,
    'Professionalism': 5.0,
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
                  child: Column(
                    children: [
                      _buildProfileHeader(),
                      _buildAboutSection(),
                      _buildQaSection(),
                      _buildGallery(),
                      _buildRatingSection(),
                      _buildComments(),
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
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          AppAvatar(name: _mockProvider.name, size: AvatarSize.xl),
          const SizedBox(height: 12),
          AppText.h2(_mockProvider.name),
          const SizedBox(height: 4),
          AppText.labelLg(_mockProvider.specialty, color: AppColors.primary),
          const SizedBox(height: 16),
          const AppDivider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
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
                value: '✓',
                label: 'Verified',
                valueColor: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.h3('About me'),
          const SizedBox(height: 10),
          AppText.bodyMd(_mockProvider.bio, color: AppColors.textSecondary),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {},
            child: AppText.labelMd(
              '+View more',
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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

    return _SectionCard(
      child: Column(
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
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 4),
                  AppText.bodyMd(qa.$2, color: AppColors.textSecondary),
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
      ),
    );
  }

  Widget _buildGallery() {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.h3('Gallery'),
              GestureDetector(
                onTap: () {},
                child: AppText.labelMd(
                  'View gallery',
                  color: AppColors.primary,
                ),
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
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.image_outlined,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return _SectionCard(
      child: AppRatingBreakdown(
        overall: _mockProvider.rating,
        totalReviews: _mockProvider.reviewCount,
        breakdown: _ratingBreakdown,
      ),
    );
  }

  Widget _buildComments() {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.h3('Comments'),
          const SizedBox(height: 12),
          ..._comments.map((c) => _CommentTile(comment: c)),
        ],
      ),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.h1(
                '\$${_mockProvider.pricePerHour.toStringAsFixed(0)}/h',
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: AppButton.primary(
              label: 'View availability',
              onPressed: () => setState(() => _showFrequencySheet = true),
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
class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value, label;
  final Color? valueColor;
  const _StatItem({required this.value, required this.label, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText.h3(value, color: valueColor ?? AppColors.textPrimary),
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

class _CommentTile extends StatelessWidget {
  final _CommentData comment;
  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
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
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                          size: 12,
                        ),
                        const SizedBox(width: 2),
                        AppText.bodySm(
                          'Verified service',
                          color: AppColors.primary,
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
  bool _isWeekly = true;

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
            isSelected: _isWeekly,
            onTap: () => setState(() => _isWeekly = true),
          ),
          const SizedBox(height: 12),

          // Just once option
          _FreqOption(
            icon: Icons.looks_one_outlined,
            title: 'Just once',
            subtitle: 'One-Time service',
            isSelected: !_isWeekly,
            onTap: () => setState(() => _isWeekly = false),
          ),
          const SizedBox(height: 24),

          AppButton.primary(
            label: 'Set up at least one day',
            onPressed: () {
              widget.onClose();
              // Navigate to weekly schedule screen
            },
          ),
        ],
      ),
    );
  }
}

class _FreqOption extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final List<String> bullets;
  final bool isSelected;
  final VoidCallback onTap;

  const _FreqOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.bullets = const [],
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.grey50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
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
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.labelLg(
                      title,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                    AppText.bodySm(subtitle),
                  ],
                ),
              ],
            ),
            if (bullets.isNotEmpty && isSelected) ...[
              const SizedBox(height: 10),
              const AppDivider(),
              const SizedBox(height: 10),
              ...bullets.map(
                (b) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_rounded,
                        color: AppColors.primary,
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
