import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _backgroundFadeAnimation;

  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Fade animation controller
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeInOut,
    ));

    // Background fade animation
    _backgroundFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeIn,
    ));

    // Start animations
    _fadeAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _logoAnimationController.forward();
      }
    });
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate app initialization tasks
      await Future.wait([
        _checkAuthenticationStatus(),
        _loadUserPreferences(),
        _fetchNearbyProviders(),
        _prepareCachedData(),
      ]);

      setState(() {
        _isInitialized = true;
      });

      // Wait for animations to complete
      await Future.delayed(const Duration(milliseconds: 2500));

      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to initialize app. Please try again.';
      });

      // Retry after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && _hasError) {
          _retryInitialization();
        }
      });
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    // Simulate checking authentication
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<void> _loadUserPreferences() async {
    // Simulate loading user preferences
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> _fetchNearbyProviders() async {
    // Simulate fetching nearby laundry providers
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  Future<void> _prepareCachedData() async {
    // Simulate preparing cached service data
    await Future.delayed(const Duration(milliseconds: 700));
  }

  void _navigateToNextScreen() {
    // Navigation logic based on user status
    // For demo purposes, navigate to onboarding flow
    Navigator.pushReplacementNamed(context, '/onboarding-flow');
  }

  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
      _isInitialized = false;
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.colorScheme.primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundFadeAnimation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: _backgroundFadeAnimation.value),
                  AppTheme.lightTheme.colorScheme.surface
                      .withValues(alpha: _backgroundFadeAnimation.value),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Spacer to push content to center
                  const Spacer(flex: 2),

                  // Logo section
                  AnimatedBuilder(
                    animation: _logoAnimationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Opacity(
                          opacity: _logoFadeAnimation.value,
                          child: _buildLogo(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 4.h),

                  // App name
                  AnimatedBuilder(
                    animation: _logoFadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _logoFadeAnimation.value,
                        child: Text(
                          'LaundryLink',
                          style: AppTheme.lightTheme.textTheme.headlineLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 1.h),

                  // Tagline
                  AnimatedBuilder(
                    animation: _logoFadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _logoFadeAnimation.value * 0.8,
                        child: Text(
                          'Your Laundry, Our Priority',
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(flex: 1),

                  // Loading indicator or error message
                  _buildBottomSection(),

                  SizedBox(height: 8.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 25.w,
      height: 25.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'local_laundry_service',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 12.w,
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    if (_hasError) {
      return Column(
        children: [
          CustomIconWidget(
            iconName: 'error_outline',
            color: AppTheme.lightTheme.colorScheme.error,
            size: 6.w,
          ),
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          ElevatedButton(
            onPressed: _retryInitialization,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
            ),
            child: Text(
              'Retry',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        SizedBox(
          width: 6.w,
          height: 6.w,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          _isInitialized ? 'Ready to go!' : 'Initializing...',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
