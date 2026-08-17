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

  final Dio _dio = Dio();
  Timer? _debounceTimer;

  Future<Iterable<NominatimPlace>> _searchPlaces(String query) async {
    if (query.length < 3) return const Iterable<NominatimPlace>.empty();
    
    // Simple debounce logic within optionsBuilder
    final completer = Completer<Iterable<NominatimPlace>>();
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final response = await _dio.get(
          'https://nominatim.openstreetmap.org/search',
          queryParameters: {
            'q': query,
            'format': 'json',
            'limit': '6',
            'addressdetails': '0',
          },
          options: Options(headers: {'User-Agent': 'service_provider_umi/1.0'}),
        );
        if (response.statusCode == 200) {
          final List data = response.data;
          completer.complete(data.map((e) => NominatimPlace.fromJson(e)).toList());
          return;
        }
      } catch (e) {
        AppLogger.error("Nominatim error: $e");
      }
      completer.complete(const Iterable<NominatimPlace>.empty());
    });
    return completer.future;
  }

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
                  Autocomplete<NominatimPlace>(
                    optionsBuilder: (textEditingValue) {
                      return _searchPlaces(textEditingValue.text);
                    },
                    displayStringForOption: (option) => option.displayName,
                    onSelected: (option) {
                      setState(() {
                        _lat = option.lat;
                        _lng = option.lon;
                      });
                    },
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      controller.addListener(() {
                        _locationController.text = controller.text;
                      });
                      return AppTextField(
                        controller: controller,
                        focusNode: focusNode,
                        hint: AppLocalizations.of(context)!.searchCitySuburbAddress,
                        prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.grey500),
                      );
                    },
                    optionsViewBuilder: (context, onSelected, options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(8),
                          clipBehavior: Clip.antiAlias,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 250, maxWidth: MediaQuery.of(context).size.width - (kIsWeb ? 200 : 70)),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                final option = options.elementAt(index);
                                return ListTile(
                                  title: AppText.bodySm(option.displayName, maxLines: 2, overflow: TextOverflow.ellipsis),
                                  onTap: () => onSelected(option),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
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
                        'By creating an account, you agree to our Terms & Conditions and Privacy Policy.',
                        textSize: 12,
                        links: [
                          AppTextLink(
                            label: 'Terms & Conditions',
                            onTap: () {
                              context.push('/profile/terms');
                            },
                          ),
                          AppTextLink(
                            label: 'Privacy Policy',
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

                if (_locationController.text.trim().isNotEmpty && _lat != null && _lng != null) {
                  try {
                    setState(() {
                      _isGeocoding = true;
                    });
                    
                      final placemarks = await placemarkFromCoordinates(_lat!, _lng!);
                      if (placemarks.isNotEmpty) {
                        final place = placemarks.first;
                        city = place.locality ?? place.subLocality ?? '';
                        state = place.administrativeArea ?? '';
                        postalCode = place.postalCode ?? '';
                        country = place.country ?? '';
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

class NominatimPlace {
  final String displayName;
  final double lat;
  final double lon;

  NominatimPlace({
    required this.displayName,
    required this.lat,
    required this.lon,
  });

  factory NominatimPlace.fromJson(Map<String, dynamic> json) {
    return NominatimPlace(
      displayName: json['display_name'] ?? '',
      lat: double.tryParse(json['lat']?.toString() ?? '0') ?? 0.0,
      lon: double.tryParse(json['lon']?.toString() ?? '0') ?? 0.0,
    );
  }
}
