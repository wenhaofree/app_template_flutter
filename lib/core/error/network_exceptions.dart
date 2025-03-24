import 'dart:io';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_exceptions.freezed.dart';

/// 网络请求异常处理
@freezed
class NetworkExceptions with _$NetworkExceptions {
  /// 请求取消
  const factory NetworkExceptions.requestCancelled() = RequestCancelled;
  
  /// 未授权请求
  const factory NetworkExceptions.unauthorizedRequest() = UnauthorizedRequest;
  
  /// 错误的请求
  const factory NetworkExceptions.badRequest() = BadRequest;
  
  /// 禁止访问
  const factory NetworkExceptions.forbidden() = Forbidden;
  
  /// 请求未找到
  const factory NetworkExceptions.notFound(String reason) = NotFound;
  
  /// 请求方法不允许
  const factory NetworkExceptions.methodNotAllowed() = MethodNotAllowed;
  
  /// 请求超时
  const factory NetworkExceptions.requestTimeout() = RequestTimeout;
  
  /// 服务器内部错误
  const factory NetworkExceptions.internalServerError() = InternalServerError;
  
  /// 服务不可用
  const factory NetworkExceptions.serviceUnavailable() = ServiceUnavailable;
  
  /// 没有网络连接
  const factory NetworkExceptions.noInternetConnection() = NoInternetConnection;
  
  /// 格式错误
  const factory NetworkExceptions.formatException() = FormatException;
  
  /// 响应解析错误
  const factory NetworkExceptions.unableToProcess() = UnableToProcess;
  
  /// 默认错误
  const factory NetworkExceptions.defaultError(String error) = DefaultError;
  
  /// 意外错误
  const factory NetworkExceptions.unexpectedError() = UnexpectedError;
  
  /// 根据Dio异常创建网络异常
  static NetworkExceptions fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return const NetworkExceptions.requestCancelled();
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const NetworkExceptions.requestTimeout();
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case 400:
            return const NetworkExceptions.badRequest();
          case 401:
            return const NetworkExceptions.unauthorizedRequest();
          case 403:
            return const NetworkExceptions.forbidden();
          case 404:
            return const NetworkExceptions.notFound("请求的资源不存在");
          case 409:
            return const NetworkExceptions.defaultError("资源冲突");
          case 408:
            return const NetworkExceptions.requestTimeout();
          case 500:
            return const NetworkExceptions.internalServerError();
          case 503:
            return const NetworkExceptions.serviceUnavailable();
          default:
            return NetworkExceptions.defaultError(
              "发生错误，状态码: ${error.response?.statusCode}",
            );
        }
      case DioExceptionType.connectionError:
        return const NetworkExceptions.noInternetConnection();
      case DioExceptionType.badCertificate:
        return const NetworkExceptions.defaultError("证书验证失败");
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return const NetworkExceptions.noInternetConnection();
        }
        return const NetworkExceptions.unexpectedError();
      default:
        return const NetworkExceptions.unexpectedError();
    }
  }
  
  /// 获取错误消息
  static String getErrorMessage(NetworkExceptions networkExceptions) {
    return networkExceptions.when(
      requestCancelled: () => "请求已取消",
      unauthorizedRequest: () => "未授权请求",
      badRequest: () => "错误的请求",
      forbidden: () => "服务器拒绝请求",
      notFound: (String reason) => reason,
      methodNotAllowed: () => "请求方法不允许",
      requestTimeout: () => "请求超时",
      internalServerError: () => "服务器内部错误",
      serviceUnavailable: () => "服务不可用",
      noInternetConnection: () => "无网络连接",
      formatException: () => "响应格式错误",
      unableToProcess: () => "无法处理数据",
      defaultError: (String error) => error,
      unexpectedError: () => "发生意外错误",
    );
  }
} 