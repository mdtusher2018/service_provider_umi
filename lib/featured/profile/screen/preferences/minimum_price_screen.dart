import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/shared/widgets/app_link_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';
import '../../../../core/di/app_role_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

// ════════════════════════════════════════════════════════════
//  3. Minimum Price Screen
// ════════════════════════════════════════════════════════════
class MinimumPriceScreen extends ConsumerStatefulWidget {
  const MinimumPriceScreen({super.key});

  @override
  ConsumerState<MinimumPriceScreen> createState() => _MinimumPriceScreenState();
}

class _MinimumPriceScreenState extends ConsumerState<MinimumPriceScreen> {
  double _price = 15;
  bool _isSaving = false;

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isSaving = false);
    context.showSnackBar('Minimum price saved successfully');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryFor(ref.watch(appRoleProvider));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: primary, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.h1('Minimum price'),
            8.verticalSpace,
            AppLinkText(
              "What is the minimum price a client must pay to book your service?  +info",
              links: [AppTextLink(label: "+info", onTap: () {})],
              linkColor: AppColors.primaryFor(AppRole.provider),
            ),

            32.verticalSpace,

            // ─── Price input box ──────────────────────
            Center(
              child: Container(
                width: 180,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: 14.circular,
                  border: Border.all(color: primary, width: 1.5),
                ),
                child: Column(
                  children: [
                    AppText.bodyMd('Minimum price:'),
                    8.verticalSpace,
                    Row(
                      spacing: 4,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: AppTextField()),
                        // Stepper controls
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => _price += 1),
                              child: Icon(
                                Icons.keyboard_arrow_up_rounded,
                                color: AppColors.grey400,
                                size: 22,
                              ),
                            ),
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.textPrimary,
                                  width: 1.5,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: AppText.labelLg(
                                  '\$',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() {
                                if (_price > 1) _price -= 1;
                              }),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.grey400,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            24.verticalSpace,

            // ─── Tip banner ──────────────────────────
            Container(
              padding: 14.paddingAll,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: 12.circular,
                border: Border.all(color: AppColors.grey200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText('💡', fontSize: 18),
                  10.horizontalSpace,
                  Expanded(
                    child: AppText.bodySm(
                      "This will avoid being booked for a price so low that it's "
                      'not worth your time to commute to the service',
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ─── Save button ─────────────────────────
            Padding(
              padding: EdgeInsets.only(bottom: context.bottomPadding + 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: 12.circular),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : AppText('Save', style: AppTextStyles.buttonLg),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
