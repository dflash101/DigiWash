import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationProgressWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const RegistrationProgressWidget({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        children: [
          // Step Indicators
          Row(
            children: List.generate(totalSteps, (index) {
              final stepNumber = index + 1;
              final isCompleted = stepNumber < currentStep;
              final isCurrent = stepNumber == currentStep;

              return Expanded(
                child: Row(
                  children: [
                    // Step Circle
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted || isCurrent
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                        border: Border.all(
                          color: isCompleted || isCurrent
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: isCompleted
                            ? CustomIconWidget(
                                iconName: 'check',
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                size: 4.w,
                              )
                            : Text(
                                stepNumber.toString(),
                                style: AppTheme.lightTheme.textTheme.labelMedium
                                    ?.copyWith(
                                  color: isCurrent
                                      ? AppTheme
                                          .lightTheme.colorScheme.onPrimary
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    // Connecting Line (except for last step)
                    if (index < totalSteps - 1) ...[
                      Expanded(
                        child: Container(
                          height: 2,
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ),
          SizedBox(height: 2.h),

          // Step Labels
          Row(
            children: [
              Expanded(
                child: Text(
                  'Personal Info',
                  textAlign: TextAlign.center,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: currentStep >= 1
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight:
                        currentStep == 1 ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Location',
                  textAlign: TextAlign.center,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: currentStep >= 2
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight:
                        currentStep == 2 ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Preferences',
                  textAlign: TextAlign.center,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: currentStep >= 3
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight:
                        currentStep == 3 ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Progress Bar
          Container(
            width: double.infinity,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: currentStep / totalSteps,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          SizedBox(height: 1.h),

          // Progress Text
          Text(
            'Step $currentStep of $totalSteps',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
