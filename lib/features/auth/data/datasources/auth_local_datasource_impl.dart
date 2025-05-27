import '../../../../core/storage/local_storage.dart';
import '../../../../shared/constants/app_constants.dart';
import '../models/user_model.dart';
import 'auth_local_datasource.dart';

/// 认证本地数据源实现
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalStorage _localStorage;
  
  AuthLocalDataSourceImpl(this._localStorage);
  
  @override
  Future<void> saveToken(String token) async {
    await _localStorage.setString(StorageKeys.authToken, token);
  }
  
  @override
  Future<String?> getToken() async {
    return await _localStorage.getString(StorageKeys.authToken);
  }
  
  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    await _localStorage.setString('refresh_token', refreshToken);
  }
  
  @override
  Future<String?> getRefreshToken() async {
    return await _localStorage.getString('refresh_token');
  }
  
  @override
  Future<void> saveUser(UserModel user) async {
    await _localStorage.setObject(
      StorageKeys.userInfo,
      user,
      (user) => user.toJson(),
    );
  }
  
  @override
  Future<UserModel?> getUser() async {
    return await _localStorage.getObject(
      StorageKeys.userInfo,
      (json) => UserModel.fromJson(json),
    );
  }
  
  @override
  Future<void> clearAuthData() async {
    await Future.wait([
      _localStorage.remove(StorageKeys.authToken),
      _localStorage.remove('refresh_token'),
      _localStorage.remove(StorageKeys.userInfo),
    ]);
  }
  
  @override
  Future<bool> hasValidToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
