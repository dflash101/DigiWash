import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  // Mock data for onboarding screens
  final List<Map<String, dynamic>> onboardingData = [
    {
      "imageUrl":
          "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y2FsZW5kYXJ8ZW58MHx8MHx8fDA%3D",
      "title": "Schedule Pickup",
      "description":
          "Book your laundry pickup at your convenience. Choose your preferred time slot and we'll be there right on schedule.",
    },
    {
      "imageUrl":
          "https://images.unsplash.com/photo-1551288049-bebda4e38f71?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8bWFwfGVufDB8fDB8fHww",
      "title": "Track Your Order",
      "description":
          "Stay updated with real-time tracking. Know exactly where your laundry is and when it will be delivered back to you.",
    },
    {
      "imageUrl":
          "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZGVsaXZlcnl8ZW58MHx8MHx8fDA%3D",
      "title": "Doorstep Delivery",
      "description":
          "Get your fresh, clean laundry delivered right to your doorstep. Quality service you can trust, every time.",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    // Haptic feedback for iOS
    HapticFeedback.lightImpact();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToRoleSelection();
    }
  }

  void _skipOnboarding() {
    _navigateToRoleSelection();
  }

  void _navigateToRoleSelection() {
    Navigator.pushReplacementNamed(context, '/role-selection-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Skip button in top-right corner
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _skipOnboarding,
                    style: TextButton.styleFrom(
                      foregroundColor:
                          AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    ),
                    child: Text(
                      'Skip',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // PageView with onboarding screens
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _totalPages,
              itemBuilder: (context, index) {
                final data = onboardingData[index];
                return OnboardingPageWidget(
                  imageUrl: data["imageUrl"] as String,
                  title: data["title"] as String,
                  description: data["description"] as String,
                );
              },
            ),
          ),
          // Bottom section with page indicators and next button
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              child: Column(
                children: [
                  // Page indicators
                  PageIndicatorWidget(
                    currentPage: _currentPage,
                    totalPages: _totalPages,
                  ),
                  SizedBox(height: 4.h),
                  // Next/Get Started button
                  SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                        foregroundColor:
                            AppTheme.lightTheme.colorScheme.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                      ),
                      child: Text(
                        _currentPage == _totalPages - 1
                            ? 'Get Started'
                            : 'Next',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
