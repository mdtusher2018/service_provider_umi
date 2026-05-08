import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/error/app_exception.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/data/models/service_models.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
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

  String _query = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoriesProvider.notifier).fetch();
    });

    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ServiceModel> _filtered(List<ServiceModel> services) {
    if (_query.isEmpty) return services;

    return services
        .where((s) => s.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.verticalSpace,

            /// SEARCH BAR
            Padding(
              padding: 16.paddingH,
              child: AppSearchBar(
                controller: _searchController,
                hint: "Find the service you need",
                leading: kIsWeb
                    ? null
                    : InkWell(
                        onTap: () => context.pop(),
                        child: const Icon(Icons.arrow_back),
                      ),
              ),
            ),

            24.verticalSpace,

            /// TITLE
            Padding(
              padding: 20.paddingH,
              child: AppText.labelLg(
                _query.isEmpty ? 'Most popular in your area' : 'Search results',
                color: AppColors.textSecondary,
              ),
            ),

            8.verticalSpace,

            /// API DATA
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref.read(categoriesProvider.notifier).fetch();
                },
                child: state.when(
                  loading: () => const AppLoader(),

                  error: (e, _) => Center(
                    child: AppText.h4(
                      (e is AppException) ? e.message : e.toString(),
                    ),
                  ),

                  data: (services) {
                    final filtered = _filtered(services);

                    if (filtered.isEmpty) {
                      return const AppEmptyState(
                        title: 'No services found',
                        subtitle: 'Try a different search term',
                      );
                    }

                    return ListView.builder(
                      padding: 20.paddingH,
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final item = filtered[i];

                        return _ServiceListTile(
                          item: item,
                          onTap: () {
                            if (kIsWeb) {
                              context.go(AppRoutes.searchTimePath(item.id));
                            } else {
                              context.push(AppRoutes.searchTimePath(item.id));
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceListTile extends StatelessWidget {
  final ServiceModel item;
  final VoidCallback? onTap;

  const _ServiceListTile({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: 12.circular,
      child: Padding(
        padding: 12.paddingV,
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: 10.circular,
              ),
              clipBehavior: Clip.antiAlias,
              child: item.image != null && item.image!.isNotEmpty
                  ? Image.network(
                      item.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return const Icon(Icons.image_not_supported);
                      },
                    )
                  : const Icon(Icons.image),
            ),

            14.horizontalSpace,

            Expanded(
              child: AppText.bodyLg(item.name, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
