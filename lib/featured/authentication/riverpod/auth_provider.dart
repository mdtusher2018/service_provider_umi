import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/di/core_providers.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/core/services/network/dio_client.dart';
import 'package:service_provider_umi/data/data_source/remote/auth_remote_data_source.dart';
import 'package:service_provider_umi/data/models/auth_models.dart';
import 'package:service_provider_umi/data/repository/auth_repository.dart';

part 'auth_provider.freezed.dart';
part 'auth_provider.g.dart';

// ── State ─────────────────────────────────────────────────────────────────────

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.success(String token) = AuthSuccess;
  const factory AuthState.failure(Failure failure) = AuthFailure;
}

// ── Providers ─────────────────────────────────────────────────────────────────

@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) =>
    AuthRemoteDataSourceImpl(apiService: ref.read(dioClientProvider));

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepository(
  remote: ref.read(authRemoteDataSourceProvider),
  local: ref.read(localStorageProvider),
);

// ── Notifier ──────────────────────────────────────────────────────────────────

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => const AuthState.initial();

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> loginWithEmail(String email, String password) async {
    state = const AuthState.loading();
    final result = await _repo.loginWithEmail(email, password);
    state = result.when(success: AuthState.success, failure: AuthState.failure);
  }

  Future<void> loginWithGoogle(String email, {String? role}) async {
    state = const AuthState.loading();
    final result = await _repo.loginWithGoogle(email, role: role);
    state = result.when(success: AuthState.success, failure: AuthState.failure);
  }

  Future<void> loginWithApple(String appleId, {String? role}) async {
    state = const AuthState.loading();
    final result = await _repo.loginWithApple(appleId, role: role);
    state = result.when(success: AuthState.success, failure: AuthState.failure);
  }

  Future<void> signup({
    required String fullName,
    required String email,
    required String password,
    String role = 'user',
  }) async {
    state = const AuthState.loading();
    final result = await _repo.signup(
      SignupRequest(
        role: role,
        email: email,
        password: password,
        fullName: fullName,
      ),
    );
    state = result.when(success: AuthState.success, failure: AuthState.failure);
  }

  Future<void> logout() async {
    state = const AuthState.loading();
    await _repo.logout();
    state = const AuthState.initial();
  }

  void reset() => state = const AuthState.initial();
}
