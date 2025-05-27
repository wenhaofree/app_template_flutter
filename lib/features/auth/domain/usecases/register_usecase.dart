import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// 注册用例
class RegisterUseCase {
  final AuthRepository _repository;
  
  RegisterUseCase(this._repository);
  
  /// 执行注册
  Future<User> call(String email, String password, String? name) async {
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
    
    if (!_isValidPassword(password)) {
      throw ArgumentError('密码必须包含字母和数字');
    }
    
    // 执行注册
    return await _repository.register(email, password, name);
  }
  
  /// 验证邮箱格式
  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }
  
  /// 验证密码强度
  bool _isValidPassword(String password) {
    return RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d!@#$%^&*()_+]{6,}$')
        .hasMatch(password);
  }
}
