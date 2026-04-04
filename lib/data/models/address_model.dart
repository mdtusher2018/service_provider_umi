class AddressModel {
  final String id;
  final String address;
  final String name;
  final double lat;
  final double lng;

  const AddressModel({
    required this.id,
    this.name = "UnTitled",
    required this.address,
    required this.lat,
    required this.lng,
  });
}
