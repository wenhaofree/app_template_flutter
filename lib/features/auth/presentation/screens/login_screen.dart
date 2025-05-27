import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/app_text_field.dart';
import '../../../../../core/router/app_router.dart';
import '../providers/auth_provider.dart';

@RoutePage()
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // 监听认证状态变化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listen<AuthState>(authProvider, (previous, next) {
        if (next.isAuthenticated && !next.isLoading) {
          // 登录成功，导航到主页
          context.router.replace(const MainRoute());
        }

        if (next.error != null) {
          // 显示错误信息
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error!),
              backgroundColor: Colors.red,
            ),
          );
          // 清除错误
          ref.read(authProvider.notifier).clearError();
        }
      });
    });
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authProvider.notifier).login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('登录'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h),
                Icon(
                  Icons.flutter_dash,
                  size: 100.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(height: 40.h),
                AppTextField(
                  controller: _emailController,
                  label: '电子邮箱',
                  hint: '请输入您的电子邮箱',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  isRequired: true,
                  enabled: !authState.isLoading,
                ),
                SizedBox(height: 16.h),
                AppTextField(
                  controller: _passwordController,
                  label: '密码',
                  hint: '请输入您的密码',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  isRequired: true,
                  autofillHints: const [AutofillHints.password],
                  enabled: !authState.isLoading,
                ),
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: authState.isLoading ? null : () {
                      // 导航到忘记密码页面
                      // context.router.push(const ForgotPasswordRoute());
                    },
                    child: const Text('忘记密码？'),
                  ),
                ),
                SizedBox(height: 24.h),
                AppButton(
                  text: '登录',
                  isLoading: authState.isLoading,
                  isFullWidth: true,
                  size: AppButtonSize.large,
                  onPressed: authState.isLoading ? null : _login,
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('还没有账号？'),
                    TextButton(
                      onPressed: authState.isLoading ? null : () {
                        // 导航到注册页面
                        // context.router.push(const RegisterRoute());
                      },
                      child: const Text('注册'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}