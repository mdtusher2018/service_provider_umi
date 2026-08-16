part of 'welcome_screen.dart';

void _showCreateAccountDialog(WidgetRef ref, {required AppRole role}) {
  if (kIsWeb) {
    showWebOverlay(ref, _SignupDialog(role: role, parentRef: ref));
  } else {
    showGeneralDialog(
      context: rootNavigatorKey.currentContext!,
      transitionDuration: dialogSlidingFadeTransitionDuration,
      transitionBuilder: dialogSlideFadeTransition,
      pageBuilder: (_, _, _) => Dialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: 20.circular),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: _SignupDialog(role: role, parentRef: ref),
      ),
    );
  }
}

class _SignupDialog extends ConsumerStatefulWidget {
  final AppRole role;
  final WidgetRef parentRef;
  const _SignupDialog({required this.role, required this.parentRef});

  @override
  ConsumerState<_SignupDialog> createState() => _SignupDialogState();
}

class _SignupDialogState extends ConsumerState<_SignupDialog> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _termsAccepted = false;
  bool _showTermsError = false;
  double? _lat;
  double? _lng;
  bool _isGeocoding = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    // ✅ Listen to auth state (same as login)
    ref.listen<AuthState>(signupProvider, (_, state) {
      state.when(
        initial: () {},
        loading: () {},
        success: () async {
          if (!kIsWeb) {
            Navigator.of(context).pop();
          }

          _showOTPVerifyDialog(
            widget.parentRef,
            email: _emailController.text.trim(),
            isSignup: true,
            role: widget.role,
          );
        },
        failure: (error) {
          setState(() {
            _errorMessage = error.message;
          });
        },
      );
    });

    final isLoading = ref.watch(signupProvider) is AuthLoading;

    return Padding(
      padding: 24.paddingAll,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.h2(AppLocalizations.of(context)!.createAccountTitle),
                InkWell(
                  onTap: isLoading
                      ? null
                      : () async {
                          await _close(ref);
                        },
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

            /// Name
            AppTextField(
              controller: _nameController,
              hint: AppLocalizations.of(context)!.enterYourName,
              validator: (value) => Validators.required(value),
            ),

            16.verticalSpace,

            /// Email
            AppTextField(
              controller: _emailController,
              hint: AppLocalizations.of(context)!.enterEmail,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => Validators.email(value),
            ),

            16.verticalSpace,

            /// Password
            AppTextField(
              controller: _passwordController,
              hint: AppLocalizations.of(context)!.password,
              obscureText: true,
              showPasswordToggle: true,
              validator: (value) => Validators.password(value),
            ),

            16.verticalSpace,

            /// Confirm Password
            AppTextField(
              controller: _confirmPasswordController,
              hint: AppLocalizations.of(context)!.confirmPassword,
              obscureText: true,
              showPasswordToggle: true,
              validator: (value) => Validators.confirmPassword(value, _passwordController.text),
            ),

            16.verticalSpace,

            /// Phone Number
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.bodyLg(AppLocalizations.of(context)!.phoneNumber, color: AppColors.textPrimary),
                8.verticalSpace,
                AppTextField(
                  controller: _phoneController,
                  hint: "+1234567890",
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),

            16.verticalSpace,

            /// Location
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.bodyLg(
                    widget.role == AppRole.provider ? AppLocalizations.of(context)!.serviceLocation : AppLocalizations.of(context)!.yourLocation,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  8.verticalSpace,
                  AppText.bodySm(
                    widget.role == AppRole.provider
                        ? AppLocalizations.of(context)!.searchAndSelectServiceArea
                        : AppLocalizations.of(context)!.weUseLocationForServices,
                    color: AppColors.grey500,
                  ),
                  12.verticalSpace,
                  AppTextField(
                    controller: _locationController,
                    hint: AppLocalizations.of(context)!.searchCitySuburbAddress,
                    prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.grey500),
                  ),
                ],
              ),
            ),

            24.verticalSpace,

            /// Terms Checkbox
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _termsAccepted,
                        activeColor: AppColors.primary,
                        side: _showTermsError ? const BorderSide(color: Colors.red, width: 2) : null,
                        onChanged: (val) {
                          setState(() {
                            _termsAccepted = val ?? false;
                            if (_termsAccepted) {
                              _showTermsError = false;
                            }
                          });
                        },
                      ),
                    ),
                    8.horizontalSpace,
                    Expanded(
                      child: AppLinkText(
                        AppLocalizations.of(context)!.acceptTermsPrivacy,
                        textSize: 12,
                        links: [
                          AppTextLink(
                            label: AppLocalizations.of(context)!.termsAndCondition,
                            onTap: () {
                              context.push('/profile/terms');
                            },
                          ),
                          AppTextLink(
                            label: AppLocalizations.of(context)!.privacyPolicy,
                            onTap: () {
                              context.push('/profile/privacy');
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (_showTermsError) ...[
                  8.verticalSpace,
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: AppText.bodySm(
                      AppLocalizations.of(context)!.pleaseAcceptTerms,
                      color: Colors.red,
                    ),
                  ),
                ],
              ],
            ),

            24.verticalSpace,

            /// Signup Button
            AppButton.primary(
              label: AppLocalizations.of(context)!.createAccountBtn,
              isLoading: isLoading || _isGeocoding,
              onPressed: () async {
                setState(() {
                  _errorMessage = null;
                });
                
                if (!_formKey.currentState!.validate()) return;
                
                if (!_termsAccepted) {
                  setState(() {
                    _showTermsError = true;
                  });
                  return;
                }

                String city = '';
                String state = '';
                String postalCode = '';
                String country = '';

                if (_locationController.text.trim().isNotEmpty) {
                  try {
                    setState(() {
                      _isGeocoding = true;
                    });
                    final locations = await locationFromAddress(_locationController.text.trim());
                    if (locations.isNotEmpty) {
                      _lat = locations.first.latitude;
                      _lng = locations.first.longitude;
                      
                      final placemarks = await placemarkFromCoordinates(_lat!, _lng!);
                      if (placemarks.isNotEmpty) {
                        final place = placemarks.first;
                        city = place.locality ?? place.subLocality ?? '';
                        state = place.administrativeArea ?? '';
                        postalCode = place.postalCode ?? '';
                        country = place.country ?? '';
                      }
                    }
                  } catch (e) {
                    AppLogger.error("Geocoding error: ${e.toString()}");
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isGeocoding = false;
                      });
                    }
                  }
                }

                ref.read(signupProvider.notifier)
                    .signup(
                      name: _nameController.text.trim(),
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
                      phoneNumber: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
                      location: _locationController.text.trim().isNotEmpty && _lat != null && _lng != null
                          ? {
                              'type': 'Point',
                              'coordinates': [_lng, _lat]
                            }
                          : null,
                      address: _locationController.text.trim().isNotEmpty
                          ? {
                              'addressLine1': _locationController.text.trim(),
                              'city': city,
                              'state': state,
                              'postalCode': postalCode,
                              'country': country,
                              'location': (_lat != null && _lng != null) ? {
                                'type': 'Point',
                                'coordinates': [_lng, _lat]
                              } : null,
                              'isDefault': true,
                            }
                          : null,
                      role: widget.role,
                    );
              },
            ),

            10.verticalSpace,

            /// Login redirect
            AppLinkText(
              AppLocalizations.of(context)!.haveAccountLogin,
              textColor: AppColors.textPrimary,
              links: [
                AppTextLink(
                  label: AppLocalizations.of(context)!.logIn,
                  onTap: () async {
                    await _close(ref);
                    _showLoginAccountDialog(widget.parentRef);
                  },
                ),
              ],
            ),

            16.verticalSpace,
          ],
        ),
        ),
      ),
    );
  }
}

