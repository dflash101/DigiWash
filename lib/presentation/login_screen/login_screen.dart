import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/loading_button.dart';
import './widgets/login_form_field.dart';
import './widgets/password_visibility_toggle.dart';
import './widgets/social_login_button.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;
  bool _isFormValid = false;

  // Mock credentials for testing
  final Map<String, String> _mockCredentials = {
    'customer@laundrylink.com': 'customer123',
    'provider@laundrylink.com': 'provider123',
    'admin@laundrylink.com': 'admin123',
  };

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _emailError = _validateEmail(_emailController.text);
      _passwordError = _validatePassword(_passwordController.text);
      _isFormValid = _emailError == null &&
          _passwordError == null &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) return null;

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return null;

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

 Future<void> _handleLogin() async {
  if (!_isFormValid) return;

  setState(() {
    _isLoading = true;
  });

  // Simulate network delay
  await Future.delayed(const Duration(seconds: 2));

  final email = _emailController.text.trim();
  final password = _passwordController.text;

  // Check mock credentials
  if (_mockCredentials.containsKey(email) &&
      _mockCredentials[email] == password) {
    // Success - trigger haptic feedback
    HapticFeedback.lightImpact();

    // Navigate based on user role
    if (email.contains('customer')) {
      _showSuccessMessage('Welcome back, Customer!');

      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.customerHome, // '/customer-home' also works
          (route) => false,       // clears back stack
        );
      }
    } else if (email.contains('provider')) {
      _showSuccessMessage('Welcome back, Service Provider!');
      // TODO: Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.providerHome, (r) => false);
    } else if (email.contains('admin')) {
      _showSuccessMessage('Welcome back, Admin!');
      // TODO: Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.adminHome, (r) => false);
    }
  } else {
    // Show error message
    _showErrorMessage('Invalid email or password. Please try again.');
  }

  setState(() {
    _isLoading = false;
  });
}

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.getSuccessColor(true),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _handleSocialLogin(String provider) {
    _showSuccessMessage('$provider login will be implemented soon');
  }

  void _handleForgotPassword() {
    _showSuccessMessage('Password reset link will be sent to your email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 8.h),

                // App Logo
                Container(
                  width: 25.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'local_laundry_service',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 12.w,
                    ),
                  ),
                ),

                SizedBox(height: 3.h),

                // Welcome Text
                Text(
                  'Welcome Back',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),

                SizedBox(height: 1.h),

                Text(
                  'Sign in to your DigiWash account',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),

                SizedBox(height: 4.h),

                // Login Form
                Column(
                  children: [
                    // Email Field
                    LoginFormField(
                      label: 'Email Address',
                      hintText: 'Enter your email',
                      iconName: 'email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      errorText: _emailError,
                      onChanged: (value) => _validateForm(),
                    ),

                    SizedBox(height: 3.h),

                    // Password Field
                    LoginFormField(
                      label: 'Password',
                      hintText: 'Enter your password',
                      iconName: 'lock',
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      errorText: _passwordError,
                      onChanged: (value) => _validateForm(),
                      suffixIcon: PasswordVisibilityToggle(
                        isVisible: _isPasswordVisible,
                        onToggle: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Forgot Password Link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _handleForgotPassword,
                        child: Text(
                          'Forgot Password?',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Login Button
                    LoadingButton(
                      text: 'Login',
                      isLoading: _isLoading,
                      isEnabled: _isFormValid,
                      onPressed: _handleLogin,
                    ),

                    SizedBox(height: 4.h),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: AppTheme.getBorderColor(true),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(
                            'Or continue with',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: AppTheme.getBorderColor(true),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Social Login Buttons
                    SocialLoginButton(
                      iconName: 'g_translate',
                      label: 'Continue with Google',
                      onPressed: () => _handleSocialLogin('Google'),
                    ),

                    SocialLoginButton(
                      iconName: 'apple',
                      label: 'Continue with Apple',
                      onPressed: () => _handleSocialLogin('Apple'),
                    ),

                    SocialLoginButton(
                      iconName: 'facebook',
                      label: 'Continue with Facebook',
                      onPressed: () => _handleSocialLogin('Facebook'),
                    ),

                    SizedBox(height: 4.h),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'New user? ',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/role-selection-screen');
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Sign Up',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
