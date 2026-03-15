import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import '../../../../core/di/app_role_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'verify_code_screen.dart';

class PhoneNumberScreen extends ConsumerStatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  ConsumerState<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends ConsumerState<PhoneNumberScreen> {
  final _ctrl = TextEditingController(text: '+880 1840-560614');
  bool _isLoading = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final phone = _ctrl.text.trim();
    if (phone.isEmpty) return;

    setState(() => _isLoading = true);
    // Simulate SMS send
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => VerifyCodeScreen(phoneNumber: phone)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(appRoleProvider);
    final primary = AppColors.primaryFor(role);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Title ──────────────────────────────
              AppText('Phone number', style: AppTextStyles.h1),
              const SizedBox(height: 8),
              AppText(
                "Let's verify your phone number. We will send you an "
                'SMS with the verification code',
                style: AppTextStyles.bodySm,
              ),
              const SizedBox(height: 32),

              // ─── Phone input ────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
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
              SizedBox(height: 40),

              // ─── Verify button ──────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : Text('Verify', style: AppTextStyles.buttonLg),
                ),
              ),
              const SizedBox(height: 16),

              // ─── Phone number link ──────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Phone number',
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.grey400,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(
                      'OK',
                      style: AppTextStyles.labelLg.copyWith(color: primary),
                    ),
                  ),
                ],
              ),

              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
