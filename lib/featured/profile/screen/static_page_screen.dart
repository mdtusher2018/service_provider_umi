import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/featured/profile/riverpod/static_content_provider.dart';
import 'package:service_provider_umi/shared/enums/all_enums.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

class StaticPageScreen extends ConsumerStatefulWidget {
  final String title;
  final StaticPageType type;

  const StaticPageScreen({super.key, required this.title, required this.type});

  @override
  ConsumerState<StaticPageScreen> createState() => _StaticPageScreenState();
}

class _StaticPageScreenState extends ConsumerState<StaticPageScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch on open; only re-fetch if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final current = ref.read(staticContentProvider);
      if (current is StaticContentStateInitial) {
        ref.read(staticContentProvider.notifier).fetch();
      }
    });
  }

  /// Pick the correct field from the content object based on page type
  String _resolveContent(StaticContentStateSuccess state) {
    switch (widget.type) {
      case StaticPageType.privacy:
        return state.content.privacyPolicy ?? 'No content available.';
      case StaticPageType.terms:
        return state.content.termsAndCondition ?? 'No content available.';
      case StaticPageType.aboutUs:
        return state.content.aboutUs ?? 'No content available.';

      case StaticPageType.refundPolicy:
        return state.content.refundPolicy ?? 'No content available.';
      case StaticPageType.shippingPolicy:
        return state.content.shippingPolicy ?? 'No content available.';

      case StaticPageType.location:
        return state.content.location ?? 'No content available.';
      case StaticPageType.copyRight:
        return state.content.copyRight ?? 'No content available.';
      case StaticPageType.footerText:
        return state.content.footerText ?? 'No content available.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentState = ref.watch(staticContentProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.textPrimary,
            size: 18,
          ),
          onPressed: () => context.pop(),
        ),
        title: AppText.h3(widget.title),
        centerTitle: true,
      ),
      body: contentState.when(
        initial: () => const SizedBox.shrink(),

        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),

        success: (content) => SingleChildScrollView(
          padding: 20.paddingAll,
          child: AppText.bodyMd(
            _resolveContent(StaticContentStateSuccess(content)),
            color: AppColors.textSecondary,
            height: 1.7,
          ),
        ),

        failure: (failure) => Center(
          child: Padding(
            padding: 24.paddingAll,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.textSecondary,
                  size: 48,
                ),
                16.verticalSpace,
                AppText.bodyMd(
                  failure.message,
                  color: AppColors.textSecondary,
                  textAlign: TextAlign.center,
                ),
                24.verticalSpace,
                TextButton(
                  onPressed: () =>
                      ref.read(staticContentProvider.notifier).fetch(),
                  child: const AppText.bodyMd(
                    'Try again',
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
