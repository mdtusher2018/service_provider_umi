import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
import 'package:service_provider_umi/shared/widgets/app_error_widget.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import 'package:service_provider_umi/data/models/category_models.dart';
import 'package:service_provider_umi/gen/assets.gen.dart';

class SearchSubcategoryScreen extends ConsumerWidget {
  final String categoryId;
  const SearchSubcategoryScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subcategoriesState = ref.watch(subcategoriesProvider(categoryId));
    final categoriesState = ref.watch(categoriesProvider);

    String categoryName = "Subcategories";
    categoriesState.whenData((categories) {
      try {
        final cat = categories.firstWhere((c) => c.id == categoryId);
        categoryName = cat.name;
      } catch (_) {}
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo
                Image.asset(Assets.logoPng.keyName, height: 160),
                Row(
                  spacing: 16,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: AppColors.black,
                        ),
                        onPressed: () {
                          if (kIsWeb) {
                            context.go(AppRoutes.search);
                          } else {
                            context.push(AppRoutes.search);
                          }
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.notifications_none_sharp,
                          color: AppColors.black,
                        ),
                        onPressed: () {
                          if (kIsWeb) {
                            context.go(AppRoutes.userNotifications);
                          } else {
                            context.push(AppRoutes.userNotifications);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => context.pop(),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              8.horizontalSpace,
              AppText.h2(categoryName, color: AppColors.primary),
            ],
          ),
          24.verticalSpace,
          Expanded(
            child: subcategoriesState.when(
              loading: () => const AppLoader(),
              error: (e, _) => AppErrorWidget(
                error: e,
                onRetry: () => ref.refresh(subcategoriesProvider(categoryId)),
              ),
              data: (subcategories) {
                if (subcategories.isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (kIsWeb) {
                      context.go(AppRoutes.searchTimePath(categoryId));
                    } else {
                      context.pushReplacement(AppRoutes.searchTimePath(categoryId));
                    }
                  });
                  return const AppLoader();
                }

                return Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      alignment: WrapAlignment.center,
                      children: subcategories.map((sub) {
                        return _SubcategoryItem(
                          item: sub,
                          categoryId: categoryId,
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SubcategoryItem extends StatefulWidget {
  final SubCategoryModel item;
  final String categoryId;

  const _SubcategoryItem({required this.item, required this.categoryId});

  @override
  State<_SubcategoryItem> createState() => _SubcategoryItemState();
}

class _SubcategoryItemState extends State<_SubcategoryItem> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => scale = 0.95),
      onTapUp: (_) => setState(() => scale = 1.0),
      onTapCancel: () => setState(() => scale = 1.0),
      onTap: () {
        if (kIsWeb) {
          context.go(AppRoutes.searchTimePath(widget.categoryId, subcategoryIds: widget.item.id));
        } else {
          context.push(AppRoutes.searchTimePath(widget.categoryId, subcategoryIds: widget.item.id));
        }
      },
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: 90,
          height: 90,
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  image: widget.item.image != null && widget.item.image!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(widget.item.image!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: widget.item.image == null || widget.item.image!.isEmpty
                    ? const Icon(Icons.category, size: 30, color: AppColors.grey400)
                    : null,
              ),
              8.verticalSpace,
              AppText.bodySm(widget.item.name, fontWeight: FontWeight.w500, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
