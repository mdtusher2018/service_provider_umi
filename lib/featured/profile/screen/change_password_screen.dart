import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/core/utils/validators.dart';
import 'package:service_provider_umi/featured/authentication/riverpod/auth_provider.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';
import 'package:service_provider_umi/l10n/app_localizations.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _oldCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _oldCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ── Listen for API result ─────────────────────────────────────────────────
    ref.listen(changePasswordProvider, (_, state) {
      state.when(
        initial: () {},
        loading: () {},
        success: () {
          context.showSnackBar(AppLocalizations.of(context)!.passwordChangedSuccessfully);
          context.pop();
        },
        failure: (e) => context.showErrorSnackBar(e.message),
      );
    });

    final isLoading = ref.watch(changePasswordProvider) is AuthLoading;

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
        title: AppText.h3(AppLocalizations.of(context)!.changePassword),
        centerTitle: true,
      ),
      body: Padding(
        padding: 20.paddingAll,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                hint: AppLocalizations.of(context)!.currentPassword,
                controller: _oldCtrl,
                label: AppLocalizations.of(context)!.oldPassword,
                showPasswordToggle: true,
                validator: (v) =>
                    v == null || v.isEmpty ? AppLocalizations.of(context)!.enterOldPassword : null,
              ),
              16.verticalSpace,
              AppTextField(
                hint: AppLocalizations.of(context)!.newPassword,
                controller: _newCtrl,
                label: AppLocalizations.of(context)!.newPassword,
                showPasswordToggle: true,
                validator: (v) => Validators.password(v),
              ),
              16.verticalSpace,
              AppTextField(
                hint: AppLocalizations.of(context)!.confirmNewPassword,
                controller: _confirmCtrl,
                label: AppLocalizations.of(context)!.confirmPassword,
                showPasswordToggle: true,

                validator: (v) => Validators.confirmPassword(v, _newCtrl.text),
              ),
              32.verticalSpace,
              AppButton.primary(
                label: AppLocalizations.of(context)!.changePassword,
                isLoading: isLoading,
                onPressed: isLoading ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(changePasswordProvider.notifier)
        .changePassword(
          oldPassword: _oldCtrl.text,
          newPassword: _newCtrl.text,
          confirmPassword: _confirmCtrl.text,
        );
  }
}
