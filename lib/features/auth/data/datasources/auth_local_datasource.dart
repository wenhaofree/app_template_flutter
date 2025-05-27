import '../models/user_model.dart';

/// 认证本地数据源接口
abstract class AuthLocalDataSource {
  /// 保存Token
  Future<void> saveToken(String token);
  
  /// 获取Token
  Future<String?> getToken();
  
  /// 保存刷新Token
  Future<void> saveRefreshToken(String refreshToken);
  
  /// 获取刷新Token
  Future<String?> getRefreshToken();
  
  /// 保存用户信息
  Future<void> saveUser(UserModel user);
  
  /// 获取用户信息
  Future<UserModel?> getUser();
  
  /// 清除所有认证数据
  Future<void> clearAuthData();
  
  /// 检查是否有有效Token
  Future<bool> hasValidToken();
}
