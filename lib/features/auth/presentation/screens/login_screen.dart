import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/app_text_field.dart';

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
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // 模拟登录请求
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        // 登录成功后导航到主页
        // context.router.replace(const HomeRoute());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                ),
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // 导航到忘记密码页面
                      // context.router.push(const ForgotPasswordRoute());
                    },
                    child: const Text('忘记密码？'),
                  ),
                ),
                SizedBox(height: 24.h),
                AppButton(
                  text: '登录',
                  isLoading: _isLoading,
                  isFullWidth: true,
                  size: AppButtonSize.large,
                  onPressed: _login,
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('还没有账号？'),
                    TextButton(
                      onPressed: () {
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