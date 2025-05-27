import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

part 'auth_provider.freezed.dart';

/// 认证状态
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isLoading,
    @Default(false) bool isAuthenticated,
    User? user,
    String? error,
    String? token,
  }) = _AuthState;
}

/// 认证状态管理器
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthNotifier(this._loginUseCase, this._registerUseCase, this._logoutUseCase)
      : super(const AuthState());

  /// 登录
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _loginUseCase(email, password);

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        token: 'token_placeholder', // 实际项目中从响应获取
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 注册
  Future<void> register(String email, String password, [String? name]) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _registerUseCase(email, password, name);

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        token: 'token_placeholder', // 实际项目中从响应获取
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 登出
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _logoutUseCase();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '登出失败：${e.toString()}',
      );
    }
  }

  /// 清除错误
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// 从本地存储恢复状态
  Future<void> restoreAuthState() async {
    // TODO: 从本地存储读取token和用户信息
    // 这里暂时模拟
    await Future.delayed(const Duration(milliseconds: 100));

    // 如果有有效的token，设置为已认证状态
    // final token = await _localStorage.getString('auth_token');
    // if (token != null && token.isNotEmpty) {
    //   state = state.copyWith(
    //     isAuthenticated: true,
    //     token: token,
    //     email: await _localStorage.getString('user_email') ?? '',
    //   );
    // }
  }
}

/// 认证状态提供者
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final loginUseCase = getIt<LoginUseCase>();
  final registerUseCase = getIt<RegisterUseCase>();
  final logoutUseCase = getIt<LogoutUseCase>();

  return AuthNotifier(loginUseCase, registerUseCase, logoutUseCase);
});

/// 是否已认证的计算属性
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

/// 当前用户的计算属性
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

/// 当前用户邮箱的计算属性
final currentUserEmailProvider = Provider<String>((ref) {
  final user = ref.watch(authProvider).user;
  return user?.email ?? '';
});
