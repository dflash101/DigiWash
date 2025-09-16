import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/registration_progress_widget.dart';
import './widgets/registration_step_one_widget.dart';
import './widgets/registration_step_three_widget.dart';
import './widgets/registration_step_two_widget.dart';
import './widgets/registration_success_widget.dart';

class CustomerRegistration extends StatefulWidget {
  const CustomerRegistration({Key? key}) : super(key: key);

  @override
  State<CustomerRegistration> createState() => _CustomerRegistrationState();
}

class _CustomerRegistrationState extends State<CustomerRegistration> {
  final PageController _pageController = PageController();
  int _currentStep = 1;
  final int _totalSteps = 3;
  bool _isRegistrationComplete = false;

  // Store registration data across steps
  final Map<String, String> _registrationData = {};

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleStepComplete(Map<String, String> stepData) {
    setState(() {
      _registrationData.addAll(stepData);
    });

    if (_currentStep < _totalSteps) {
      _nextStep();
    } else {
      _completeRegistration();
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeRegistration() {
    setState(() {
      _isRegistrationComplete = true;
    });
  }

  void _handleStartUsingApp() {
    // Navigate to main app or dashboard
    Navigator.pushReplacementNamed(context, '/splash-screen');
  }

  void _handleBackPressed() {
    if (_isRegistrationComplete) {
      setState(() {
        _isRegistrationComplete = false;
        _currentStep = _totalSteps;
      });
    } else if (_currentStep > 1) {
      _previousStep();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                children: [
                  if (!_isRegistrationComplete) ...[
                    GestureDetector(
                      onTap: _handleBackPressed,
                      child: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.lightTheme.colorScheme.surface,
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.5),
                          ),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: 'arrow_back',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 5.w,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                  ],
                  Expanded(
                    child: Text(
                      _isRegistrationComplete ? 'Welcome!' : 'Create Account',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  if (!_isRegistrationComplete) ...[
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/login-screen');
                      },
                      child: Text(
                        'Sign In',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Progress Indicator (only show during registration steps)
            if (!_isRegistrationComplete) ...[
              RegistrationProgressWidget(
                currentStep: _currentStep,
                totalSteps: _totalSteps,
              ),
            ],

            // Content
            Expanded(
              child: _isRegistrationComplete
                  ? RegistrationSuccessWidget(
                      onStartUsingApp: _handleStartUsingApp,
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          // Step 1: Personal Information
                          SingleChildScrollView(
                            child: RegistrationStepOneWidget(
                              onStepComplete: _handleStepComplete,
                              initialData: _registrationData,
                            ),
                          ),

                          // Step 2: Location
                          SingleChildScrollView(
                            child: RegistrationStepTwoWidget(
                              onStepComplete: _handleStepComplete,
                              initialData: _registrationData,
                            ),
                          ),

                          // Step 3: Preferences
                          SingleChildScrollView(
                            child: RegistrationStepThreeWidget(
                              onStepComplete: _handleStepComplete,
                              initialData: _registrationData,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            // Footer (only show during registration steps)
            if (!_isRegistrationComplete) ...[
              Container(
                padding: EdgeInsets.all(6.w),
                child: Column(
                  children: [
                    // Social Registration Options (only on first step)
                    if (_currentStep == 1) ...[
                      Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Text(
                              'OR',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Handle Google sign up
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Google sign up coming soon!'),
                                  ),
                                );
                              },
                              icon: CustomIconWidget(
                                iconName: 'g_translate',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 5.w,
                              ),
                              label: Text('Google'),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Handle Apple sign up
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Apple sign up coming soon!'),
                                  ),
                                );
                              },
                              icon: CustomIconWidget(
                                iconName: 'apple',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 5.w,
                              ),
                              label: Text('Apple'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                    ],

                    // Already have account link
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        children: [
                          const TextSpan(text: 'Already have an account? '),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, '/login-screen');
                              },
                              child: Text(
                                'Sign In',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
