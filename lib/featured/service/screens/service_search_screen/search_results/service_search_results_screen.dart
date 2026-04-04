import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/data/models/mock_service_provider_models.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
import 'package:service_provider_umi/shared/widgets/app_card.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';

part '_build_results_list.dart';
part '_faq_bottom_sheet.dart';
part '_widgets.dart';

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
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(searchServiceProvidersProvider.notifier)
          .search(SearchProvidersRequest(page: 1, limit: 10));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(context),
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
      onTap: () {
        setState(() => _showFaqSheet = true);
      },
      child: Container(
        margin: 16.paddingAll,

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
