import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/services/network/api_endpoints.dart';
import 'package:service_provider_umi/core/services/network/dio_client.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';

class SupportMessageScreen extends ConsumerStatefulWidget {
  const SupportMessageScreen({super.key});

  @override
  ConsumerState<SupportMessageScreen> createState() => _SupportMessageScreenState();
}

class _SupportMessageScreenState extends ConsumerState<SupportMessageScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

    try {
      final dio = ref.read(dioClientProvider);
      await dio.post(
        ApiEndpoints.supportMessage,
        data: {
          "name": _nameController.text.trim(),
          "email": _emailController.text.trim(),
          "subject": _subjectController.text.trim(),
          "message": _messageController.text.trim(),
        },
      );

      if (!mounted) return;
      context.showSnackBar('Your message has been sent successfully.');
      context.pop();
    } catch (e) {
      if (!mounted) return;
      context.showErrorSnackBar('Failed to send message. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leadingWidth: 110,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: InkWell(
              onTap: () => context.pop(),
              borderRadius: 8.circular,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey200),
                  borderRadius: 8.circular,
                  color: AppColors.white,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back_ios_rounded, size: 14, color: AppColors.textPrimary),
                    4.horizontalSpace,
                    const AppText.bodySm('Go back', fontWeight: FontWeight.w600),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppText.h1('Iumi Admin Support', textAlign: TextAlign.center),
                8.verticalSpace,
                const AppText.bodyMd(
                  'Have a question or need assistance? Send us a message and we\'ll get back to you.',
                  color: AppColors.textSecondary,
                  textAlign: TextAlign.center,
                ),
                32.verticalSpace,

                // Full name
                const AppText.bodySm('Full name', fontWeight: FontWeight.w600),
                8.verticalSpace,
                AppTextField(
                  controller: _nameController,
                  hint: 'John Doe',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Please enter your full name';
                    return null;
                  },
                ),
                20.verticalSpace,

                // Email
                const AppText.bodySm('Email address', fontWeight: FontWeight.w600),
                8.verticalSpace,
                AppTextField(
                  controller: _emailController,
                  hint: 'john.doe@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Please enter your email';
                    if (!val.contains('@')) return 'Please enter a valid email';
                    return null;
                  },
                ),
                20.verticalSpace,

                // Subject
                const AppText.bodySm('Subject', fontWeight: FontWeight.w600),
                8.verticalSpace,
                AppTextField(
                  controller: _subjectController,
                  hint: 'What can we help you with?',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Please enter a subject';
                    return null;
                  },
                ),
                20.verticalSpace,

                // Message
                const AppText.bodySm('Your message', fontWeight: FontWeight.w600),
                8.verticalSpace,
                AppTextField(
                  controller: _messageController,
                  hint: 'Describe your issue or question...',
                  maxLines: 6,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Please enter your message';
                    return null;
                  },
                ),
                32.verticalSpace,

                AppButton.primary(
                  label: 'Send Message',
                  isLoading: _isLoading,
                  onPressed: _submit,
                ),
                24.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
