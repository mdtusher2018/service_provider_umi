import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/theme/app_role.dart';

// ─────────────────────────────────────────────────────────────
//  appRoleProvider
//
//  Holds the active AppRole for the session.
//  Initialized at app start from App(role: ...).
//  Read anywhere with: ref.watch(appRoleProvider)
// ─────────────────────────────────────────────────────────────

class AppRoleNotifier extends Notifier<AppRole> {
  @override
  AppRole build() => AppRole.user; // safe default

  /// Called once at startup from App widget
  void setRole(AppRole role) => state = role;

  /// Toggle between user ↔ provider (Switch to professional)
  void switchRole() {
    state = state == AppRole.user ? AppRole.provider : AppRole.user;
  }
}

final appRoleProvider = NotifierProvider<AppRoleNotifier, AppRole>(
  AppRoleNotifier.new,
);
