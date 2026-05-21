import 'package:flutter/foundation.dart';

class AppLogger {
  static const String _tag = 'FlutterCleanRiverpod';

  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('[${tag ?? _tag}] ℹ️ $message');
    }
  }

  static void success(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('[${tag ?? _tag}] ✅ $message');
    }
  }

  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('[${tag ?? _tag}] ⚠️ $message');
    }
  }

  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      debugPrint('[${tag ?? _tag}] ❌ $message');
      if (error != null) debugPrint('Error: $error');
      if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
    }
  }

  static void request(String method, String url, {Map<String, dynamic>? data}) {
    if (kDebugMode) {
      debugPrint('[${_tag}] 🚀 REQUEST → $method $url');
      if (data != null) debugPrint('Data: $data');
    }
  }

  static void response(int? statusCode, String url) {
    if (kDebugMode) {
      debugPrint('[${_tag}] 📥 RESPONSE ← [$statusCode] $url');
    }
  }
}
