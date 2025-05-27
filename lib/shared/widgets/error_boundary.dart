import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error/error_handler.dart';

/// 错误边界Widget
class ErrorBoundary extends ConsumerWidget {
  final Widget child;
  final Widget? fallback;
  final void Function(Object error, StackTrace stackTrace)? onError;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.fallback,
    this.onError,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ErrorWidget.builder = (FlutterErrorDetails details) {
      // 处理错误
      if (onError != null) {
        onError!(details.exception, details.stack ?? StackTrace.current);
      } else {
        ErrorHandler.handleAsyncError(
          details.exception,
          stackTrace: details.stack,
        );
      }

      // 返回错误UI
      return fallback ?? _DefaultErrorWidget(error: details.exception);
    };
  }
}

/// 默认错误Widget
class _DefaultErrorWidget extends StatelessWidget {
  final Object error;

  const _DefaultErrorWidget({required this.error});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              '出现了一些问题',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '我们正在努力修复这个问题',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // 重启应用或返回主页
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/',
                  (route) => false,
                );
              },
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 异步错误处理Widget
class AsyncErrorHandler extends ConsumerWidget {
  final AsyncValue<dynamic> asyncValue;
  final Widget Function() data;
  final Widget? loading;
  final Widget Function(Object error, StackTrace stackTrace)? error;

  const AsyncErrorHandler({
    super.key,
    required this.asyncValue,
    required this.data,
    this.loading,
    this.error,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return asyncValue.when(
      data: (_) => data(),
      loading: () => loading ?? const Center(child: CircularProgressIndicator()),
      error: (err, stack) {
        if (error != null) {
          return error!(err, stack);
        }
        
        return _DefaultAsyncErrorWidget(
          error: err,
          stackTrace: stack,
          onRetry: () {
            // 这里可以实现重试逻辑
          },
        );
      },
    );
  }
}

/// 默认异步错误Widget
class _DefaultAsyncErrorWidget extends StatelessWidget {
  final Object error;
  final StackTrace stackTrace;
  final VoidCallback? onRetry;

  const _DefaultAsyncErrorWidget({
    required this.error,
    required this.stackTrace,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              _getErrorMessage(error),
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (onRetry != null)
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('重试'),
              ),
          ],
        ),
      ),
    );
  }

  String _getErrorMessage(Object error) {
    // 这里可以复用ErrorHandler中的逻辑
    return '加载失败，请稍后重试';
  }
}
