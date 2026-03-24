// models/auth/auth_models.dart

// ── Requests ─────────────────────────────────────────────────────────────────

class SignupRequest {
  final String role;
  final String email;
  final String password;
  final String fullName;

  const SignupRequest({
    required this.role,
    required this.email,
    required this.password,
    required this.fullName,
  });

  Map<String, dynamic> toJson() => {
        'role': role,
        'email': email,
        'password': password,
        'fullName': fullName,
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

class AuthResponse {
  final String token;

  const AuthResponse({required this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      AuthResponse(token: json['token'] as String);
}
