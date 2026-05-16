class AddressModel {
  final String id;
  final String userId;
  final String addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;
  final AddressLocation location;
  final bool isDefault;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AddressModel({
    required this.id,
    required this.userId,
    required this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    required this.location,
    this.isDefault = false,
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  });

  double get lat => location.coordinates[1];
  double get lng => location.coordinates[0];

  /// Human-readable display address
  String get displayAddress {
    final parts = <String>[
      addressLine1,
      if (addressLine2 != null && addressLine2!.isNotEmpty) addressLine2!,
      if (city != null && city!.isNotEmpty) city!,
      if (state != null && state!.isNotEmpty) state!,
      if (country != null && country!.isNotEmpty) country!,
    ];
    return parts.join(', ');
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      addressLine1: json['addressLine1'] as String? ?? '',
      addressLine2: json['addressLine2'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      postalCode: json['postalCode'] as String?,
      country: json['country'] as String?,
      location: AddressLocation.fromJson(
        json['location'] as Map<String, dynamic>? ??
            {
              'type': 'Point',
              'coordinates': [0.0, 0.0],
            },
      ),
      isDefault: json['isDefault'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'addressLine1': addressLine1,
    if (addressLine2 != null) 'addressLine2': addressLine2,
    if (city != null) 'city': city,
    if (state != null) 'state': state,
    if (postalCode != null) 'postalCode': postalCode,
    if (country != null) 'country': country,
    'location': location.toJson(),
  };

  AddressModel copyWith({
    String? id,
    String? userId,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    AddressLocation? location,
    bool? isDefault,
    bool? isDeleted,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      location: location ?? this.location,
      isDefault: isDefault ?? this.isDefault,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

class AddressLocation {
  final String type;
  final List<double> coordinates; // [lng, lat]

  const AddressLocation({this.type = 'Point', required this.coordinates});

  factory AddressLocation.fromJson(Map<String, dynamic> json) {
    final raw = json['coordinates'] as List<dynamic>? ?? [0.0, 0.0];
    return AddressLocation(
      type: json['type'] as String? ?? 'Point',
      coordinates: raw.map((e) => (e as num).toDouble()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'type': type, 'coordinates': coordinates};
}

// ── Request models ────────────────────────────────────────────────────────────

class CreateAddressRequest {
  final String addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;
  final double lat;
  final double lng;

  const CreateAddressRequest({
    required this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toJson() => {
    'addressLine1': addressLine1,
    if (addressLine2 != null && addressLine2!.isNotEmpty)
      'addressLine2': addressLine2,
    if (city != null && city!.isNotEmpty) 'city': city,
    if (state != null && state!.isNotEmpty) 'state': state,
    if (postalCode != null && postalCode!.isNotEmpty) 'postalCode': postalCode,
    if (country != null && country!.isNotEmpty) 'country': country,
    'location': {
      'type': 'Point',
      'coordinates': [lng, lat],
    },
  };
}

class UpdateAddressRequest {
  final String addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;
  final double lat;
  final double lng;
  final bool? isDefault;

  const UpdateAddressRequest({
    required this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    required this.lat,
    required this.lng,
    this.isDefault,
  });

  Map<String, dynamic> toJson() => {
    'addressLine1': addressLine1,
    if (addressLine2 != null && addressLine2!.isNotEmpty)
      'addressLine2': addressLine2,
    if (city != null && city!.isNotEmpty) 'city': city,
    if (state != null && state!.isNotEmpty) 'state': state,
    if (postalCode != null && postalCode!.isNotEmpty) 'postalCode': postalCode,
    if (country != null && country!.isNotEmpty) 'country': country,
    'location': {
      'type': 'Point',
      'coordinates': [lng, lat],
    },
    if (isDefault != null) 'isDefault': isDefault,
  };
}

class AddressListResponse {
  final List<AddressModel> addresses;
  final AddressMeta meta;

  const AddressListResponse({required this.addresses, required this.meta});

  factory AddressListResponse.fromJson(Map<String, dynamic> json) {
    // Root json is the full API response; data.data holds the list
    final dataMap = json['data'] as Map<String, dynamic>? ?? {};
    final list = dataMap['data'] as List<dynamic>? ?? [];
    final meta = dataMap['meta'] as Map<String, dynamic>? ?? {};

    return AddressListResponse(
      addresses: list
          .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: AddressMeta.fromJson(meta),
    );
  }
}

class AddressMeta {
  final int page;
  final int limit;
  final int total;

  const AddressMeta({
    required this.page,
    required this.limit,
    required this.total,
  });

  factory AddressMeta.fromJson(Map<String, dynamic> json) => AddressMeta(
    page: json['page'] as int? ?? 1,
    limit: json['limit'] as int? ?? 10,
    total: json['total'] as int? ?? 0,
  );
}
