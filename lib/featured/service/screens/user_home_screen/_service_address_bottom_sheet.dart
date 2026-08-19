part of 'user_home_screen.dart';

class ServiceAddressBottomSheet extends ConsumerStatefulWidget {
  const ServiceAddressBottomSheet({super.key});

  @override
  ConsumerState<ServiceAddressBottomSheet> createState() => _ServiceAddressBottomSheetState();
}

class _ServiceAddressBottomSheetState extends ConsumerState<ServiceAddressBottomSheet> {
  bool _isAddingNew = false;
  bool _isSaving = false;
  String? _editingAddressId;
  String? _selectingAddressId;

  final _streetCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();

  @override
  void dispose() {
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSaveNewAddress() async {
    final street = _streetCtrl.text.trim();
    final city = _cityCtrl.text.trim();
    final stateStr = _stateCtrl.text.trim();

    if (street.isEmpty || city.isEmpty || stateStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      double lat = 0.0;
      double lng = 0.0;

      try {
        final locations = await geocoding.locationFromAddress('$street, $city, $stateStr');
        if (locations.isNotEmpty) {
          lat = locations.first.latitude;
          lng = locations.first.longitude;
        }
      } catch (e) {
        debugPrint('Geocoding failed: $e');
      }

      String? error;
      if (_editingAddressId != null) {
        error = await ref.read(addressProvider.notifier).updateAddress(
              _editingAddressId!,
              UpdateAddressRequest(
                addressLine1: street,
                city: city,
                state: stateStr,
                lat: lat,
                lng: lng,
              ),
            );
      } else {
        error = await ref.read(addressProvider.notifier).createAddress(
              CreateAddressRequest(
                addressLine1: street,
                city: city,
                state: stateStr,
                lat: lat,
                lng: lng,
              ),
            );
      }

      if (error != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
        return;
      }

      // Refresh addresses and switch back to list view
      await ref.read(addressProvider.notifier).fetch();
      if (!mounted) return;
      setState(() {
        _isAddingNew = false;
        _editingAddressId = null;
        _streetCtrl.clear();
        _cityCtrl.clear();
        _stateCtrl.clear();
      });
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _selectAddress(AddressModel address) async {
    if (_selectingAddressId != null) return; // Prevent multiple taps
    setState(() => _selectingAddressId = address.id);
    
    final loc = LocationModel(
      type: 'Points',
      address: address.displayAddress,
      coordinates: [address.lng, address.lat],
    );

    try {
      ref.read(selectedAddressIdProvider.notifier).state = address.id;

      // Save as primary location for the profile
      await ref.read(updateProfileProvider.notifier).update(
            UpdateProfileRequest(address: loc),
          );

      // Also refresh user provider so it's instantly reflected
      await ref.read(myProfileProvider.notifier).fetch();
    } finally {
      if (mounted) {
        setState(() => _selectingAddressId = null);
        Navigator.of(context).pop(); // pop bottom sheet
      }
    }
  }

  Widget _buildAddressList(List<AddressModel> addresses) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (addresses.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: AppText.bodyLg(
              'No saved addresses yet.',
              color: AppColors.textSecondary,
            ),
          )
        else
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final address = addresses[index];
                return InkWell(
                  onTap: () => _selectAddress(address),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.grey50, // Light grey background
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.bodyLg(address.addressLine1, fontWeight: FontWeight.bold),
                              const SizedBox(height: 2),
                              AppText.bodyMd('${address.city}, ${address.postalCode ?? address.state}', color: AppColors.textSecondary),
                            ],
                          ),
                        ),
                        if (_selectingAddressId == address.id)
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0, left: 8.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        else ...[
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.textSecondary),
                            onPressed: () {
                              _streetCtrl.text = address.addressLine1;
                              _cityCtrl.text = address.city ?? '';
                              _stateCtrl.text = address.state ?? '';
                              setState(() {
                                _editingAddressId = address.id;
                                _isAddingNew = true;
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.textSecondary),
                            onPressed: () => _showDeleteConfirm(address.id),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () {
            _streetCtrl.clear();
            _cityCtrl.clear();
            _stateCtrl.clear();
            setState(() {
              _editingAddressId = null;
              _isAddingNew = true;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary.withOpacity(0.5), style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(12),
            ),
            // Replicating a dashed border is tricky with raw flutter containers without a package.
            // Using a standard border to closely approximate the clean look.
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                AppText(
                  'Add new address',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirm(String addressId) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 24), // For balance with close button
                    const AppText.h3('Delete this address?'),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: AppButton.outline(
                        label: 'Cancel',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppButton.primary(
                        label: 'Delete',
                        backgroundColor: AppColors.error,
                        onPressed: () async {
                          Navigator.pop(context); // close dialog
                          
                          setState(() => _isSaving = true);
                          final error = await ref.read(addressProvider.notifier).deleteAddress(addressId);
                          if (mounted) setState(() => _isSaving = false);
                          
                          if (error != null) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                            }
                          } else {
                            ref.read(addressProvider.notifier).fetch();
                          }
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _streetCtrl,
          decoration: InputDecoration(
            hintText: 'Street address',
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _cityCtrl,
                decoration: InputDecoration(
                  hintText: 'City',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _stateCtrl,
                decoration: InputDecoration(
                  hintText: 'State',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: AppButton.outline(
                label: 'Cancel',
                onPressed: _isSaving ? null : () => setState(() => _isAddingNew = false),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton.primary(
                label: 'Save',
                isLoading: _isSaving,
                onPressed: _isSaving ? null : _handleSaveNewAddress,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final addressState = ref.watch(addressProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.h2('Service address'),
                    AppText.bodyMd('Select where you want to receive the service', color: AppColors.textSecondary),
                  ],
                ),
              ),
              InkWell(
                onTap: Navigator.of(context).pop,
                child: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 24),
          addressState.when(
            data: (addresses) => _isAddingNew ? _buildAddForm() : _buildAddressList(addresses),
            loading: () => const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => AppErrorWidget(
              error: e,
              onRetry: () => ref.read(addressProvider.notifier).fetch(),
            ),
          ),
        ],
      ),
    );
  }
}
