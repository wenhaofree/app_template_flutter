import '../models/auth_response_model.dart';
import '../models/user_model.dart';

/// 认证远程数据源接口
abstract class AuthRemoteDataSource {
  /// 登录
  Future<AuthResponseModel> login(String email, String password);
  
  /// 注册
  Future<AuthResponseModel> register(String email, String password, String? name);
  
  /// 登出
  Future<void> logout();
  
  /// 刷新Token
  Future<AuthResponseModel> refreshToken(String refreshToken);
  
  /// 忘记密码
  Future<void> forgotPassword(String email);
  
  /// 重置密码
  Future<void> resetPassword(String token, String newPassword);
  
  /// 获取用户信息
  Future<UserModel> getUserInfo();
}
