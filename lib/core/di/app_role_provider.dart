import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/core_providers.dart';
import 'package:service_provider_umi/core/services/storage/storage_key.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';

class AppRoleNotifier extends Notifier<AppRole> {
  @override
  AppRole build() {
    final storage = ref.read(localStorageProvider);
    final saved = storage.readSync<String>(StorageKey.userRole);
    final token = storage.readSync<String>(StorageKey.accessToken);

    // No token → force guest regardless of saved role
    if (token == null || token.isEmpty) return AppRole.guest;

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

  Future<void> setRole(AppRole role) async {
    state = role;
    await _persist(role);
  }

  Future<void> switchRole() async {
    if (state == AppRole.user) {
      state = AppRole.provider;
    } else if (state == AppRole.provider) {
      state = AppRole.user;
    }
    await _persist(state);
  }

  Future<void> loginAsUser() async {
    state = AppRole.user;
    await _persist(AppRole.user);
  }

  Future<void> loginAsProvider() async {
    state = AppRole.provider;
    await _persist(AppRole.provider);
  }

  Future<void> logout() async {
    state = AppRole.guest;
    await _persist(AppRole.guest);
  }
}

final appRoleProvider = NotifierProvider<AppRoleNotifier, AppRole>(
  AppRoleNotifier.new,
);
