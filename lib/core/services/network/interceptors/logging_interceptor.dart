import 'dart:developer';

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
      log('\n$cyan$_divider$reset');
      log('$blue$bold🚀 REQUEST$reset');
      log('$yellow  Method  : ${options.method}$reset');
      log('$yellow  URL     : ${options.uri}$reset');
      log('$magenta  Headers : ${options.headers}$reset');

      if (options.data != null) {
        log('$cyan  Body    : ${options.data}$reset');
      }
      if (options.queryParameters.isNotEmpty) {
        log('$cyan  Params  : ${options.queryParameters}$reset');
      }

      log('$cyan$_divider$reset');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      log('\n$green$_divider$reset');
      log('$green$bold✅ RESPONSE$reset');
      log('$green  Status  : ${response.statusCode}$reset');
      log('$yellow  URL     : ${response.requestOptions.uri}$reset');
      log('$cyan  Data    : ${response.data}$reset');
      log('$green$_divider$reset');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      log('\n$red$_divider$reset');
      log('$red$bold❌ ERROR$reset');
      log('$yellow  Type    : ${err.type}$reset');
      log('$yellow  URL     : ${err.requestOptions.uri}$reset');
      log('$red  Message : ${err.message}$reset');
      log('$magenta  Status  : ${err.response?.statusCode}$reset');
      log('$cyan  Data    : ${err.response?.data}$reset');
      log('$red$_divider$reset');
    }
    handler.next(err);
  }
}
