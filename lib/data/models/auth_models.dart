// models/auth/auth_models.dart

// ── Requests ─────────────────────────────────────────────────────────────────

import 'package:google_maps_flutter/google_maps_flutter.dart';

class SignupRequest {
  final String role;
  final String email;
  final String password;
  final String fullName;
  final String? phoneNumber;
  final LatLng? location;

  const SignupRequest({
    required this.role,
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNumber,
    required this.location,
  });

  Map<String, dynamic> toJson() => {
    'role': role,
    'email': email,
    'password': password,
    'name': fullName,
    'phoneNumber': ?phoneNumber,
    // if (location != null)
    //   'location': {
    //     "type": "Point",
    //     "coordinates": [location!.latitude, location!.longitude],
    //   },
  };
}

class LoginEmailRequest {
  final String email;
  final String password;

  const LoginEmailRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class LoginGoogleRequest {
  final String email;
  final String? role; // only on first login

  const LoginGoogleRequest({required this.email, this.role});

  Map<String, dynamic> toJson() => {
    'email': email,
    if (role != null) 'role': role,
  };
}

class LoginAppleRequest {
  final String appleId;
  final String? role; // only on first login

  const LoginAppleRequest({required this.appleId, this.role});

  Map<String, dynamic> toJson() => {
    'appleId': appleId,
    if (role != null) 'role': role,
  };
}

// ── Response ──────────────────────────────────────────────────────────────────

class SignInResponse {
  final String token;

  const SignInResponse({required this.token});

  factory SignInResponse.fromJson(Map<String, dynamic> json) =>
      SignInResponse(token: json['accessToken'] as String);
}

class SignupResponse {
  final String token;

  const SignupResponse({required this.token});

  factory SignupResponse.fromJson(Map<String, dynamic> json) =>
      SignupResponse(token: json['otpToken']['token'] as String);
}
