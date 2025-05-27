import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../storage/local_storage.dart';
import '../storage/local_storage_impl.dart';
import '../utils/log_service.dart';

// Auth imports
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_local_datasource_impl.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';

final getIt = GetIt.instance;

/// 初始化依赖注入
Future<void> initializeDependencies() async {
  // 核心服务
  await _initializeCoreDependencies();

  // 功能模块
  _initializeFeatureDependencies();
}

/// 初始化核心依赖
Future<void> _initializeCoreDependencies() async {
  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // 网络连接检查
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  // 网络客户端
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // 本地存储
  getIt.registerLazySingleton<LocalStorage>(() => LocalStorageImpl(getIt()));

  // 日志服务
  getIt.registerLazySingleton<LogService>(() => LogService());
}

/// 初始化功能模块依赖
void _initializeFeatureDependencies() {
  // 认证模块
  _initializeAuthDependencies();

  // 首页模块
  _initializeHomeDependencies();

  // 设置模块
  _initializeSettingsDependencies();

  // 其他功能模块
}

/// 认证模块依赖
void _initializeAuthDependencies() {
  // 数据源
  getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(getIt()));

  // 仓库
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt(), getIt()));

  // 用例
  getIt.registerFactory<LoginUseCase>(() => LoginUseCase(getIt()));
  getIt.registerFactory<RegisterUseCase>(() => RegisterUseCase(getIt()));
  getIt.registerFactory<LogoutUseCase>(() => LogoutUseCase(getIt()));
}

/// 首页模块依赖
void _initializeHomeDependencies() {
  // 暂时注释，等待实现具体的类
  // 数据源
  // getIt.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(getIt()));

  // 仓库
  // getIt.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(getIt()));

  // 用例
  // getIt.registerFactory<GetHomeDataUseCase>(() => GetHomeDataUseCase(getIt()));
}

/// 设置模块依赖
void _initializeSettingsDependencies() {
  // 暂时注释，等待实现具体的类
  // 仓库
  // getIt.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(getIt()));

  // 用例
  // getIt.registerFactory<UpdateThemeUseCase>(() => UpdateThemeUseCase(getIt()));
  // getIt.registerFactory<UpdateLanguageUseCase>(() => UpdateLanguageUseCase(getIt()));
}