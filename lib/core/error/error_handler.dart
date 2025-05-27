import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/log_service.dart';
import 'network_exceptions.dart';

/// 全局错误处理器
class ErrorHandler {
  static final LogService _logger = LogService();

  /// 处理并显示错误
  static void handleError(
    BuildContext context,
    Object error, {
    StackTrace? stackTrace,
    String? customMessage,
  }) {
    _logger.e('Error occurred', error, stackTrace);

    String message = customMessage ?? _getErrorMessage(error);
    
    if (context.mounted) {
      _showErrorSnackBar(context, message);
    }
  }

  /// 处理异步错误
  static void handleAsyncError(
    Object error, {
    StackTrace? stackTrace,
    String? customMessage,
  }) {
    _logger.e('Async error occurred', error, stackTrace);
    
    // 这里可以发送错误报告到服务器
    _reportError(error, stackTrace, customMessage);
  }

  /// 获取用户友好的错误消息
  static String _getErrorMessage(Object error) {
    if (error is NetworkExceptions) {
      return error.when(
        requestCancelled: () => '请求已取消',
        unauthorisedRequest: () => '未授权访问',
        badRequest: () => '请求参数错误',
        notFound: (reason) => '请求的资源不存在',
        methodNotAllowed: () => '请求方法不被允许',
        notAcceptable: () => '请求不可接受',
        requestTimeout: () => '请求超时，请重试',
        sendTimeout: () => '发送超时，请检查网络连接',
        conflict: () => '请求冲突',
        internalServerError: () => '服务器内部错误',
        notImplemented: () => '功能未实现',
        serviceUnavailable: () => '服务暂不可用',
        noInternetConnection: () => '网络连接不可用，请检查网络设置',
        formatException: () => '数据格式错误',
        unableToProcess: () => '无法处理请求',
        defaultError: (error) => '发生未知错误：$error',
        unexpectedError: () => '发生意外错误',
      );
    }

    if (error is FormatException) {
      return '数据格式错误';
    }

    if (error is TimeoutException) {
      return '操作超时，请重试';
    }

    return '发生未知错误';
  }

  /// 显示错误提示
  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: '关闭',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// 报告错误到服务器
  static void _reportError(
    Object error,
    StackTrace? stackTrace,
    String? customMessage,
  ) {
    if (kDebugMode) {
      // 开发模式下只打印日志
      debugPrint('Error reported: $error');
      return;
    }

    // 生产模式下可以发送到错误收集服务
    // 例如：Firebase Crashlytics, Sentry 等
    Future.microtask(() async {
      try {
        // await crashlytics.recordError(error, stackTrace);
      } catch (e) {
        _logger.w('Failed to report error', e);
      }
    });
  }
}

/// 错误处理Provider
final errorHandlerProvider = Provider<ErrorHandler>((ref) => ErrorHandler());

/// 超时异常
class TimeoutException implements Exception {
  final String message;
  
  const TimeoutException(this.message);
  
  @override
  String toString() => 'TimeoutException: $message';
}
