import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginButton extends StatelessWidget {
  final String iconName;
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const SocialLoginButton({
    Key? key,
    required this.iconName,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 6.h,
      margin: EdgeInsets.symmetric(vertical: 0.5.h),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              backgroundColor ?? AppTheme.lightTheme.colorScheme.surface,
          foregroundColor:
              textColor ?? AppTheme.lightTheme.colorScheme.onSurface,
          elevation: 0,
          side: BorderSide(
            color: AppTheme.getBorderColor(true),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: textColor ?? AppTheme.lightTheme.colorScheme.onSurface,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: textColor ?? AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
