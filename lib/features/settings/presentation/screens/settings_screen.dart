import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/providers/app_providers.dart';
import '../../../../../core/router/app_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

@RoutePage()
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appProvider);
    final authState = ref.watch(authProvider);
    final isDarkMode = appState.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('深色模式'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                final newMode = value ? ThemeMode.dark : ThemeMode.light;
                ref.read(appProvider.notifier).setThemeMode(newMode);
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('语言'),
            subtitle: const Text('简体中文'),
            onTap: () {
              // 切换语言
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('通知'),
            onTap: () {
              // 打开通知设置
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('隐私与安全'),
            onTap: () {
              // 打开隐私设置
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('关于'),
            onTap: () {
              // 显示关于信息
              showAboutDialog(
                context: context,
                applicationName: 'Flutter Template',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2023 Flutter Template',
                applicationIcon: const FlutterLogo(size: 50),
              );
            },
          ),
          const Divider(),
          if (authState.isAuthenticated) ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('退出登录', style: TextStyle(color: Colors.red)),
              onTap: () {
                // 退出登录确认
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('确认退出登录'),
                    content: const Text('您确定要退出登录吗？'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('取消'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          // 执行退出登录逻辑
                          await ref.read(authProvider.notifier).logout();
                          // 导航到登录页面
                          if (context.mounted) {
                            context.router.replace(const AuthRoute());
                          }
                        },
                        child: const Text('确定'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}