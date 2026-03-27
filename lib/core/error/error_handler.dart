import 'dart:io';
import 'package:dio/dio.dart';
import 'app_exception.dart';
import 'failure.dart';

class ErrorHandler {
  ErrorHandler._();

  static Failure handle(dynamic error) {
    if (error is DioException) {
      return _handleDioException(error);
    } else if (error is AppException) {
      return _handleAppException(error);
    } else if (error is SocketException) {
      return const Failure.network();
    } else if (error is FormatException) {
      return const Failure.server(message: 'Invalid data format received.');
    } else {
      return Failure.unknown(message: error?.toString() ?? 'Unknown error');
    }
  }

  static Failure _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const Failure.timeout();

      case DioExceptionType.connectionError:
        final message = error.message ?? '';
        if (message.contains('Failed host lookup')) {
          return const Failure.server(
            message: 'Server not reachable. Please try again later.',
          );
        }

        return const Failure.network();

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.cancel:
        return const Failure.unknown(message: 'Request was cancelled.');

      default:
        return const Failure.unknown();
    }
  }

  static Failure _handleResponseError(Response? response) {
    if (response == null) return const Failure.unknown();

    final statusCode = response.statusCode ?? 0;
    final data = response.data;
    final message = _extractMessage(data) ?? _defaultMessage(statusCode);

    switch (statusCode) {
      case 400:
        return Failure.server(
          message: message,
          statusCode: statusCode,
          data: data,
        );
      case 401:
        return Failure.unauthorized(message: message);
      case 403:
        return Failure.forbidden(message: message);
      case 404:
        return Failure.notFound(message: message);
      case 422:
        final errors = _extractValidationErrors(data);
        return Failure.validation(message: message, errors: errors);
      case >= 500:
        return Failure.server(message: message, statusCode: statusCode);
      default:
        return Failure.server(message: message, statusCode: statusCode);
    }
  }

  static Failure _handleAppException(AppException exception) {
    if (exception is NetworkException)
      return Failure.network(message: exception.message);
    if (exception is UnauthorizedException)
      return Failure.unauthorized(message: exception.message);
    if (exception is ForbiddenException)
      return Failure.forbidden(message: exception.message);
    if (exception is NotFoundException)
      return Failure.notFound(message: exception.message);
    if (exception is ValidationException) {
      return Failure.validation(
        message: exception.message,
        errors: exception.errors,
      );
    }
    if (exception is TimeoutException)
      return Failure.timeout(message: exception.message);
    if (exception is CacheException)
      return Failure.cache(message: exception.message);
    if (exception is PaymentException)
      return Failure.payment(message: exception.message);
    if (exception is UploadException)
      return Failure.upload(message: exception.message);
    if (exception is LocationException)
      return Failure.location(message: exception.message);
    return Failure.server(
      message: exception.message,
      statusCode: exception.statusCode,
    );
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['msg'] as String?;
    }
    return null;
  }

  static Map<String, List<String>>? _extractValidationErrors(dynamic data) {
    if (data is Map<String, dynamic>) {
      final errorsData = data['errors'];
      if (errorsData is Map<String, dynamic>) {
        return errorsData.map(
          (key, value) =>
              MapEntry(key, (value as List).map((e) => e.toString()).toList()),
        );
      }
    }
    return null;
  }

  static String _defaultMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Session expired. Please login again.';
      case 403:
        return 'You do not have permission to perform this action.';
      case 404:
        return 'The requested resource was not found.';
      case 408:
        return 'Request timed out. Please try again.';
      case 422:
        return 'Validation failed. Please check your input.';
      case 429:
        return 'Too many requests. Please wait and try again.';
      case 500:
        return 'Internal server error. Please try again later.';
      case 502:
        return 'Bad gateway. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return 'An unexpected error occurred.';
    }
  }
}
