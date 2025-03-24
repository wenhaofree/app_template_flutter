import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  
  // 网络客户端
  // getIt.registerSingleton<DioClient>(DioClient());
  
  // 本地存储
  // getIt.registerSingleton<LocalStorage>(LocalStorageImpl(getIt()));
  
  // 日志服务
  // getIt.registerSingleton<LogService>(LogServiceImpl());
  
  // 其他核心服务
}

/// 初始化功能模块依赖
void _initializeFeatureDependencies() {
  // 认证模块
  _initializeAuthDependencies();
  
  // 首页模块
  _initializeHomeDependencies();
  
  // 其他功能模块
}

/// 认证模块依赖
void _initializeAuthDependencies() {
  // 数据源
  // getIt.registerSingleton<AuthRemoteDataSource>(AuthRemoteDataSourceImpl(getIt()));
  // getIt.registerSingleton<AuthLocalDataSource>(AuthLocalDataSourceImpl(getIt()));
  
  // 仓库
  // getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl(getIt(), getIt()));
  
  // 用例
  // getIt.registerFactory<LoginUseCase>(() => LoginUseCase(getIt()));
  // getIt.registerFactory<RegisterUseCase>(() => RegisterUseCase(getIt()));
  // getIt.registerFactory<LogoutUseCase>(() => LogoutUseCase(getIt()));
  
  // 控制器
  // getIt.registerLazySingleton<AuthController>(() => AuthController(getIt(), getIt(), getIt()));
}

/// 首页模块依赖
void _initializeHomeDependencies() {
  // 数据源
  // getIt.registerSingleton<HomeRemoteDataSource>(HomeRemoteDataSourceImpl(getIt()));
  
  // 仓库
  // getIt.registerSingleton<HomeRepository>(HomeRepositoryImpl(getIt()));
  
  // 用例
  // getIt.registerFactory<GetHomeDataUseCase>(() => GetHomeDataUseCase(getIt()));
  
  // 控制器
  // getIt.registerLazySingleton<HomeController>(() => HomeController(getIt()));
} 