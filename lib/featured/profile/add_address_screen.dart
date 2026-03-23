part of 'my_addresses_screen.dart';

class AddressPage extends StatefulWidget {
  final AddressModel? address;

  const AddressPage({super.key, this.address});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _countryCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.address?.label ?? '');
    _addressCtrl = TextEditingController(text: widget.address?.street ?? '');
    _cityCtrl = TextEditingController(text: widget.address?.city ?? '');
    _countryCtrl = TextEditingController(text: widget.address?.country ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: "Address"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _field('Name', 'Enter Your Name', _nameCtrl),
            12.verticalSpace,
            _field('Address', 'Enter Your Address', _addressCtrl, maxLine: 2),
            12.verticalSpace,
            _field('City', 'Enter Your City', _cityCtrl),
            12.verticalSpace,
            _field('Country', 'Enter Your Country', _countryCtrl),
            const Spacer(),
            AppButton.primary(
              label: "Save",
              onPressed: () {
                final newAddress = AddressModel(
                  id:
                      widget.address?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  label: _nameCtrl.text,
                  street: _addressCtrl.text,
                  city: _cityCtrl.text,
                  country: _countryCtrl.text,
                );

                context.pop(newAddress);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    String hint,
    TextEditingController ctrl, {
    int? maxLine,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.labelMd(label),
        6.verticalSpace,
        AppTextField(controller: ctrl, hint: hint, maxLines: maxLine),
      ],
    );
  }
}
