import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../config/app_config.dart';
import '../error/network_exceptions.dart';
import '../storage/local_storage.dart';
import '../di/injection.dart';

/// Dio HTTP客户端
class DioClient {
  final Dio _dio;
  final LocalStorage _localStorage;
  final Connectivity _connectivity;

  /// 创建Dio客户端实例
  DioClient() :
    _dio = Dio(),
    _localStorage = getIt<LocalStorage>(),
    _connectivity = getIt<Connectivity>() {
    _dio.options = BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // 添加拦截器
    _dio.interceptors.add(_getNetworkInterceptor());
    _dio.interceptors.add(_getCacheInterceptor());
    _dio.interceptors.add(_getRetryInterceptor());
    _dio.interceptors.add(_getAuthInterceptor());
    _dio.interceptors.add(_getLogInterceptor());
  }

  /// 网络连接检查拦截器
  Interceptor _getNetworkInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final connectivityResult = await _connectivity.checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          return handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.connectionError,
              message: '网络连接不可用',
            ),
          );
        }
        return handler.next(options);
      },
    );
  }

  /// 缓存拦截器
  Interceptor _getCacheInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 只对GET请求进行缓存
        if (options.method.toUpperCase() == 'GET') {
          final cacheKey = _getCacheKey(options);
          final cachedData = await _localStorage.getString(cacheKey);
          final cacheExpireKey = 'cache_expire_$cacheKey';
          final expireTime = await _localStorage.getInt(cacheExpireKey);

          if (cachedData != null && expireTime != null) {
            final now = DateTime.now().millisecondsSinceEpoch;
            if (now < expireTime) {
              // 缓存未过期，返回缓存数据
              final response = Response(
                requestOptions: options,
                data: cachedData,
                statusCode: 200,
              );
              return handler.resolve(response);
            }
          }
        }
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        // 缓存GET请求的响应
        if (response.requestOptions.method.toUpperCase() == 'GET' &&
            response.statusCode == 200) {
          final cacheKey = _getCacheKey(response.requestOptions);
          final cacheExpireKey = 'cache_expire_$cacheKey';
          final expireTime = DateTime.now().add(const Duration(minutes: 5)).millisecondsSinceEpoch;

          await _localStorage.setString(cacheKey, response.data.toString());
          await _localStorage.setInt(cacheExpireKey, expireTime);
        }
        return handler.next(response);
      },
    );
  }

  /// 重试拦截器
  Interceptor _getRetryInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        if (_shouldRetry(error)) {
          final retryCount = error.requestOptions.extra['retryCount'] ?? 0;
          if (retryCount < 3) {
            error.requestOptions.extra['retryCount'] = retryCount + 1;

            // 延迟重试
            await Future.delayed(Duration(seconds: retryCount + 1));

            try {
              final response = await _dio.fetch(error.requestOptions);
              return handler.resolve(response);
            } catch (e) {
              return handler.next(error);
            }
          }
        }
        return handler.next(error);
      },
    );
  }

  /// 身份验证拦截器
  Interceptor _getAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 从本地存储获取Token并添加到请求头
        // final authToken = await _getAuthToken();
        // if (authToken != null && authToken.isNotEmpty) {
        //   options.headers['Authorization'] = 'Bearer $authToken';
        // }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        // 处理401错误（Token过期）
        if (error.response?.statusCode == 401) {
          // 尝试刷新Token
          // final newToken = await _refreshToken();
          // if (newToken != null) {
          //   // 使用新Token重试请求
          //   final opts = error.requestOptions;
          //   opts.headers['Authorization'] = 'Bearer $newToken';
          //   final response = await _dio.fetch(opts);
          //   return handler.resolve(response);
          // }
        }
        return handler.next(error);
      },
    );
  }

  /// 日志拦截器
  Interceptor _getLogInterceptor() {
    return LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    );
  }

  /// 发送GET请求
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw NetworkExceptions.fromDioException(e);
    } catch (e) {
      throw NetworkExceptions.unexpectedError();
    }
  }

  /// 发送POST请求
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw NetworkExceptions.fromDioException(e);
    } catch (e) {
      throw NetworkExceptions.unexpectedError();
    }
  }

  /// 发送PUT请求
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw NetworkExceptions.fromDioException(e);
    } catch (e) {
      throw NetworkExceptions.unexpectedError();
    }
  }

  /// 发送DELETE请求
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw NetworkExceptions.fromDioException(e);
    } catch (e) {
      throw NetworkExceptions.unexpectedError();
    }
  }

  /// 生成缓存键
  String _getCacheKey(RequestOptions options) {
    final uri = options.uri.toString();
    final queryParams = options.queryParameters.toString();
    return 'cache_${uri}_$queryParams'.hashCode.toString();
  }

  /// 判断是否应该重试
  bool _shouldRetry(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        // 5xx 服务器错误可以重试
        final statusCode = error.response?.statusCode;
        return statusCode != null && statusCode >= 500;
      default:
        return false;
    }
  }

  /// 清除缓存
  Future<void> clearCache() async {
    // 这里可以实现更精确的缓存清理逻辑
    // 暂时简单实现
  }

  /// 清除特定URL的缓存
  Future<void> clearCacheForUrl(String url) async {
    final cacheKey = 'cache_${url}'.hashCode.toString();
    await _localStorage.remove(cacheKey);
    await _localStorage.remove('cache_expire_$cacheKey');
  }
}