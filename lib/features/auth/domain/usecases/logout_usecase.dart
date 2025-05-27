import '../repositories/auth_repository.dart';

/// 登出用例
class LogoutUseCase {
  final AuthRepository _repository;
  
  LogoutUseCase(this._repository);
  
  /// 执行登出
  Future<void> call() async {
    await _repository.logout();
  }
}
