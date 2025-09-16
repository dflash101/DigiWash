import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationSuccessWidget extends StatefulWidget {
  final VoidCallback onStartUsingApp;

  const RegistrationSuccessWidget({
    Key? key,
    required this.onStartUsingApp,
  }) : super(key: key);

  @override
  State<RegistrationSuccessWidget> createState() =>
      _RegistrationSuccessWidgetState();
}

class _RegistrationSuccessWidgetState extends State<RegistrationSuccessWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success Icon Animation
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 25.w,
                height: 25.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'check',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 12.w,
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.h),

            // Success Message
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  Text(
                    'Welcome to LaundryLink!',
                    textAlign: TextAlign.center,
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Your account has been created successfully. You\'re now ready to discover amazing laundry services in your area.',
                    textAlign: TextAlign.center,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Feature Highlights
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primaryContainer
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'What\'s Next?',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // Feature List
                        _buildFeatureItem(
                          icon: 'search',
                          title: 'Find Services',
                          description: 'Browse local laundry providers',
                        ),
                        SizedBox(height: 2.h),
                        _buildFeatureItem(
                          icon: 'schedule',
                          title: 'Schedule Pickup',
                          description: 'Book convenient pickup times',
                        ),
                        SizedBox(height: 2.h),
                        _buildFeatureItem(
                          icon: 'track_changes',
                          title: 'Track Orders',
                          description: 'Monitor your laundry in real-time',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Email Verification Notice
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme
                          .lightTheme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'email',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 5.w,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Verify Your Email',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Check your inbox for a verification email to complete your account setup.',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Start Using App Button
                  SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton.icon(
                      onPressed: widget.onStartUsingApp,
                      icon: CustomIconWidget(
                        iconName: 'arrow_forward',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 5.w,
                      ),
                      label: Text(
                        'Start Using LaundryLink',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Secondary Action
                  TextButton(
                    onPressed: () {
                      // Navigate to login or explore features
                      Navigator.pushReplacementNamed(context, '/login-screen');
                    },
                    child: Text(
                      'I\'ll set this up later',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required String icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 5.w,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              Text(
                description,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
