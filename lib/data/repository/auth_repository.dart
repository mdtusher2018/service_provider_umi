import 'package:service_provider_umi/core/base/repository.dart';
import 'package:service_provider_umi/core/base/result.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/core/services/storage/local_storage_service.dart';
import 'package:service_provider_umi/core/services/storage/storage_key.dart';
import 'package:service_provider_umi/data/data_source/remote/auth_remote_data_source.dart';
import 'package:service_provider_umi/data/models/auth_models.dart';

class AuthRepository with SafeCall {
  final AuthRemoteDataSource _remote;
  final LocalStorageService _local;

  AuthRepository({
    required AuthRemoteDataSource remote,
    required LocalStorageService local,
  }) : _remote = remote,
       _local = local;

  Future<Result<String, Failure>> loginWithEmail(
    String email,
    String password,
  ) async {
    final result = await asyncGuard(
      () => _remote.loginWithEmail(email, password),
    );
    return result.when(
      success: (token) async {
        await _local.write(StorageKey.accessToken, token);
        return Success(token);
      },
      failure: (f) async => Error(f),
    );
  }

  Future<Result<String, Failure>> loginWithGoogle(
    String email, {
    String? role,
  }) async {
    final result = await asyncGuard(
      () => _remote.loginWithGoogle(email, role: role),
    );
    return result.when(
      success: (token) async {
        await _local.write(StorageKey.accessToken, token);
        return Success(token);
      },
      failure: (f) async => Error(f),
    );
  }

  Future<Result<String, Failure>> loginWithApple(
    String appleId, {
    String? role,
  }) async {
    final result = await asyncGuard(
      () => _remote.loginWithApple(appleId, role: role),
    );
    return result.when(
      success: (token) async {
        await _local.write(StorageKey.accessToken, token);
        return Success(token);
      },
      failure: (f) async => Error(f),
    );
  }

  Future<Result<String, Failure>> signup(SignupRequest request) async {
    final result = await asyncGuard(() => _remote.signup(request));
    return result.when(
      success: (token) async {
        await _local.write(StorageKey.accessToken, token);
        return Success(token);
      },
      failure: (f) async => Error(f),
    );
  }

  Future<Result<void, Failure>> logout() async {
    await _local.clearAll();
    return asyncGuard(() => _remote.logout());
  }

  Future<bool> isLoggedIn() async {
    final token = await _local.read<String>(StorageKey.accessToken);
    return token != null && token.isNotEmpty;
  }
}
