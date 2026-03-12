abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const AppException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'AppException(message: $message, statusCode: $statusCode)';
}

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection. Please check your network.',
    super.statusCode,
  });
}

class ServerException extends AppException {
  const ServerException({
    super.message = 'Server error occurred. Please try again.',
    super.statusCode,
    super.data,
  });
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Session expired. Please login again.',
    super.statusCode = 401,
  });
}

class ForbiddenException extends AppException {
  const ForbiddenException({
    super.message = 'You do not have permission to perform this action.',
    super.statusCode = 403,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'The requested resource was not found.',
    super.statusCode = 404,
  });
}

class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  const ValidationException({
    super.message = 'Validation failed.',
    super.statusCode = 422,
    this.errors,
    super.data,
  });
}

class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Request timed out. Please try again.',
  });
}

class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache error occurred.',
  });
}

class PaymentException extends AppException {
  const PaymentException({
    required super.message,
    super.statusCode,
  });
}

class UploadException extends AppException {
  const UploadException({
    super.message = 'File upload failed. Please try again.',
  });
}

class LocationException extends AppException {
  const LocationException({
    super.message = 'Unable to retrieve location. Check permissions.',
  });
}

class CallException extends AppException {
  const CallException({
    super.message = 'Call failed. Please try again.',
  });
}
