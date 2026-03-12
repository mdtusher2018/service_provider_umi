import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
abstract class Failure with _$Failure {
  const factory Failure.network({
    @Default('No internet connection. Please check your network.')
    String message,
  }) = NetworkFailure;

  const factory Failure.server({
    @Default('Server error occurred. Please try again.') String message,
    int? statusCode,
    dynamic data,
  }) = ServerFailure;

  const factory Failure.unauthorized({
    @Default('Session expired. Please login again.') String message,
  }) = UnauthorizedFailure;

  const factory Failure.forbidden({
    @Default('You do not have permission to perform this action.')
    String message,
  }) = ForbiddenFailure;

  const factory Failure.notFound({
    @Default('The requested resource was not found.') String message,
  }) = NotFoundFailure;

  const factory Failure.validation({
    @Default('Validation failed.') String message,
    Map<String, List<String>>? errors,
  }) = ValidationFailure;

  const factory Failure.timeout({
    @Default('Request timed out. Please try again.') String message,
  }) = TimeoutFailure;

  const factory Failure.cache({
    @Default('Cache error occurred.') String message,
  }) = CacheFailure;

  const factory Failure.payment({required String message}) = PaymentFailure;

  const factory Failure.upload({
    @Default('File upload failed. Please try again.') String message,
  }) = UploadFailure;

  const factory Failure.location({
    @Default('Unable to retrieve location. Check permissions.') String message,
  }) = LocationFailure;

  const factory Failure.unknown({
    @Default('An unexpected error occurred.') String message,
  }) = UnknownFailure;
}
