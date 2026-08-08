import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/featured/profile/riverpod/user_provider.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';
import 'package:service_provider_umi/l10n/app_localizations.dart';

class AddFaqScreen extends ConsumerStatefulWidget {
  final String userId;

  const AddFaqScreen({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<AddFaqScreen> createState() => _AddFaqScreenState();
}

class _AddFaqScreenState extends ConsumerState<AddFaqScreen> {
  final _questionCtrl = TextEditingController(text: kDebugMode? 'where are you from?' : '');
  final _answerCtrl = TextEditingController(text: kDebugMode? 'I am from Dhaka' : '');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _questionCtrl.dispose();
    _answerCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(addFaqProvider.notifier).addFaq(
          question: _questionCtrl.text.trim(),
          answer: _answerCtrl.text.trim(),
          userId: widget.userId,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(addFaqProvider, (previous, next) {
      next.whenOrNull(
        success: () {
          context.showSnackBar(AppLocalizations.of(context)!.faqAddedSuccessfully);
          context.pop();
        },
        failure: (failure) {
          context.showErrorSnackBar(failure.message);
        },
      );
    });

    final state = ref.watch(addFaqProvider);
    final isLoading = state is ActionStateLoading;

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
        title: AppText.h3(AppLocalizations.of(context)!.addFaq),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: 20.paddingAll,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  label: AppLocalizations.of(context)!.question,
                  hint: AppLocalizations.of(context)!.enterYourQuestion,
                  controller: _questionCtrl,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterQuestion;
                    }
                    return null;
                  },
                ),
                20.verticalSpace,
                AppTextField(
                  label: AppLocalizations.of(context)!.answer,
                  hint: AppLocalizations.of(context)!.enterYourAnswer,
                  controller: _answerCtrl,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterAnswer;
                    }
                    return null;
                  },
                ),
                32.verticalSpace,
                AppButton.primary(
                  label: AppLocalizations.of(context)!.submitFaq,
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
