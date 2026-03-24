import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  static const _divider = '-----------------------------------------';

  // ANSI color codes
  static const reset = '\x1B[0m';
  static const red = '\x1B[31m';
  static const green = '\x1B[32m';
  static const yellow = '\x1B[33m';
  static const blue = '\x1B[34m';
  static const cyan = '\x1B[36m';
  static const magenta = '\x1B[35m';
  static const bold = '\x1B[1m';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('\n$cyan$_divider$reset');
      debugPrint('$blue$bold🚀 REQUEST$reset');
      debugPrint('$yellow  Method  : ${options.method}$reset');
      debugPrint('$yellow  URL     : ${options.uri}$reset');
      debugPrint('$magenta  Headers : ${options.headers}$reset');

      if (options.data != null) {
        debugPrint('$cyan  Body    : ${options.data}$reset');
      }
      if (options.queryParameters.isNotEmpty) {
        debugPrint('$cyan  Params  : ${options.queryParameters}$reset');
      }

      debugPrint('$cyan$_divider$reset');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('\n$green$_divider$reset');
      debugPrint('$green$bold✅ RESPONSE$reset');
      debugPrint('$green  Status  : ${response.statusCode}$reset');
      debugPrint('$yellow  URL     : ${response.requestOptions.uri}$reset');
      debugPrint('$cyan  Data    : ${response.data}$reset');
      debugPrint('$green$_divider$reset');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('\n$red$_divider$reset');
      debugPrint('$red$bold❌ ERROR$reset');
      debugPrint('$yellow  Type    : ${err.type}$reset');
      debugPrint('$yellow  URL     : ${err.requestOptions.uri}$reset');
      debugPrint('$red  Message : ${err.message}$reset');
      debugPrint('$magenta  Status  : ${err.response?.statusCode}$reset');
      debugPrint('$cyan  Data    : ${err.response?.data}$reset');
      debugPrint('$red$_divider$reset');
    }
    handler.next(err);
  }
}
