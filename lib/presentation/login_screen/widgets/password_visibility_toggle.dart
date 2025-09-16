import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PasswordVisibilityToggle extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onToggle;

  const PasswordVisibilityToggle({
    Key? key,
    required this.isVisible,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onToggle,
      icon: CustomIconWidget(
        iconName: isVisible ? 'visibility_off' : 'visibility',
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 5.w,
      ),
      splashRadius: 6.w,
    );
  }
}
