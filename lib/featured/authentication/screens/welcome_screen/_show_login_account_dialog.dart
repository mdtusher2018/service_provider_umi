part of 'welcome_screen.dart';

void _showLoginAccountDialog(WidgetRef ref) {
  if (kIsWeb) {
    showWebOverlay(ref, _LoginDialog(parentRef: ref));
  } else {
    showGeneralDialog(
      context: rootNavigatorKey.currentContext!,
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

class _LoginDialog extends ConsumerStatefulWidget {
  const _LoginDialog({required this.parentRef});
  final WidgetRef parentRef;

  @override
  ConsumerState<_LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends ConsumerState<_LoginDialog> {
  final _emailController = TextEditingController(
    text: kDebugMode ? "vosod13349@getasail.com" : null,
  );

  final _passwordController = TextEditingController(
    text: kDebugMode ? "vosod13349@getasail.com" : null,
  );

  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(loginProvider, (_, state) {
      state.when(
        initial: () {},
        loading: () {},
        success: () async {
          final role = await getMyRoleId(ref);
          if (!context.mounted) return;
          // Capture notifier before closing — refs become invalid after pop
          final roleNotifier = widget.parentRef.read(appRoleProvider.notifier);
          await _close(widget.parentRef);
          if (role == 'user') {
            roleNotifier.loginAsUser();
          } else {
            roleNotifier.loginAsProvider();
          }
          final navContext = rootNavigatorKey.currentContext;
          if (navContext != null && navContext.mounted) {
            navContext.go(
              role == 'user' ? AppRoutes.userHome : AppRoutes.providerHome,
            );
          }
        },
        failure: (error) {
          setState(() {
            _errorMessage = error.message;
          });
        },
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
                AppText.h2(AppLocalizations.of(context)!.login),
                InkWell(
                  onTap: isLoading
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close),
                ),
              ],
            ),

            if (_errorMessage != null) ...[
              16.verticalSpace,
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 20),
                    8.horizontalSpace,
                    Expanded(
                      child: AppText.bodySm(
                        _errorMessage!,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            24.verticalSpace,

            AppTextField(
              controller: _emailController,
              hint: AppLocalizations.of(context)!.enterEmail,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => Validators.email(value),
            ),

            16.verticalSpace,

            AppTextField(
              controller: _passwordController,
              hint: AppLocalizations.of(context)!.password,
              obscureText: true,
              showPasswordToggle: true,
              validator: (value) => Validators.password(value),
            ),

            8.verticalSpace,

            // Forgot password link
            Align(
              alignment: Alignment.centerRight,
              child: AppLinkText(
                AppLocalizations.of(context)!.forgotPassword,
                links: [
                  AppTextLink(
                    label: AppLocalizations.of(context)!.forgotPassword,
                    onTap: () {
                      Navigator.of(context).pop();
                      _showForgotPasswordDialog(widget.parentRef);
                    },
                  ),
                ],
              ),
            ),

            16.verticalSpace,

            AppButton.primary(
              label: AppLocalizations.of(context)!.logIn,
              isLoading: isLoading,
              onPressed: isLoading
                  ? null
                  : () {
                      setState(() {
                        _errorMessage = null;
                      });
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
