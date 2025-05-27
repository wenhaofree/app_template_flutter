import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../network/network_info.dart';
import '../storage/local_storage.dart';
import '../di/injection.dart';
import '../../shared/constants/app_constants.dart';

part 'app_providers.freezed.dart';

/// 应用状态
@freezed
class AppState with _$AppState {
  const factory AppState({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(Locale('zh', 'CN')) Locale locale,
    @Default(true) bool isConnected,
    @Default(false) bool isFirstTime,
  }) = _AppState;
}

/// 应用状态管理器
class AppNotifier extends StateNotifier<AppState> {
  final LocalStorage _localStorage;
  final NetworkInfo _networkInfo;

  AppNotifier(this._localStorage, this._networkInfo) : super(const AppState()) {
    _init();
  }

  /// 初始化应用状态
  Future<void> _init() async {
    await _loadSettings();
    _listenToNetworkChanges();
  }

  /// 加载设置
  Future<void> _loadSettings() async {
    try {
      // 加载主题模式
      final themeModeString = await _localStorage.getString(StorageKeys.themeMode);
      ThemeMode themeMode = ThemeMode.system;
      if (themeModeString != null) {
        switch (themeModeString) {
          case 'light':
            themeMode = ThemeMode.light;
            break;
          case 'dark':
            themeMode = ThemeMode.dark;
            break;
          default:
            themeMode = ThemeMode.system;
        }
      }

      // 加载语言设置
      final localeString = await _localStorage.getString(StorageKeys.locale);
      Locale locale = const Locale('zh', 'CN');
      if (localeString != null) {
        final parts = localeString.split('_');
        if (parts.length == 2) {
          locale = Locale(parts[0], parts[1]);
        }
      }

      // 检查是否首次启动
      final isFirstTime = await _localStorage.getBool(StorageKeys.isFirstTime) ?? true;

      // 检查网络连接
      final isConnected = await _networkInfo.isConnected();

      state = state.copyWith(
        themeMode: themeMode,
        locale: locale,
        isFirstTime: isFirstTime,
        isConnected: isConnected,
      );
    } catch (e) {
      // 加载失败时使用默认值
      debugPrint('Failed to load app settings: $e');
    }
  }

  /// 监听网络状态变化
  void _listenToNetworkChanges() {
    _networkInfo.onConnectivityChanged.listen((connectivityResult) async {
      final isConnected = await _networkInfo.isConnected();
      state = state.copyWith(isConnected: isConnected);
    });
  }

  /// 切换主题模式
  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = state.copyWith(themeMode: themeMode);

    String themeModeString;
    switch (themeMode) {
      case ThemeMode.light:
        themeModeString = 'light';
        break;
      case ThemeMode.dark:
        themeModeString = 'dark';
        break;
      case ThemeMode.system:
        themeModeString = 'system';
        break;
    }

    await _localStorage.setString(StorageKeys.themeMode, themeModeString);
  }

  /// 设置语言
  Future<void> setLocale(Locale locale) async {
    state = state.copyWith(locale: locale);
    await _localStorage.setString(StorageKeys.locale, '${locale.languageCode}_${locale.countryCode}');
  }

  /// 标记不是首次启动
  Future<void> markNotFirstTime() async {
    state = state.copyWith(isFirstTime: false);
    await _localStorage.setBool(StorageKeys.isFirstTime, false);
  }

  /// 重置应用设置
  Future<void> resetSettings() async {
    await _localStorage.remove(StorageKeys.themeMode);
    await _localStorage.remove(StorageKeys.locale);
    await _localStorage.remove(StorageKeys.isFirstTime);

    state = const AppState();
    await _loadSettings();
  }
}

/// 应用状态提供者
final appProvider = StateNotifierProvider<AppNotifier, AppState>((ref) {
  final localStorage = getIt<LocalStorage>();
  final networkInfo = getIt<NetworkInfo>();
  return AppNotifier(localStorage, networkInfo);
});

/// 主题模式提供者（向后兼容）
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(appProvider).themeMode;
});

/// 语言提供者
final localeProvider = Provider<Locale>((ref) {
  return ref.watch(appProvider).locale;
});

/// 网络连接状态提供者
final networkStatusProvider = Provider<bool>((ref) {
  return ref.watch(appProvider).isConnected;
});

/// 是否首次启动提供者
final isFirstTimeProvider = Provider<bool>((ref) {
  return ref.watch(appProvider).isFirstTime;
});
