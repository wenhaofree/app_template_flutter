import '../entities/user.dart';

/// 认证仓库接口
abstract class AuthRepository {
  /// 登录
  Future<User> login(String email, String password);
  
  /// 注册
  Future<User> register(String email, String password, String? name);
  
  /// 登出
  Future<void> logout();
  
  /// 获取当前用户
  Future<User?> getCurrentUser();
  
  /// 检查是否已登录
  Future<bool> isLoggedIn();
  
  /// 刷新Token
  Future<String> refreshToken();
  
  /// 忘记密码
  Future<void> forgotPassword(String email);
  
  /// 重置密码
  Future<void> resetPassword(String token, String newPassword);
}
