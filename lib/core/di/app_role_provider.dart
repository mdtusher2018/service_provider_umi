import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';

class AppRoleNotifier extends Notifier<AppRole> {
  final AppRole initialRole;

  AppRoleNotifier([this.initialRole = AppRole.guest]);

  @override
  AppRole build() {
    return initialRole;
  }

  /// Set role manually (login / logout / switch account)
  void setRole(AppRole role) {
    state = role;
  }

  /// Toggle only between USER <-> PROVIDER
  /// Guest cannot toggle
  void switchRole() {
    if (state == AppRole.user) {
      state = AppRole.provider;
    } else if (state == AppRole.provider) {
      state = AppRole.user;
    }
  }

  /// Convert guest -> user (after login)
  void loginAsUser() {
    state = AppRole.user;
  }

  /// Convert guest -> provider
  void loginAsProvider() {
    state = AppRole.provider;
  }

  /// Logout -> guest
  void logout() {
    state = AppRole.guest;
  }
}

final appRoleProvider = NotifierProvider<AppRoleNotifier, AppRole>(
  AppRoleNotifier.new,
);
