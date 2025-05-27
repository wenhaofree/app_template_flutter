import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

/// 认证仓库实现
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  
  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);
  
  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _remoteDataSource.login(email, password);
      
      // 保存认证信息到本地
      await _localDataSource.saveToken(response.token);
      if (response.refreshToken != null) {
        await _localDataSource.saveRefreshToken(response.refreshToken!);
      }
      await _localDataSource.saveUser(response.user);
      
      return response.user.toEntity();
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<User> register(String email, String password, String? name) async {
    try {
      final response = await _remoteDataSource.register(email, password, name);
      
      // 保存认证信息到本地
      await _localDataSource.saveToken(response.token);
      if (response.refreshToken != null) {
        await _localDataSource.saveRefreshToken(response.refreshToken!);
      }
      await _localDataSource.saveUser(response.user);
      
      return response.user.toEntity();
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<void> logout() async {
    try {
      // 先调用远程登出
      await _remoteDataSource.logout();
    } catch (e) {
      // 忽略远程登出错误
    } finally {
      // 清除本地数据
      await _localDataSource.clearAuthData();
    }
  }
  
  @override
  Future<User?> getCurrentUser() async {
    try {
      final userModel = await _localDataSource.getUser();
      return userModel?.toEntity();
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<bool> isLoggedIn() async {
    return await _localDataSource.hasValidToken();
  }
  
  @override
  Future<String> refreshToken() async {
    final refreshToken = await _localDataSource.getRefreshToken();
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }
    
    final response = await _remoteDataSource.refreshToken(refreshToken);
    
    // 保存新的Token
    await _localDataSource.saveToken(response.token);
    if (response.refreshToken != null) {
      await _localDataSource.saveRefreshToken(response.refreshToken!);
    }
    
    return response.token;
  }
  
  @override
  Future<void> forgotPassword(String email) async {
    await _remoteDataSource.forgotPassword(email);
  }
  
  @override
  Future<void> resetPassword(String token, String newPassword) async {
    await _remoteDataSource.resetPassword(token, newPassword);
  }
}
