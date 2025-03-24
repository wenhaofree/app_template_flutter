import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_button.dart';

/// 状态显示组件
class StateWidget extends StatelessWidget {
  /// 状态类型
  final StateType type;
  
  /// 标题
  final String? title;
  
  /// 消息
  final String? message;
  
  /// 图标
  final IconData? icon;
  
  /// 按钮文本
  final String? buttonText;
  
  /// 按钮点击事件
  final VoidCallback? onButtonPressed;
  
  /// 构造函数
  const StateWidget({
    super.key,
    required this.type,
    this.title,
    this.message,
    this.icon,
    this.buttonText,
    this.onButtonPressed,
  });
  
  /// 加载状态
  factory StateWidget.loading({
    String? message,
  }) {
    return StateWidget(
      type: StateType.loading,
      message: message ?? '加载中...',
    );
  }
  
  /// 空状态
  factory StateWidget.empty({
    String? title,
    String? message,
    IconData? icon,
    String? buttonText,
    VoidCallback? onButtonPressed,
  }) {
    return StateWidget(
      type: StateType.empty,
      title: title ?? '无数据',
      message: message ?? '暂无数据，请稍后再试',
      icon: icon ?? Icons.inbox_outlined,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
    );
  }
  
  /// 错误状态
  factory StateWidget.error({
    String? title,
    String? message,
    IconData? icon,
    String? buttonText,
    VoidCallback? onButtonPressed,
  }) {
    return StateWidget(
      type: StateType.error,
      title: title ?? '出错了',
      message: message ?? '发生了一些错误，请稍后再试',
      icon: icon ?? Icons.error_outline,
      buttonText: buttonText ?? '重试',
      onButtonPressed: onButtonPressed,
    );
  }
  
  /// 网络错误状态
  factory StateWidget.networkError({
    String? title,
    String? message,
    IconData? icon,
    String? buttonText,
    VoidCallback? onButtonPressed,
  }) {
    return StateWidget(
      type: StateType.networkError,
      title: title ?? '网络错误',
      message: message ?? '请检查您的网络连接后重试',
      icon: icon ?? Icons.signal_wifi_off,
      buttonText: buttonText ?? '重试',
      onButtonPressed: onButtonPressed,
    );
  }
  
  /// 成功状态
  factory StateWidget.success({
    String? title,
    String? message,
    IconData? icon,
    String? buttonText,
    VoidCallback? onButtonPressed,
  }) {
    return StateWidget(
      type: StateType.success,
      title: title ?? '成功',
      message: message,
      icon: icon ?? Icons.check_circle_outline,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    switch (type) {
      case StateType.loading:
        return _buildLoadingState();
      case StateType.empty:
      case StateType.error:
      case StateType.networkError:
      case StateType.success:
        return _buildMessageState(context);
    }
  }
  
  /// 构建加载状态
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            SizedBox(height: 16.h),
            Text(message!),
          ],
        ],
      ),
    );
  }
  
  /// 构建消息状态
  Widget _buildMessageState(BuildContext context) {
    Color iconColor;
    
    switch (type) {
      case StateType.empty:
        iconColor = Colors.grey;
      case StateType.error:
        iconColor = Colors.red;
      case StateType.networkError:
        iconColor = Colors.orange;
      case StateType.success:
        iconColor = Colors.green;
      default:
        iconColor = Theme.of(context).colorScheme.primary;
    }
    
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 64.sp,
                color: iconColor,
              ),
              SizedBox(height: 16.h),
            ],
            if (title != null) ...[
              Text(
                title!,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
            ],
            if (message != null) ...[
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
            ],
            if (buttonText != null && onButtonPressed != null) ...[
              AppButton(
                text: buttonText!,
                onPressed: onButtonPressed,
                type: type == StateType.error || type == StateType.networkError
                    ? AppButtonType.primary
                    : AppButtonType.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 状态类型
enum StateType {
  /// 加载中
  loading,
  
  /// 空数据
  empty,
  
  /// 错误
  error,
  
  /// 网络错误
  networkError,
  
  /// 成功
  success,
} 