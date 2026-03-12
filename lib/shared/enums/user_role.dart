enum UserRole {
  user,
  serviceProvider;

  bool get isUser => this == UserRole.user;
  bool get isServiceProvider => this == UserRole.serviceProvider;

  String get displayName {
    switch (this) {
      case UserRole.user:
        return 'User';
      case UserRole.serviceProvider:
        return 'Service Provider';
    }
  }

  String get apiValue {
    switch (this) {
      case UserRole.user:
        return 'user';
      case UserRole.serviceProvider:
        return 'service_provider';
    }
  }

  static UserRole fromString(String value) {
    switch (value) {
      case 'service_provider':
        return UserRole.serviceProvider;
      default:
        return UserRole.user;
    }
  }
}
