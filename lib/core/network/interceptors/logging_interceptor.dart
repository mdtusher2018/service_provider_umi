import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  static const _divider = '-----------------------------------------';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('\n$_divider');
      debugPrint('🚀 REQUEST');
      debugPrint('  Method  : ${options.method}');
      debugPrint('  URL     : ${options.uri}');
      debugPrint('  Headers : ${options.headers}');
      if (options.data != null) {
        debugPrint('  Body    : ${options.data}');
      }
      if (options.queryParameters.isNotEmpty) {
        debugPrint('  Params  : ${options.queryParameters}');
      }
      debugPrint(_divider);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('\n$_divider');
      debugPrint('✅ RESPONSE');
      debugPrint('  Status  : ${response.statusCode}');
      debugPrint('  URL     : ${response.requestOptions.uri}');
      debugPrint('  Data    : ${response.data}');
      debugPrint(_divider);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('\n$_divider');
      debugPrint('❌ ERROR');
      debugPrint('  Type    : ${err.type}');
      debugPrint('  URL     : ${err.requestOptions.uri}');
      debugPrint('  Message : ${err.message}');
      debugPrint('  Status  : ${err.response?.statusCode}');
      debugPrint('  Data    : ${err.response?.data}');
      debugPrint(_divider);
    }
    handler.next(err);
  }
}
