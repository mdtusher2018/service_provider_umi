// ── Requests ──────────────────────────────────────────────────────────────────

class SignupRequest {
  final String name;
  final String email;
  final String password;
  final String? role;
  final String? phoneNumber;
  final Map<String, dynamic>? location;

  const SignupRequest({
    required this.name,
    required this.email,
    required this.password,
    this.role,
    this.phoneNumber,
    this.location,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    if (role != null) 'role': role,
    if (phoneNumber != null) 'phoneNumber': phoneNumber,
    if (location != null) 'location': location,
  };
}

class LoginEmailRequest {
  final String email;
  final String password;

  const LoginEmailRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class GoogleLoginRequest {
  final String token;

  const GoogleLoginRequest({required this.token});

  Map<String, dynamic> toJson() => {'token': token};
}

class ForgotPasswordRequest {
  final String email;

  const ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

class ResetPasswordRequest {
  final String newPassword;
  final String confirmPassword;

  const ResetPasswordRequest({
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
    'newPassword': newPassword,
    'confirmPassword': confirmPassword,
  };
}

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
    'oldPassword': oldPassword,
    'newPassword': newPassword,
    'confirmPassword': confirmPassword,
  };
}

class RefreshTokenRequest {
  final String refreshToken;

  const RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() => {'refreshToken': refreshToken};
}

class VerifyOtpRequest {
  final String otp;

  const VerifyOtpRequest({required this.otp});

  Map<String, dynamic> toJson() => {'otp': otp};
}

class ResendOtpRequest {
  final String email;

  const ResendOtpRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

// ── Responses ─────────────────────────────────────────────────────────────────

class SignInResponse {
  final String token;
  final String refreshToken;
  const SignInResponse({required this.token, required this.refreshToken});
  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      token: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
    );
  }
}

class SignUpOtpTokenResponse {
  final String token;

  const SignUpOtpTokenResponse({required this.token});

  factory SignUpOtpTokenResponse.fromJson(Map<String, dynamic> json) {
    final otpToken = json['otpToken'] as Map<String, dynamic>?;
    return SignUpOtpTokenResponse(token: otpToken?['token'] as String? ?? '');
  }
}

class OtpVerifedResponse {
  final String token;

  const OtpVerifedResponse({required this.token});

  factory OtpVerifedResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerifedResponse(token: json['token'] as String? ?? '');
  }
}

class ResendOtpTokenResponse {
  final String token;

  const ResendOtpTokenResponse({required this.token});

  factory ResendOtpTokenResponse.fromJson(Map<String, dynamic> json) {
    return ResendOtpTokenResponse(token: json['token'] as String? ?? '');
  }
}

class ForgotPasswordOtpTokenResponse {
  final String token;

  const ForgotPasswordOtpTokenResponse({required this.token});

  factory ForgotPasswordOtpTokenResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordOtpTokenResponse(
      token: json['token'] as String? ?? '',
    );
  }
}
