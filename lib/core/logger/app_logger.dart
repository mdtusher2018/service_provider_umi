import 'package:flutter/foundation.dart';

class AppLogger {
  static const _divider = '-----------------------------------------';

  // ANSI color codes
  static const _reset = '\x1B[0m';
  static const _red = '\x1B[31m';
  static const _green = '\x1B[32m';
  static const _yellow = '\x1B[33m';
  static const _blue = '\x1B[34m';
  static const _cyan = '\x1B[36m';
  static const _magenta = '\x1B[35m';
  static const _bold = '\x1B[1m';

  // Base logger
  static void _log(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }

  // Info log
  static void info(String message) {
    _log('$_blue$_boldℹ️ INFO:$_reset $message');
  }

  // Success log
  static void success(String message) {
    _log('$_green$_bold✅ SUCCESS:$_reset $message');
  }

  // Warning log
  static void warning(String message) {
    _log('$_yellow$_bold⚠️ WARNING:$_reset $message');
  }

  // Error log
  static void error(String message) {
    _log('$_red$_bold❌ ERROR:$_reset $message');
  }

  // Debug log (general)
  static void debug(String message) {
    _log('$_cyan$_bold🐛 DEBUG:$_reset $message');
  }

  // Pretty section log
  static void block({
    required String title,
    required Map<String, dynamic> data,
  }) {
    if (!kDebugMode) return;

    debugPrint('\n$_magenta$_divider$_reset');
    debugPrint('$_bold$title$_reset');

    data.forEach((key, value) {
      debugPrint('$_cyan$key:$_reset $value');
    });

    debugPrint('$_magenta$_divider$_reset');
  }
}
