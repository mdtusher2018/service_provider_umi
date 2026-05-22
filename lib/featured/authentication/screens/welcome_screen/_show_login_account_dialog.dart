part of 'welcome_screen.dart';

void _showLoginAccountDialog(WidgetRef ref) {
  if (kIsWeb) {
    showWebOverlay(ref, _LoginDialog(parentRef: ref));
  } else {
    showGeneralDialog(
      context: ref.context,
      transitionDuration: dialogSlidingFadeTransitionDuration,
      transitionBuilder: dialogSlideFadeTransition,
      pageBuilder: (_, _, _) => Dialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: 20.circular),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: _LoginDialog(parentRef: ref),
      ),
    );
  }
}

class _LoginDialog extends ConsumerWidget {
  _LoginDialog({required this.parentRef});
  final WidgetRef parentRef;

  final _emailController = TextEditingController(
    text: kDebugMode ? "vosod13349@getasail.com" : null,
  );

  final _passwordController = TextEditingController(
    text: kDebugMode ? "vosod13349@getasail.com" : null,
  );

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(loginProvider, (_, state) {
      state.when(
        initial: () {},
        loading: () {},
        success: () async {
          final role = await getMyRoleId(ref);
          if (role == 'user') {
            if (kIsWeb) {
              await _close(parentRef);
            }
            parentRef.read(appRoleProvider.notifier).loginAsUser();
            context.go(AppRoutes.userHome);
          } else {
            if (kIsWeb) {
              await _close(parentRef);
            }
            parentRef.read(appRoleProvider.notifier).loginAsProvider();
            context.go(AppRoutes.providerHome);
          }
        },
        failure: (error) => context.showErrorSnackBar(error.message),
      );
    });

    final isLoading = ref.watch(loginProvider) is AuthLoading;

    return Padding(
      padding: 24.paddingAll,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppText.h2('Login'),
                InkWell(
                  onTap: isLoading
                      ? null
                      : () async {
                          await _close(parentRef);
                        },
                  child: const Icon(Icons.close),
                ),
              ],
            ),

            24.verticalSpace,

            AppTextField(
              controller: _emailController,
              hint: 'Enter email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) => Validators.email(value),
            ),

            16.verticalSpace,

            AppTextField(
              controller: _passwordController,
              hint: 'Password',
              obscureText: true,
              showPasswordToggle: true,
              validator: (value) => Validators.password(value),
            ),

            8.verticalSpace,

            // Forgot password link
            Align(
              alignment: Alignment.centerRight,
              child: AppLinkText(
                'Forgot password?',
                links: [
                  AppTextLink(
                    label: 'Forgot password?',
                    onTap: () async {
                      await _close(parentRef);
                      _showForgotPasswordDialog(parentRef);
                    },
                  ),
                ],
              ),
            ),

            16.verticalSpace,

            AppButton.primary(
              label: 'Log in',
              isLoading: isLoading,
              onPressed: isLoading
                  ? null
                  : () {
                      if (!_formKey.currentState!.validate()) return;
                      ref
                          .read(loginProvider.notifier)
                          .withEmail(
                            _emailController.text.trim(),
                            _passwordController.text,
                          );
                    },
            ),

            16.verticalSpace,
          ],
        ),
      ),
    );
  }
}
