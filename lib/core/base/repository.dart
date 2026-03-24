import 'package:service_provider_umi/core/base/result.dart';
import 'package:service_provider_umi/core/error/error_handler.dart';
import 'package:service_provider_umi/core/error/failure.dart';

mixin SafeCall {
  Future<Result<T, Failure>> asyncGuard<T>(
    Future<T> Function() operation,
  ) async {
    try {
      final result = await operation();
      return Success(result);
    } catch (e) {
      return Error(ErrorHandler.handle(e));
    }
  }

  Result<T, Failure> guard<T>(T Function() operation) {
    try {
      final result = operation();
      return Success(result);
    } catch (e) {
      return Error(ErrorHandler.handle(e));
    }
  }
}
