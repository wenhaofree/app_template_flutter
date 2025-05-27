import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/di/injection.dart';
import 'core/utils/log_service.dart';
import 'core/utils/performance_monitor.dart';

final LogService _logger = LogService();

Future<void> main() async {
  // 开始性能监控
  PerformanceMonitor.startTimer('app_startup');

  // 捕获全局错误
  runZonedGuarded(() async {
    // 确保Flutter绑定初始化
    WidgetsFlutterBinding.ensureInitialized();

    // 启动帧率监控
    PerformanceMonitor.startFrameMonitoring();

    // 并行执行初始化任务
    await PerformanceMonitor.measureAsync('initialization', () async {
      await Future.wait([
        _initializeSystemUI(),
        _initializeStorage(),
        _initializeConfig(),
      ]);
    });

    // 初始化依赖注入（核心依赖）
    await PerformanceMonitor.measureAsync('dependency_injection', () async {
      await initializeDependencies();
    });

    // 启动应用
    runApp(
      const ProviderScope(
        child: App(),
      ),
    );

    // 结束启动计时
    PerformanceMonitor.endTimer('app_startup');

    // 后台初始化非关键依赖
    _initializeBackgroundServices();
  }, (error, stack) {
    // 记录全局错误
    _logger.e('Global error', error, stack);
  });
}

/// 初始化系统UI
Future<void> _initializeSystemUI() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
}

/// 初始化存储
Future<void> _initializeStorage() async {
  await Hive.initFlutter();
}

/// 初始化配置
Future<void> _initializeConfig() async {
  AppConfig.setEnvironment(Environment.dev);
}

/// 后台初始化非关键服务
void _initializeBackgroundServices() {
  // 在后台初始化一些非关键的服务
  Future.microtask(() async {
    try {
      await PerformanceMonitor.measureAsync('background_services', () async {
        // 预热网络连接
        // 预加载一些资源
        // 初始化分析服务等

        // 延迟一段时间后打印性能统计
        await Future.delayed(const Duration(seconds: 5));
        PerformanceMonitor.printStats();
      });
    } catch (e) {
      _logger.w('Background services initialization failed', e);
    }
  });
}
