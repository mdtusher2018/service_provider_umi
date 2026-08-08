part of 'my_addresses_screen.dart';

class AddAddressScreen extends ConsumerStatefulWidget {
  final AddressModel? existingAddress;

  const AddAddressScreen({super.key, this.existingAddress});

  @override
  ConsumerState<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends ConsumerState<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _searchCtrl;
  late final TextEditingController _line1Ctrl;
  late final TextEditingController _line2Ctrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _stateCtrl;
  late final TextEditingController _postalCtrl;
  late final TextEditingController _countryCtrl;

  double? _lat;
  double? _lng;
  bool _isSaving = false;

  bool get _isEditing => widget.existingAddress != null;

  @override
  void initState() {
    super.initState();
    final a = widget.existingAddress;
    _searchCtrl = TextEditingController();
    _line1Ctrl = TextEditingController(text: a?.addressLine1 ?? '');
    _line2Ctrl = TextEditingController(text: a?.addressLine2 ?? '');
    _cityCtrl = TextEditingController(text: a?.city ?? '');
    _stateCtrl = TextEditingController(text: a?.state ?? '');
    _postalCtrl = TextEditingController(text: a?.postalCode ?? '');
    _countryCtrl = TextEditingController(text: a?.country ?? '');
    _lat = a?.lat;
    _lng = a?.lng;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _line1Ctrl.dispose();
    _line2Ctrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _postalCtrl.dispose();
    _countryCtrl.dispose();
    super.dispose();
  }

  // ── Save ──────────────────────────────────────────────────────────────────────
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_lat == null || _lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseSearchAndSelectAddress),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    String? error;

    if (_isEditing) {
      error = await ref
          .read(addressProvider.notifier)
          .updateAddress(
            widget.existingAddress!.id,
            UpdateAddressRequest(
              addressLine1: _line1Ctrl.text.trim(),
              addressLine2: _line2Ctrl.text.trim(),
              city: _cityCtrl.text.trim(),
              state: _stateCtrl.text.trim(),
              postalCode: _postalCtrl.text.trim(),
              country: _countryCtrl.text.trim(),
              lat: _lat!,
              lng: _lng!,
            ),
          );
    } else {
      error = await ref
          .read(addressProvider.notifier)
          .createAddress(
            CreateAddressRequest(
              addressLine1: _line1Ctrl.text.trim(),
              addressLine2: _line2Ctrl.text.trim(),
              city: _cityCtrl.text.trim(),
              state: _stateCtrl.text.trim(),
              postalCode: _postalCtrl.text.trim(),
              country: _countryCtrl.text.trim(),
              lat: _lat!,
              lng: _lng!,
            ),
          );
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _fillAddressFromLatLng(double lat, double lng) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=${AppConfig.googleMapsApiKey}";

    final response = await ref.read(dioClientProvider).get(url);
    final data = response.data;

    if (data["status"] != "OK") return;

    final results = data["results"] as List;
    if (results.isEmpty) return;

    // 🔥 STEP 1: pick best result
    Map<String, dynamic>? bestResult;

    for (final r in results) {
      final types = List<String>.from(r["types"]);

      if (types.contains("street_address")) {
        bestResult = r;
        break;
      } else if (types.contains("premise")) {
        bestResult ??= r;
      } else if (types.contains("route")) {
        bestResult ??= r;
      }
    }

    bestResult ??= results.first;

    final components = bestResult?["address_components"] ?? [];

    // 🔥 STEP 2: smarter extractor (multi-type fallback)
    String? getComponent(List<String> types) {
      for (final type in types) {
        for (final c in components) {
          if ((c["types"] as List).contains(type)) {
            return c["long_name"];
          }
        }
      }
      return null;
    }

    // 🔥 STEP 3: extract everything safely
    final streetNumber = getComponent(["street_number"]);
    final route = getComponent(["route"]);
    final subLocality = getComponent([
      "sublocality",
      "sublocality_level_1",
      "neighborhood",
    ]);
    final city = getComponent(["locality"]);
    final state = getComponent(["administrative_area_level_1"]);
    final country = getComponent(["country"]);
    final postal = getComponent(["postal_code"]);

    // 🔥 STEP 4: fallback strategy
    final line1 = [
      streetNumber,
      route,
    ].where((e) => e != null && e.isNotEmpty).join(' ');

    setState(() {
      _line1Ctrl.text = line1.isNotEmpty ? line1 : (route ?? '');

      _line2Ctrl.text = subLocality ?? '';

      _cityCtrl.text =
          city ?? getComponent(["administrative_area_level_2"]) ?? '';

      _stateCtrl.text = state ?? '';

      _countryCtrl.text = country ?? '';

      _postalCtrl.text = postal ?? '';

      _lat = lat;
      _lng = lng;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AppText.h3(_isEditing ? AppLocalizations.of(context)!.editAddress : AppLocalizations.of(context)!.addAddress),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20, 20, 20, context.bottomPadding + 20),
          children: [
            // ── Google Places autocomplete ─────────────────────────────────────
            AppText.labelMd(AppLocalizations.of(context)!.searchAddress),
            6.verticalSpace,
            GooglePlaceAutoCompleteTextField(
              textEditingController: _searchCtrl,
              googleAPIKey: AppConfig.googleMapsApiKey,
              inputDecoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchYourAddress,
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.grey400,
                  size: 20,
                ),
                suffixIcon: ValueListenableBuilder(
                  valueListenable: _searchCtrl,
                  builder: (_, v, __) => v.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          color: AppColors.grey400,
                          onPressed: () {
                            _searchCtrl.clear();
                            // Clear the coordinates so user can't save stale data
                            setState(() {
                              _lat = null;
                              _lng = null;
                            });
                          },
                        )
                      : const SizedBox.shrink(),
                ),
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),

              itemClick: (prediction) {
                _searchCtrl.text = prediction.description ?? '';
              },
              getPlaceDetailWithLatLng: (prediction) async {
                final lat = double.tryParse(prediction.lat ?? '');
                final lng = double.tryParse(prediction.lng ?? '');

                AppLogger.info("LAT: $lat LNG: $lng");
                if (lat == null || lng == null) return;
                setState(() {
                  _lat = lat;
                  _lng = lng;
                });

                await _fillAddressFromLatLng(lat, lng);
              },

              isCrossBtnShown: false,
            ),

            // ── Coordinates confirmed pill ────────────────────────────────────
            if (_lat != null && _lng != null) ...[
              10.verticalSpace,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.my_location_rounded,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    8.horizontalSpace,
                    AppText.bodySm(
                      AppLocalizations.of(context)!.latLng(
                        _lat!.toStringAsFixed(5),
                        _lng!.toStringAsFixed(5)
                      ),
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],

            24.verticalSpace,
            const Divider(),
            12.verticalSpace,

            AppText.labelSm(
              AppLocalizations.of(context)!.reviewAndAdjust,
              color: AppColors.textSecondary,
            ),
            14.verticalSpace,

            // ── Address Line 1 ────────────────────────────────────────────────
            _field(
              label: AppLocalizations.of(context)!.addressLine1,
              hint: AppLocalizations.of(context)!.streetNumberAndName,
              ctrl: _line1Ctrl,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? AppLocalizations.of(context)!.required : null,
            ),
            12.verticalSpace,

            // ── Address Line 2 ────────────────────────────────────────────────
            _field(
              label: AppLocalizations.of(context)!.addressLine2,
              hint: AppLocalizations.of(context)!.areaNeighbourhood,
              ctrl: _line2Ctrl,
            ),
            12.verticalSpace,

            // ── City & State ──────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _field(label: AppLocalizations.of(context)!.city, hint: AppLocalizations.of(context)!.city, ctrl: _cityCtrl),
                ),
                12.horizontalSpace,
                Expanded(
                  child: _field(
                    label: AppLocalizations.of(context)!.state,
                    hint: AppLocalizations.of(context)!.state,
                    ctrl: _stateCtrl,
                  ),
                ),
              ],
            ),
            12.verticalSpace,

            // ── Postal & Country ──────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _field(
                    label: AppLocalizations.of(context)!.postalCode,
                    hint: AppLocalizations.of(context)!.postal,
                    ctrl: _postalCtrl,
                    keyboardType: TextInputType.number,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: _field(
                    label: AppLocalizations.of(context)!.country,
                    hint: AppLocalizations.of(context)!.country,
                    ctrl: _countryCtrl,
                  ),
                ),
              ],
            ),

            32.verticalSpace,

            AppButton.primary(
              label: _isEditing ? AppLocalizations.of(context)!.updateAddress : AppLocalizations.of(context)!.saveAddress,
              isLoading: _isSaving,
              onPressed: _isSaving ? null : _save,
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required String hint,
    required TextEditingController ctrl,
    int? maxLines,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.labelMd(label),
        6.verticalSpace,
        AppTextField(
          controller: ctrl,
          hint: hint,
          maxLines: maxLines,
          validator: validator,
        ),
      ],
    );
  }
}
