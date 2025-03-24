import 'package:logger/logger.dart';
import '../config/app_config.dart';

/// 日志服务
class LogService {
  /// 单例实例
  static final LogService _instance = LogService._internal();
  
  /// 日志对象
  late final Logger _logger;
  
  /// 工厂构造方法
  factory LogService() {
    return _instance;
  }
  
  /// 内部构造方法
  LogService._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      level: AppConfig.enableLogging ? Level.verbose : Level.nothing,
    );
  }
  
  /// 详细日志
  void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (AppConfig.enableLogging) {
      _logger.v(message, error: error, stackTrace: stackTrace);
    }
  }
  
  /// 调试日志
  void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (AppConfig.enableLogging) {
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }
  
  /// 信息日志
  void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (AppConfig.enableLogging) {
      _logger.i(message, error: error, stackTrace: stackTrace);
    }
  }
  
  /// 警告日志
  void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (AppConfig.enableLogging) {
      _logger.w(message, error: error, stackTrace: stackTrace);
    }
  }
  
  /// 错误日志
  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (AppConfig.enableLogging) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }
  
  /// 严重错误日志
  void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (AppConfig.enableLogging) {
      _logger.f(message, error: error, stackTrace: stackTrace);
    }
  }
} 