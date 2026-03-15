part of 'my_addresses_screen.dart';

class AddressPage extends StatefulWidget {
  final _Address? address;

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
      appBar: AppBar(
        title: const Text("Address"),
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _field('Name', 'Enter Your Name', _nameCtrl),
            const SizedBox(height: 12),
            _field('Address', 'Enter Your Address', _addressCtrl, maxLine: 2),
            const SizedBox(height: 12),
            _field('City', 'Enter Your City', _cityCtrl),
            const SizedBox(height: 12),
            _field('Country', 'Enter Your Country', _countryCtrl),
            const Spacer(),
            AppButton.primary(
              label: "Save",
              onPressed: () {
                final newAddress = _Address(
                  id:
                      widget.address?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  label: _nameCtrl.text,
                  street: _addressCtrl.text,
                  city: _cityCtrl.text,
                  country: _countryCtrl.text,
                );

                Navigator.pop(context, newAddress);
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
        const SizedBox(height: 6),
        AppTextField(controller: ctrl, hint: hint, maxLines: maxLine),
      ],
    );
  }
}
