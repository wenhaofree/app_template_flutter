import 'package:flutter/animation.dart';

/// 应用常量类
abstract class AppConstants {
  AppConstants._();
}

/// 存储键常量
abstract class StorageKeys {
  StorageKeys._();

  /// 用户Token
  static const String authToken = 'auth_token';
  
  /// 用户信息
  static const String userInfo = 'user_info';
  
  /// 主题模式
  static const String themeMode = 'theme_mode';
  
  /// 语言
  static const String locale = 'locale';
  
  /// 是否首次启动应用
  static const String isFirstTime = 'is_first_time';
  
  /// 缓存过期时间前缀
  static const String cacheExpirePrefix = 'cache_expire_';
}

/// 持续时间常量
abstract class AppDurations {
  AppDurations._();

  /// 页面转场动画
  static const Duration pageTransition = Duration(milliseconds: 300);
  
  /// 短消息提示
  static const Duration shortMessage = Duration(seconds: 2);
  
  /// 动画
  static const Duration animation = Duration(milliseconds: 350);
  
  /// 启动页停留
  static const Duration splash = Duration(seconds: 2);
}

/// 宽高比常量
abstract class Ratios {
  Ratios._();

  /// 卡片宽高比
  static const double card = 1.5;
  
  /// 列表项宽高比
  static const double listItem = 2.5;
  
  /// 横幅广告宽高比
  static const double banner = 2.1;
}

/// 动画曲线常量
abstract class AppCurves {
  AppCurves._();

  /// 页面转场
  static const pageCurve = Cubic(0.2, 0.0, 0.0, 1.0);
}

/// 数字常量
abstract class Numbers {
  Numbers._();

  /// 最大页面大小
  static const int maxPageSize = 50;
  
  /// 默认页面大小
  static const int defaultPageSize = 20;
  
  /// 最大密码长度
  static const int maxPasswordLength = 32;
  
  /// 最小密码长度
  static const int minPasswordLength = 6;
}

/// 正则表达式常量
abstract class Regexps {
  Regexps._();

  /// 电子邮件
  static final RegExp email = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  
  /// 手机号码（中国）
  static final RegExp phoneNumber = RegExp(
    r'^1[3-9]\d{9}$',
  );
  
  /// 密码（至少包含一个字母和一个数字）
  static final RegExp password = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d!@#$%^&*()_+]{6,}$',
  );
} 