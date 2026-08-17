import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/error/app_exception.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/data/models/category_models.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_error_widget.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import 'package:service_provider_umi/l10n/app_localizations.dart';

class SearchCategoryScreen extends ConsumerStatefulWidget {
  const SearchCategoryScreen({super.key});

  @override
  ConsumerState<SearchCategoryScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchCategoryScreen> {
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

  List<CategoryModel> _filtered(List<CategoryModel> services) {
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
                hint: AppLocalizations.of(context)!.findTheServiceYouNeed,
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
                _query.isEmpty ? AppLocalizations.of(context)!.mostPopularInYourArea : AppLocalizations.of(context)!.searchResults,
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

                  error: (e, _) => AppErrorWidget(
                    error: e,
                    onRetry: () => ref.read(categoriesProvider.notifier).fetch(),
                  ),

                  data: (services) {
                    final filtered = _filtered(services);

                    if (filtered.isEmpty) {
                      return AppEmptyState(
                        title: AppLocalizations.of(context)!.noServicesFound,
                        subtitle: AppLocalizations.of(context)!.tryADifferentSearchTerm,
                      );
                    }

                    return ListView.builder(
                      padding: 20.paddingH,
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final item = filtered[i];

                        return _ServiceListTile(
                          item: item,
                          onTap: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const Center(child: CircularProgressIndicator()),
                            );

                            try {
                              final subcategories = await ref.read(subcategoriesProvider(item.id).future);
                              if (!context.mounted) return;
                              Navigator.of(context).pop(); // Dismiss loading

                              if (subcategories.isNotEmpty) {
                                if (kIsWeb) {
                                  context.go(AppRoutes.searchSubcategoryPath(item.id));
                                } else {
                                  context.push(AppRoutes.searchSubcategoryPath(item.id));
                                }
                              } else {
                                if (kIsWeb) {
                                  context.go(AppRoutes.searchTimePath(item.id));
                                } else {
                                  context.push(AppRoutes.searchTimePath(item.id));
                                }
                              }
                            } catch (e) {
                              if (context.mounted) Navigator.of(context).pop();
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
  final CategoryModel item;
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
