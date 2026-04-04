class AddressModel {
  final String id;
  final String address;
  final String name;
  final double lat;
  final double lng;

  const AddressModel({
    required this.id,
    this.name = 'Untitled',
    required this.address,
    required this.lat,
    required this.lng,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json['_id'] as String? ?? json['id'] as String? ?? '',
        name: json['name'] as String? ?? 'Untitled',
        address: json['address'] as String? ?? '',
        lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
        lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'lat': lat,
        'lng': lng,
      };
}
