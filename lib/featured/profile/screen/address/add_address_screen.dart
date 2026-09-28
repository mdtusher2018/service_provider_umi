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

  // Removing _fillAddressFromLatLng as it's no longer used.

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
            RawAutocomplete<Map<String, dynamic>>(
              textEditingController: _line1Ctrl,
              focusNode: FocusNode(),
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<Map<String, dynamic>>.empty();
                }
                try {
                  final response = await ref.read(dioClientProvider).get(
                    'https://nominatim.openstreetmap.org/search',
                    queryParameters: {
                      'q': textEditingValue.text,
                      'format': 'json',
                      'addressdetails': 1,
                      'limit': 5,
                      'accept-language': 'en',
                    },
                    options: Options(
                      headers: {
                        'User-Agent': 'ServiceProviderUmi/1.0',
                      },
                    ),
                  );
                  if (response.statusCode == 200) {
                    final List data = response.data;
                    return data.cast<Map<String, dynamic>>();
                  }
                } catch (e) {
                  debugPrint('Nominatim API exception: $e');
                }
                return const Iterable<Map<String, dynamic>>.empty();
              },
              displayStringForOption: (option) => option['display_name'] ?? '',
              onSelected: (selection) {
                final addressDetails = selection['address'] ?? {};
                final address = selection['display_name'] ?? '';
                final lat = double.tryParse(selection['lat'].toString()) ?? 0.0;
                final lon = double.tryParse(selection['lon'].toString()) ?? 0.0;

                setState(() {
                  _lat = lat;
                  _lng = lon;
                  _line1Ctrl.text = address;
                  _cityCtrl.text = addressDetails['city'] ?? addressDetails['town'] ?? addressDetails['village'] ?? '';
                  _stateCtrl.text = addressDetails['state'] ?? '';
                  // Clear unused fields since they're not shown
                  _line2Ctrl.clear();
                  _postalCtrl.clear();
                  _countryCtrl.clear();
                });
              },
              fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  onEditingComplete: onEditingComplete,
                  validator: (v) => (v == null || v.trim().isEmpty) ? AppLocalizations.of(context)!.required : null,
                  decoration: InputDecoration(
                    hintText: 'Street address',
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
                      valueListenable: controller,
                      builder: (_, v, __) => v.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              color: AppColors.grey400,
                              onPressed: () {
                                controller.clear();
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
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.white,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 250,
                        maxWidth: MediaQuery.of(context).size.width - 40,
                      ),
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          return ListTile(
                            title: Text(
                              option['display_name'] ?? '',
                              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                            ),
                            onTap: () => onSelected(option),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
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
