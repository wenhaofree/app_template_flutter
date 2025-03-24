import 'package:flutter/foundation.dart';

/// 应用环境类型
enum Environment {
  /// 开发环境
  dev,
  
  /// 测试环境
  test,
  
  /// 生产环境
  prod,
}

/// 应用程序配置
class AppConfig {
  /// 当前环境
  static Environment environment = Environment.dev;
  
  /// API基础URL
  static String get apiBaseUrl {
    switch (environment) {
      case Environment.dev:
        return 'https://dev-api.example.com/v1';
      case Environment.test:
        return 'https://test-api.example.com/v1';
      case Environment.prod:
        return 'https://api.example.com/v1';
    }
  }
  
  /// 应用名称
  static String get appName {
    switch (environment) {
      case Environment.dev:
        return 'Flutter Template (Dev)';
      case Environment.test:
        return 'Flutter Template (Test)';
      case Environment.prod:
        return 'Flutter Template';
    }
  }
  
  /// 是否启用日志
  static bool get enableLogging {
    return environment != Environment.prod || kDebugMode;
  }
  
  /// 设置环境
  static void setEnvironment(Environment env) {
    environment = env;
  }
  
  /// 缓存配置
  static Duration get cacheMaxAge => const Duration(days: 7);
  
  /// 缓存清理频率
  static Duration get cacheClearInterval => const Duration(days: 1);
} 