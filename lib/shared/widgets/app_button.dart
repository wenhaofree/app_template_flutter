import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 按钮类型
enum AppButtonType {
  /// 主要按钮
  primary,
  
  /// 次要按钮
  secondary,
  
  /// 文本按钮
  text,
  
  /// 危险按钮
  danger,
}

/// 按钮大小
enum AppButtonSize {
  /// 小按钮
  small,
  
  /// 中按钮
  medium,
  
  /// 大按钮
  large,
}

/// 应用按钮
class AppButton extends StatelessWidget {
  /// 按钮文本
  final String text;
  
  /// 点击事件
  final VoidCallback? onPressed;
  
  /// 按钮类型
  final AppButtonType type;
  
  /// 按钮大小
  final AppButtonSize size;
  
  /// 是否加载中
  final bool isLoading;
  
  /// 是否撑满宽度
  final bool isFullWidth;
  
  /// 按钮前缀图标
  final IconData? prefixIcon;
  
  /// 按钮后缀图标
  final IconData? suffixIcon;
  
  /// 构造函数
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.prefixIcon,
    this.suffixIcon,
  });
  
  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;
    
    // 根据大小设置内边距和高度
    EdgeInsetsGeometry padding;
    double height;
    double fontSize;
    double iconSize;
    
    switch (size) {
      case AppButtonSize.small:
        padding = EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h);
        height = 32.h;
        fontSize = 12.sp;
        iconSize = 16.sp;
      case AppButtonSize.medium:
        padding = EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h);
        height = 44.h;
        fontSize = 14.sp;
        iconSize = 18.sp;
      case AppButtonSize.large:
        padding = EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h);
        height = 56.h;
        fontSize = 16.sp;
        iconSize = 20.sp;
    }
    
    // 根据类型设置颜色
    Color backgroundColor;
    Color textColor;
    Color disabledBackgroundColor;
    Color disabledTextColor;
    
    switch (type) {
      case AppButtonType.primary:
        backgroundColor = Theme.of(context).colorScheme.primary;
        textColor = Theme.of(context).colorScheme.onPrimary;
        disabledBackgroundColor = Theme.of(context).disabledColor;
        disabledTextColor = Colors.white70;
      case AppButtonType.secondary:
        backgroundColor = Theme.of(context).colorScheme.secondary;
        textColor = Theme.of(context).colorScheme.onSecondary;
        disabledBackgroundColor = Theme.of(context).disabledColor;
        disabledTextColor = Colors.white70;
      case AppButtonType.text:
        backgroundColor = Colors.transparent;
        textColor = Theme.of(context).colorScheme.primary;
        disabledBackgroundColor = Colors.transparent;
        disabledTextColor = Theme.of(context).disabledColor;
      case AppButtonType.danger:
        backgroundColor = Colors.red;
        textColor = Colors.white;
        disabledBackgroundColor = Theme.of(context).disabledColor;
        disabledTextColor = Colors.white70;
    }
    
    final buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return disabledBackgroundColor;
          }
          return backgroundColor;
        },
      ),
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return disabledTextColor;
          }
          return textColor;
        },
      ),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(padding),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      minimumSize: MaterialStateProperty.all<Size>(
        Size(isFullWidth ? double.infinity : 0, height),
      ),
    );
    
    // 按钮内容
    Widget buttonContent;
    
    if (isLoading) {
      buttonContent = SizedBox(
        height: iconSize,
        width: iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    } else {
      // 创建按钮内容
      final List<Widget> rowChildren = [];
      
      // 添加前缀图标
      if (prefixIcon != null) {
        rowChildren.add(
          Icon(
            prefixIcon,
            size: iconSize,
          ),
        );
        rowChildren.add(SizedBox(width: 8.w));
      }
      
      // 添加文本
      rowChildren.add(
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
      
      // 添加后缀图标
      if (suffixIcon != null) {
        rowChildren.add(SizedBox(width: 8.w));
        rowChildren.add(
          Icon(
            suffixIcon,
            size: iconSize,
          ),
        );
      }
      
      buttonContent = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowChildren,
      );
    }
    
    return type == AppButtonType.text
        ? TextButton(
            onPressed: isDisabled ? null : onPressed,
            style: buttonStyle,
            child: buttonContent,
          )
        : ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: buttonStyle,
            child: buttonContent,
          );
  }
} 