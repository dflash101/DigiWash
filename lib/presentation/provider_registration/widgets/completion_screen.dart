import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CompletionScreen extends StatelessWidget {
  final VoidCallback onContinue;

  const CompletionScreen({
    Key? key,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Animation Container
                Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color:
                        AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: AppTheme.getSuccessColor(true),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'check',
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),

                // Success Title
                Text(
                  'Registration Submitted!',
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),

                // Success Message
                Text(
                  'Thank you for joining LaundryLink! Your application has been submitted for review.',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),

                // Review Process Info
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'Review Process',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      _buildTimelineItem(
                        'Document Verification',
                        '24-48 hours',
                        'We\'ll verify your business documents',
                        true,
                      ),
                      _buildTimelineItem(
                        'Background Check',
                        '2-3 business days',
                        'Standard background verification process',
                        false,
                      ),
                      _buildTimelineItem(
                        'Account Activation',
                        '1 business day',
                        'Your provider account will be activated',
                        false,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),

                // What's Next Section
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What happens next?',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      _buildNextStep('📧', 'Check your email for updates'),
                      _buildNextStep('📱', 'Complete your provider profile'),
                      _buildNextStep(
                          '🚀', 'Start receiving orders once approved'),
                      _buildNextStep('💰', 'Begin earning with LaundryLink'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onContinue,
                  child: Text('Continue to Dashboard'),
                ),
              ),
              SizedBox(height: 2.h),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login-screen',
                    (route) => false,
                  );
                },
                child: Text('Back to Login'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
      String title, String duration, String description, bool isFirst) {
    return Padding(
      padding: EdgeInsets.only(bottom: isFirst ? 2.h : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isFirst
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isFirst)
                Container(
                  width: 2,
                  height: 4.h,
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
            ],
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isFirst
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      duration,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (!isFirst) SizedBox(height: 2.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStep(String emoji, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          Text(
            emoji,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
