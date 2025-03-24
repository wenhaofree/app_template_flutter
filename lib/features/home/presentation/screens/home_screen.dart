import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_theme.dart';

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => AppTheme.toggleThemeMode(ref),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '欢迎使用Flutter模板',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              '这是一个使用干净架构的Flutter应用模板',
              style: TextStyle(
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: () {
                // 示例操作
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('按钮点击事件')),
                );
              },
              child: const Text('点击按钮'),
            ),
          ],
        ),
      ),
    );
  }
} 