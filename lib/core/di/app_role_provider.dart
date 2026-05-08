import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/core_providers.dart';
import 'package:service_provider_umi/core/services/storage/storage_key.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';

class AppRoleNotifier extends Notifier<AppRole> {
  @override
  AppRole build() {
    // Read persisted role on startup
    final storage = ref.read(localStorageProvider);
    final saved = storage.readSync<String>(StorageKey.userRole);
    return _roleFromString(saved) ?? AppRole.guest;
  }

  AppRole? _roleFromString(String? value) {
    switch (value) {
      case 'user':
        return AppRole.user;
      case 'provider':
        return AppRole.provider;
      default:
        return null;
    }
  }

  String _roleToString(AppRole role) {
    switch (role) {
      case AppRole.user:
        return 'user';
      case AppRole.provider:
        return 'provider';
      case AppRole.guest:
        return 'guest';
    }
  }

  Future<void> _persist(AppRole role) async {
    final storage = ref.read(localStorageProvider);
    await storage.write(StorageKey.userRole, _roleToString(role));
  }

  void setRole(AppRole role) {
    state = role;
    _persist(role);
  }

  void switchRole() {
    if (state == AppRole.user) {
      state = AppRole.provider;
    } else if (state == AppRole.provider) {
      state = AppRole.user;
    }
    _persist(state);
  }

  void loginAsUser() {
    state = AppRole.user;
    _persist(AppRole.user);
  }

  void loginAsProvider() {
    state = AppRole.provider;
    _persist(AppRole.provider);
  }

  void logout() {
    state = AppRole.guest;
    _persist(AppRole.guest);
  }
}

final appRoleProvider = NotifierProvider<AppRoleNotifier, AppRole>(
  AppRoleNotifier.new,
);
