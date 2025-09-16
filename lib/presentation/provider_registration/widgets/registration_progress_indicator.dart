import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepTitles;

  const RegistrationProgressIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Step Counter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${currentStep + 1} of $totalSteps',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              Text(
                '${((currentStep + 1) / totalSteps * 100).toInt()}%',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Progress Bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (currentStep + 1) / totalSteps,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Step Indicators
          Row(
            children: List.generate(totalSteps, (index) {
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;
              final isUpcoming = index > currentStep;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          // Step Circle
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : isCurrent
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : AppTheme.lightTheme.colorScheme.outline
                                          .withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                              border: isCurrent
                                  ? Border.all(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      width: 2,
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: isCompleted
                                  ? CustomIconWidget(
                                      iconName: 'check',
                                      color: AppTheme
                                          .lightTheme.colorScheme.onPrimary,
                                      size: 16,
                                    )
                                  : Text(
                                      '${index + 1}',
                                      style: AppTheme
                                          .lightTheme.textTheme.labelMedium
                                          ?.copyWith(
                                        color: isCurrent
                                            ? AppTheme.lightTheme.colorScheme
                                                .onPrimary
                                            : isUpcoming
                                                ? AppTheme
                                                    .lightTheme
                                                    .colorScheme
                                                    .onSurfaceVariant
                                                : AppTheme.lightTheme
                                                    .colorScheme.onPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 1.h),

                          // Step Title
                          Text(
                            stepTitles[index],
                            textAlign: TextAlign.center,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: isCurrent
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : isCompleted
                                      ? AppTheme
                                          .lightTheme.colorScheme.onSurface
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                              fontWeight:
                                  isCurrent ? FontWeight.w600 : FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Connector Line (except for last step)
                    if (index < totalSteps - 1)
                      Container(
                        width: 4.w,
                        height: 2,
                        color: index < currentStep
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
