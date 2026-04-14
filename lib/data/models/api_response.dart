// models/api_response.dart

class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final ApiError? error;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromData,
  ) => ApiResponse(
    success: json['success'] as bool,
    message: json['message'] as String?,
    data: json['data'] != null && fromData != null
        ? fromData(json['data'])
        : null,
    error: json['error'] != null
        ? ApiError.fromJson(json['error'] as Map<String, dynamic>)
        : null,
  );
}

class ApiError {
  final String code;
  final String message;

  const ApiError({required this.code, required this.message});

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
    code: json['code'] as String,
    message: json['message'] as String,
  );
}

class PaginationMeta {
  final int page;
  final int limit;
  final int totalPage;

  final bool hasMore;

  const PaginationMeta({
    required this.page,
    required this.limit,
    required this.totalPage,
    this.hasMore = false,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) => PaginationMeta(
    page: json['page'] as int,
    limit: json['limit'] as int,
    totalPage: json['totalPage'] as int,
    hasMore: json['hasMore'] as bool,
  );
}
