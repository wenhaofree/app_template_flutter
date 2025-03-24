import 'package:app_template_flutter/features/auth/presentation/screens/auth_screen.dart';
import 'package:app_template_flutter/features/auth/presentation/screens/login_screen.dart';
import 'package:app_template_flutter/features/home/presentation/screens/home_screen.dart';
import 'package:app_template_flutter/features/main/presentation/screens/main_screen.dart';
import 'package:app_template_flutter/features/settings/presentation/screens/settings_screen.dart';
import 'package:app_template_flutter/features/splash/presentation/screens/splash_screen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'app_router.gr.dart';

/// 路由提供者
final appRouterProvider = Provider<AppRouter>((ref) => AppRouter());

/// 路由配置
@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        // 启动页
        AutoRoute(
          page: SplashRoute.page,
          initial: true,
          path: '/',
        ),
        // 身份验证相关路由
        AutoRoute(
          page: AuthRoute.page,
          path: '/auth',
          children: [
            AutoRoute(
              page: LoginRoute.page,
              path: 'login',
              initial: true,
            ),
            // 暂时注释未创建的路由
            // AutoRoute(
            //   page: RegisterRoute.page,
            //   path: 'register',
            // ),
            // AutoRoute(
            //   page: ForgotPasswordRoute.page,
            //   path: 'forgot-password',
            // ),
          ],
        ),
        // 主界面路由
        AutoRoute(
          page: MainRoute.page,
          path: '/main',
          children: [
            AutoRoute(
              page: HomeRoute.page,
              path: 'home',
              initial: true,
            ),
            // 暂时注释未创建的路由
            // AutoRoute(
            //   page: ProfileRoute.page,
            //   path: 'profile',
            // ),
            AutoRoute(
              page: SettingsRoute.page,
              path: 'settings',
            ),
          ],
        ),
      ];
} 