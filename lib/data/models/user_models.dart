// models/user/user_models.dart

// ── Profile ───────────────────────────────────────────────────────────────────

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final bool isProfessional;
  final bool verified;
  final String about;
  final String address;
  final String currentRole;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.isProfessional,
    required this.verified,
    required this.about,
    required this.address,
    required this.currentRole,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        profileImage: json['profile_image'] as String,
        isProfessional: json['is_professional'] as bool,
        verified: json['verified'] as bool,
        about: json['about'] as String,
        address: json['address'] as String,
        currentRole: json['current_role'] as String,
      );
}

class UpdateProfileRequest {
  final String? name;
  final String? phone;
  final String? about;
  final String? address;
  // profile_image sent as multipart file

  const UpdateProfileRequest({
    this.name,
    this.phone,
    this.about,
    this.address,
  });

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (about != null) 'about': about,
        if (address != null) 'address': address,
      };
}

// ── Addresses ─────────────────────────────────────────────────────────────────

class UserAddress {
  final String id;
  final String name;
  final String address;

  const UserAddress({
    required this.id,
    required this.name,
    required this.address,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        id: json['id'] as String,
        name: json['name'] as String,
        address: json['address'] as String,
      );
}

class AddAddressRequest {
  final String name;
  final AddressLocation location;

  const AddAddressRequest({required this.name, required this.location});

  Map<String, dynamic> toJson() => {
        'name': name,
        'location': location.toJson(),
      };
}

class AddressLocation {
  final String address;
  final List<double> coordinates;

  const AddressLocation({required this.address, required this.coordinates});

  Map<String, dynamic> toJson() => {
        'address': address,
        'coordinates': coordinates,
      };
}

// ── Password ──────────────────────────────────────────────────────────────────

class ChangePasswordRequest {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
        'old_password': oldPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      };
}

// ── OTP ───────────────────────────────────────────────────────────────────────

class VerifyOtpRequest {
  final int otp;

  const VerifyOtpRequest({required this.otp});

  Map<String, dynamic> toJson() => {'otp': otp};
}
