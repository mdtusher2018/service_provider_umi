import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/featured/filter_screen.dart';
import 'package:service_provider_umi/featured/provider_profile_screen.dart';
import 'package:service_provider_umi/shared/widgets/app_card.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';

part 'faq_bottom_sheet.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  final String category;
  const SearchResultsScreen({super.key, this.category = 'Elderly care'});

  @override
  ConsumerState<SearchResultsScreen> createState() =>
      _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  bool _showFaqSheet = false;

  // Mocked provider results
  final List<_ProviderResult> _providers = [
    _ProviderResult(
      id: '1',
      name: 'NB Sujon',
      rating: 5.0,
      reviews: 1,
      serviceCount: 2,
      pricePerHour: 10,
      isVerified: true,
      hasRepeated: true,
      hasUpdatedSchedule: true,
    ),
    _ProviderResult(
      id: '2',
      name: 'NB Sujon',
      rating: 5.0,
      reviews: 1,
      serviceCount: 2,
      pricePerHour: 15,
      isVerified: true,
      hasRepeated: false,
      hasUpdatedSchedule: true,
    ),
    _ProviderResult(
      id: '3',
      name: 'NB Sujon',
      rating: 5.0,
      reviews: 1,
      serviceCount: 2,
      pricePerHour: 20,
      isVerified: true,
      hasRepeated: true,
      hasUpdatedSchedule: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                _buildFilterRow(),
                _buildFaqBanner(),
                Expanded(child: _buildResultsList()),
              ],
            ),
            if (_showFaqSheet)
              _buildFaqOverlay(
                show: () => setState(() => _showFaqSheet = true),
                hideBottomsheet: () => setState(() => _showFaqSheet = false),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          10.horizontalSpace,
          Expanded(
            child: AppTextField(
              prefixIcon: Icon(Icons.arrow_back),
              fillColor: AppColors.white,
            ),
          ),

          10.horizontalSpace,
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.black),
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              color: AppColors.black,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          _FilterChip(
            icon: Icons.calendar_today_outlined,
            label: 'When?',
            onTap: () {},
          ),
          8.horizontalSpace,
          _FilterChip(
            icon: Icons.tune_rounded,
            label: 'Filters',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return FilterScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFaqBanner() {
    return GestureDetector(
      onTap: () => setState(() => _showFaqSheet = true),
      child: Container(
        margin: const EdgeInsets.all(16),

        child: Row(
          children: [
            const Icon(Icons.info, color: AppColors.primary, size: 18),
            8.horizontalSpace,
            AppText.bodyMd(
              'How does the service work?',
              fontWeight: FontWeight.w500,
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: _providers.length,
      separatorBuilder: (_, __) => 12.verticalSpace,
      itemBuilder: (_, i) {
        final p = _providers[i];
        return ProviderCard(
          name: p.name,
          serviceType: widget.category,
          rating: p.rating,
          reviewCount: p.reviews,
          serviceCount: p.serviceCount,
          pricePerHour: p.pricePerHour,
          isVerified: p.isVerified,
          hasRepeated: p.hasRepeated,
          hasUpdatedSchedule: p.hasUpdatedSchedule,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ProviderProfileScreen(providerId: "");
                },
              ),
            );
          },
          onFavorite: () {},
        );
      },
    );
  }
}

class _ProviderResult {
  final String id, name;
  final double rating, pricePerHour;
  final int reviews, serviceCount;
  final bool isVerified, hasRepeated, hasUpdatedSchedule;
  const _ProviderResult({
    required this.id,
    required this.name,
    required this.rating,
    required this.reviews,
    required this.serviceCount,
    required this.pricePerHour,
    required this.isVerified,
    required this.hasRepeated,
    required this.hasUpdatedSchedule,
  });
}

class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _FilterChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.grey800),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.textPrimary),
            6.horizontalSpace,
            AppText.labelLg(label),
          ],
        ),
      ),
    );
  }
}
