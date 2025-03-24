import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/di/injection.dart';
import 'core/utils/log_service.dart';

final LogService _logger = LogService();

Future<void> main() async {
  // 捕获全局错误
  runZonedGuarded(() async {
    // 确保Flutter绑定初始化
    WidgetsFlutterBinding.ensureInitialized();
    
    // 配置系统UI样式
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // 设置状态栏样式
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    
    // 初始化Hive数据库
    await Hive.initFlutter();
    
    // 设置应用环境
    AppConfig.setEnvironment(Environment.dev);
    
    // 初始化依赖注入
    await initializeDependencies();
    
    // 启动应用
    runApp(
      const ProviderScope(
        child: App(),
      ),
    );
  }, (error, stack) {
    // 记录全局错误
    _logger.e('Global error', error, stack);
  });
}
