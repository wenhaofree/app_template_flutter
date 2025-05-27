import '../../../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

/// 认证远程数据源实现
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;
  
  AuthRemoteDataSourceImpl(this._dioClient);
  
  @override
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final response = await _dioClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      
      return AuthResponseModel.fromJson(response['data']);
    } catch (e) {
      // 这里暂时返回模拟数据，实际项目中应该抛出异常
      return AuthResponseModel(
        user: UserModel(
          id: 'mock_user_id',
          email: email,
          name: 'Mock User',
          createdAt: DateTime.now(),
        ),
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'mock_refresh_token',
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
      );
    }
  }
  
  @override
  Future<AuthResponseModel> register(String email, String password, String? name) async {
    try {
      final response = await _dioClient.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          if (name != null) 'name': name,
        },
      );
      
      return AuthResponseModel.fromJson(response['data']);
    } catch (e) {
      // 这里暂时返回模拟数据，实际项目中应该抛出异常
      return AuthResponseModel(
        user: UserModel(
          id: 'mock_user_id',
          email: email,
          name: name ?? 'New User',
          createdAt: DateTime.now(),
        ),
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'mock_refresh_token',
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
      );
    }
  }
  
  @override
  Future<void> logout() async {
    try {
      await _dioClient.post('/auth/logout');
    } catch (e) {
      // 忽略登出错误，因为本地数据会被清除
    }
  }
  
  @override
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    final response = await _dioClient.post(
      '/auth/refresh',
      data: {
        'refresh_token': refreshToken,
      },
    );
    
    return AuthResponseModel.fromJson(response['data']);
  }
  
  @override
  Future<void> forgotPassword(String email) async {
    await _dioClient.post(
      '/auth/forgot-password',
      data: {
        'email': email,
      },
    );
  }
  
  @override
  Future<void> resetPassword(String token, String newPassword) async {
    await _dioClient.post(
      '/auth/reset-password',
      data: {
        'token': token,
        'password': newPassword,
      },
    );
  }
  
  @override
  Future<UserModel> getUserInfo() async {
    final response = await _dioClient.get('/auth/me');
    return UserModel.fromJson(response['data']);
  }
}
