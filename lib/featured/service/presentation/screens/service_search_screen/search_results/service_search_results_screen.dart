import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/featured/service/presentation/screens/service_search_screen/filter_screen.dart';
import 'package:service_provider_umi/featured/profile/provider_profile_overview/provider_profile_screen.dart';
import 'package:service_provider_umi/shared/widgets/app_card.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';

part '_build_results_list.dart';
part '_faq_bottom_sheet.dart';
part '_widgets.dart';

//============================================
//================= Model ====================
//============================================
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

class SearchResultsScreen extends ConsumerStatefulWidget {
  final String category;
  const SearchResultsScreen({super.key, this.category = 'Elderly care'});

  @override
  ConsumerState<SearchResultsScreen> createState() =>
      _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  bool _showFaqSheet = false;

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
                _buildFilterRow(ref),
                _buildFaqBanner(),
                Expanded(
                  child: _buildResultsList(category: widget.category, ref: ref),
                ),
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
}
