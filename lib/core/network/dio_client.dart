import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../error/network_exceptions.dart';

/// Dio HTTP客户端
class DioClient {
  final Dio _dio;
  
  /// 创建Dio客户端实例
  DioClient() : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    
    // 添加拦截器
    _dio.interceptors.add(_getAuthInterceptor());
    _dio.interceptors.add(_getLogInterceptor());
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
} 