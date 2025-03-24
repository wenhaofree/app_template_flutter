import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 应用输入框
class AppTextField extends StatefulWidget {
  /// 控制器
  final TextEditingController? controller;
  
  /// 焦点节点
  final FocusNode? focusNode;
  
  /// 标签文本
  final String? label;
  
  /// 提示文本
  final String? hint;
  
  /// 错误文本
  final String? errorText;
  
  /// 帮助文本
  final String? helperText;
  
  /// 前缀图标
  final IconData? prefixIcon;
  
  /// 后缀图标
  final IconData? suffixIcon;
  
  /// 后缀图标点击事件
  final VoidCallback? onSuffixIconPressed;
  
  /// 是否是密码输入框
  final bool isPassword;
  
  /// 是否只读
  final bool readOnly;
  
  /// 是否启用
  final bool enabled;
  
  /// 是否必填
  final bool isRequired;
  
  /// 文本输入类型
  final TextInputType? keyboardType;
  
  /// 值变化回调
  final ValueChanged<String>? onChanged;
  
  /// 提交回调
  final ValueChanged<String>? onSubmitted;
  
  /// 输入格式化器
  final List<TextInputFormatter>? inputFormatters;
  
  /// 最大行数
  final int? maxLines;
  
  /// 最小行数
  final int? minLines;
  
  /// 最大长度
  final int? maxLength;
  
  /// 自动校正
  final bool autocorrect;
  
  /// 自动填充提示
  final Iterable<String>? autofillHints;
  
  /// 文本对齐方式
  final TextAlign textAlign;
  
  /// 自动获取焦点
  final bool autofocus;
  
  /// 点击回调
  final VoidCallback? onTap;
  
  /// 构造函数
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.isPassword = false,
    this.readOnly = false,
    this.enabled = true,
    this.isRequired = false,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autocorrect = true,
    this.autofillHints,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.onTap,
  });
  
  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  
  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }
  
  @override
  Widget build(BuildContext context) {
    // 构建标签文本
    String? labelText = widget.label;
    if (widget.isRequired && widget.label != null) {
      labelText = '${widget.label} *';
    }
    
    // 构建后缀图标
    Widget? suffixIcon;
    if (widget.isPassword) {
      suffixIcon = IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: 20.sp,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    } else if (widget.suffixIcon != null) {
      suffixIcon = IconButton(
        icon: Icon(
          widget.suffixIcon,
          size: 20.sp,
        ),
        onPressed: widget.onSuffixIconPressed,
      );
    }
    
    // 构建前缀图标
    Widget? prefixIcon;
    if (widget.prefixIcon != null) {
      prefixIcon = Icon(
        widget.prefixIcon,
        size: 20.sp,
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            labelText!,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 8.h),
        ],
        TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          obscureText: _obscureText,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          inputFormatters: widget.inputFormatters,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          autocorrect: widget.autocorrect,
          autofillHints: widget.autofillHints,
          textAlign: widget.textAlign,
          autofocus: widget.autofocus,
          onTap: widget.onTap,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            helperText: widget.helperText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Theme.of(context).dividerColor.withOpacity(0.5),
              ),
            ),
            filled: true,
            fillColor: widget.enabled
                ? Theme.of(context).cardColor
                : Theme.of(context).disabledColor.withOpacity(0.1),
          ),
        ),
      ],
    );
  }
} 