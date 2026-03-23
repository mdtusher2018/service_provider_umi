import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final String _query = '';

  static const _popularServices = [
    _ServiceItem(
      icon: Icons.cleaning_services_outlined,
      label: 'Cleaning',
      emoji: '🧹',
    ),
    _ServiceItem(
      icon: Icons.spa_outlined,
      label: 'Manicure/Pedicure',
      emoji: '💅',
    ),
    _ServiceItem(icon: Icons.build_outlined, label: 'Handyman', emoji: '🔧'),
    _ServiceItem(
      icon: Icons.content_cut_rounded,
      label: 'Hairdressing',
      emoji: '✂️',
    ),
    _ServiceItem(icon: Icons.pets_outlined, label: 'Dog Grooming', emoji: '🐕'),
    _ServiceItem(
      icon: Icons.self_improvement_outlined,
      label: 'Massage Therapy',
      emoji: '💆',
    ),
    _ServiceItem(
      icon: Icons.school_outlined,
      label: 'Tutoring Lessons',
      emoji: '📚',
    ),
    _ServiceItem(
      icon: Icons.fitness_center_outlined,
      label: 'Personal Trainer',
      emoji: '🏋️',
    ),
    _ServiceItem(
      icon: Icons.medical_services_outlined,
      label: 'Elderly Care',
      emoji: '👴',
    ),
    _ServiceItem(
      icon: Icons.child_care_outlined,
      label: 'Child Care',
      emoji: '👶',
    ),
  ];

  List<_ServiceItem> get _filtered => _query.isEmpty
      ? _popularServices
      : _popularServices
            .where((s) => s.label.toLowerCase().contains(_query.toLowerCase()))
            .toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Search bar ───────────────────────────────
            16.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppSearchBar(
                hint: "Find the service you need",
                leading: Icon(Icons.arrow_back),
              ),
            ),

            24.verticalSpace,

            // ─── Section title ────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppText.labelLg(
                _query.isEmpty ? 'Most popular in your area' : 'Search results',
                color: AppColors.textSecondary,
              ),
            ),
            8.verticalSpace,

            // ─── List ─────────────────────────────────────
            Expanded(
              child: _filtered.isEmpty
                  ? const AppEmptyState(
                      title: 'No services found',
                      subtitle: 'Try a different search term',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _filtered.length,
                      itemBuilder: (_, i) {
                        final item = _filtered[i];
                        return _ServiceListTile(
                          item: item,
                          onTap: () {
                            // context.go('/user/services/category/${item.label}');
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceItem {
  final IconData icon;
  final String label;
  final String emoji;
  const _ServiceItem({
    required this.icon,
    required this.label,
    required this.emoji,
  });
}

class _ServiceListTile extends StatelessWidget {
  final _ServiceItem item;
  final VoidCallback? onTap;

  const _ServiceListTile({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: AppText.bodyLg(item.emoji)),
            ),
            14.horizontalSpace,
            Expanded(
              child: AppText.bodyLg(item.label, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
