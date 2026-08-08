import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/featured/profile/riverpod/static_content_provider.dart';
import 'package:service_provider_umi/shared/enums/all_enums.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_error_widget.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import 'package:service_provider_umi/l10n/app_localizations.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final current = ref.read(staticContentProvider);
      if (current is StaticContentStateInitial) {
        ref.read(staticContentProvider.notifier).fetch();
      }
    });
  }

  String _resolveContent(StaticContentStateSuccess state) {
    switch (widget.type) {
      case StaticPageType.privacy:
        return state.content.privacyPolicy ?? '';
      case StaticPageType.terms:
        return state.content.termsAndCondition ?? '';
      case StaticPageType.aboutUs:
        return state.content.aboutUs ?? '';
      case StaticPageType.refundPolicy:
        return state.content.refundPolicy ?? '';
      case StaticPageType.shippingPolicy:
        return state.content.shippingPolicy ?? '';
      case StaticPageType.location:
        return state.content.location ?? '';
      case StaticPageType.copyRight:
        return state.content.copyRight ?? '';
      case StaticPageType.footerText:
        return state.content.footerText ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentState = ref.watch(staticContentProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
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

      body: Container(
        margin: 16.paddingAll,
        padding: 16.paddingAll,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: 16.circular,
          color: AppColors.white,
        ),
        child: contentState.when(
          initial: () => const SizedBox.shrink(),

          loading: () => const AppLoader(),

          success: (content) {
            final htmlContent = _resolveContent(
              StaticContentStateSuccess(content),
            );

            // ✅ Friendly fallback if field is empty
            if (htmlContent.trim().isEmpty) {
              return Center(
                child: AppText.bodyMd(
                  AppLocalizations.of(context)!.noContentAvailable,
                  color: AppColors.textSecondary,
                ),
              );
            }

            return SingleChildScrollView(
              // ✅ flutter_html renders HTML tags properly —
              // handles <p>, <h1-h3>, <strong>, <a>, <ul>, <li>, etc.
              child: Html(data: htmlContent),
            );
          },

          failure: (failure) => AppErrorWidget(
            error: failure.message,
            onRetry: () => ref.read(staticContentProvider.notifier).fetch(),
          ),
        ),
      ),
    );
  }
}
