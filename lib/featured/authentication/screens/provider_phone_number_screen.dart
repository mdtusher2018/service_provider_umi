import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// Local provider (only used in this file)
final _loadingProvider = StateProvider.autoDispose<bool>((ref) => false);

class ProviderPhoneNumberScreen extends ConsumerStatefulWidget {
  const ProviderPhoneNumberScreen({super.key});

  @override
  ConsumerState<ProviderPhoneNumberScreen> createState() =>
      _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends ConsumerState<ProviderPhoneNumberScreen> {
  final _ctrl = TextEditingController(text: '+880 1840-560614');

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final phone = _ctrl.text.trim();
    if (phone.isEmpty) return;

    ref.read(_loadingProvider.notifier).state = true;
    // Simulate SMS send
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    ref.read(_loadingProvider.notifier).state = false;
    if (kIsWeb) {
      context.go(AppRoutes.verifyOtp, extra: phone);
    } else {
      context.push(AppRoutes.verifyOtp, extra: phone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: 24.paddingAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Title ──────────────────────────────
              AppText('Phone number', style: AppTextStyles.h1),
              8.verticalSpace,
              AppText(
                "Let's verify your phone number. We will send you an "
                'SMS with the verification code',
                style: AppTextStyles.bodySm,
              ),
              32.verticalSpace,

              // ─── Phone input ────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: 12.circular,
                  border: Border.all(color: AppColors.grey200),
                ),
                child: TextField(
                  controller: _ctrl,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s]')),
                  ],
                  style: AppTextStyles.bodyMd,
                  decoration: InputDecoration(
                    hintText: '+880 0000-000000',
                    hintStyle: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.textgrey,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              40.verticalSpace,

              // ─── Verify button ──────────────────────
              AppButton.primary(
                label: "Verify",
                onPressed: _verify,
                isLoading: ref.watch(_loadingProvider),
              ),
              16.verticalSpace,

              // ─── Phone number link ──────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.bodyMd('Phone number'),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: AppText.labelLg('OK'),
                  ),
                ],
              ),

              context.bottomPadding.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
