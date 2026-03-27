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
    LoginEmailRequest request,
  ) async {
    final result = await asyncGuard(() => _remote.loginWithEmail(request));
    return result.when(
      success: (token) async {
        await _local.write(StorageKey.accessToken, token);
        return Success(token);
      },
      failure: (f) async => Error(f),
    );
  }

  Future<Result<String, Failure>> loginWithGoogle(
    LoginGoogleRequest request,
  ) async {
    final result = await asyncGuard(() => _remote.loginWithGoogle(request));
    return result.when(
      success: (token) async {
        await _local.write(StorageKey.accessToken, token);
        return Success(token);
      },
      failure: (f) async => Error(f),
    );
  }

  Future<Result<String, Failure>> loginWithApple(
    LoginAppleRequest request,
  ) async {
    final result = await asyncGuard(() => _remote.loginWithApple(request));
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
  Future<Result<String, Failure>> verifyOtp(String request) async {
    final result = await asyncGuard(() => _remote.verifyOtp(request));
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
