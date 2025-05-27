import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// 登录用例
class LoginUseCase {
  final AuthRepository _repository;
  
  LoginUseCase(this._repository);
  
  /// 执行登录
  Future<User> call(String email, String password) async {
    // 验证输入
    if (email.isEmpty) {
      throw ArgumentError('邮箱不能为空');
    }
    
    if (password.isEmpty) {
      throw ArgumentError('密码不能为空');
    }
    
    if (!_isValidEmail(email)) {
      throw ArgumentError('邮箱格式不正确');
    }
    
    if (password.length < 6) {
      throw ArgumentError('密码至少6位');
    }
    
    // 执行登录
    return await _repository.login(email, password);
  }
  
  /// 验证邮箱格式
  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }
}
