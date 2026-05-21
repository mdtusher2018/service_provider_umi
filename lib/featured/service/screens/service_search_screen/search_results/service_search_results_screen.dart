import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/data/models/service_provider_models.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
import 'package:service_provider_umi/gen/assets.gen.dart';
import 'package:service_provider_umi/shared/widgets/app_card.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';

part '_build_results_list.dart';
part '_faq_bottom_sheet.dart';
part '_widgets.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  final String serviceId;
  final Map<String, String> queryParams;

  const SearchResultsScreen({
    super.key,
    required this.serviceId,
    required this.queryParams,
  });

  @override
  ConsumerState<SearchResultsScreen> createState() =>
      _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  bool _showFaqSheet = false;
  late final TextEditingController _searchController;
  late SearchProvidersRequest _currentRequest;

  // Tracks the last params we actually fired a search for.
  // Key insight: didUpdateWidget fires on BOTH param changes AND on pop-back
  // from a pushed route. By comparing against this we skip the pop-back case
  // and avoid resetting the provider to loading state.
  Map<String, String>? _lastFetchedParams;

  @override
  void initState() {
    super.initState();

    _currentRequest = SearchProvidersRequest.fromQueryParams(
      widget.queryParams,
      page: 1,
      limit: 10,
    );

    _searchController = TextEditingController(
      text: _currentRequest.searchTerm ?? '',
    );

    Future.microtask(() => _fetchIfParamsChanged(widget.queryParams));
  }

  @override
  void didUpdateWidget(SearchResultsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only re-fetch when query params genuinely changed in the URL.
    // Returning from FilterScreen via pop does NOT change queryParams, so this
    // guard prevents the loading flash on pop.
    if (!_mapsEqual(oldWidget.queryParams, widget.queryParams)) {
      // Wrap in Future so we never call notifier.search() while the widget
      // tree is still building (GoRouter rebuilds during navigation).
      Future(() => _fetchIfParamsChanged(widget.queryParams));
    }
  }

  void _fetchIfParamsChanged(Map<String, String> params) {
    if (!mounted) return;

    // Double-guard: if somehow called with the same params we already fetched,
    // skip entirely so the provider state is left untouched.
    if (_mapsEqual(params, _lastFetchedParams ?? {})) return;

    _lastFetchedParams = Map.unmodifiable(params);

    _currentRequest = SearchProvidersRequest.fromQueryParams(
      params,
      page: 1,
      limit: 10,
    );

    final term = _currentRequest.searchTerm ?? '';
    if (_searchController.text != term) {
      _searchController.text = term;
    }

    ref.read(searchServiceProvidersProvider.notifier).search(_currentRequest);
  }

  bool _mapsEqual(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }

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
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(context),
                _buildFilterRow(ref, widget.serviceId),
                _buildFaqBanner(),
                Expanded(child: _buildResultsList(ref: ref)),
              ],
            ),
            if (_showFaqSheet)
              _buildFaqOverlay(
                show: () => setState(() => _showFaqSheet = true),
                hideBottomsheet: () => setState(() => _showFaqSheet = false),
                serviceId: widget.serviceId,
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
