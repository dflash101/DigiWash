import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationStepOneWidget extends StatefulWidget {
  final Function(Map<String, String>) onStepComplete;
  final Map<String, String> initialData;

  const RegistrationStepOneWidget({
    Key? key,
    required this.onStepComplete,
    required this.initialData,
  }) : super(key: key);

  @override
  State<RegistrationStepOneWidget> createState() =>
      _RegistrationStepOneWidgetState();
}

class _RegistrationStepOneWidgetState extends State<RegistrationStepOneWidget> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedCountryCode = '+1';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = AppTheme.lightTheme.colorScheme.error;

  @override
  void initState() {
    super.initState();
    _fullNameController.text = widget.initialData['fullName'] ?? '';
    _emailController.text = widget.initialData['email'] ?? '';
    _phoneController.text = widget.initialData['phone'] ?? '';
    _passwordController.text = widget.initialData['password'] ?? '';
    _selectedCountryCode = widget.initialData['countryCode'] ?? '+1';

    _passwordController.addListener(_checkPasswordStrength);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength() {
    final password = _passwordController.text;
    double strength = 0.0;
    String strengthText = '';
    Color strengthColor = AppTheme.lightTheme.colorScheme.error;

    if (password.isEmpty) {
      strength = 0.0;
      strengthText = '';
    } else if (password.length < 6) {
      strength = 0.25;
      strengthText = 'Weak';
      strengthColor = AppTheme.lightTheme.colorScheme.error;
    } else if (password.length < 8) {
      strength = 0.5;
      strengthText = 'Fair';
      strengthColor = Colors.orange;
    } else if (password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]'))) {
      strength = 0.75;
      strengthText = 'Good';
      strengthColor = Colors.blue;
    } else if (password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      strength = 1.0;
      strengthText = 'Strong';
      strengthColor = AppTheme.lightTheme.colorScheme.primary;
    } else {
      strength = 0.5;
      strengthText = 'Fair';
      strengthColor = Colors.orange;
    }

    setState(() {
      _passwordStrength = strength;
      _passwordStrengthText = strengthText;
      _passwordStrengthColor = strengthColor;
    });
  }

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Full name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Full name can only contain letters and spaces';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^[0-9]{10,15}$')
        .hasMatch(value.trim().replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _handleNext() {
    if (_formKey.currentState?.validate() ?? false) {
      final stepData = {
        'fullName': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'countryCode': _selectedCountryCode,
        'password': _passwordController.text,
      };
      widget.onStepComplete(stepData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create Your Account',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Enter your personal information to get started',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 4.h),

          // Full Name Field
          TextFormField(
            controller: _fullNameController,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
            ),
            validator: _validateFullName,
          ),
          SizedBox(height: 3.h),

          // Email Field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email address',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'email',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
            ),
            validator: _validateEmail,
          ),
          SizedBox(height: 3.h),

          // Phone Number Field with Country Code
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CountryCodePicker(
                  onChanged: (countryCode) {
                    setState(() {
                      _selectedCountryCode = countryCode.dialCode ?? '+1';
                    });
                  },
                  initialSelection: 'US',
                  favorite: const ['+1', 'US'],
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'phone',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
                    ),
                  ),
                  validator: _validatePhone,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Password Field
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Create a secure password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                icon: CustomIconWidget(
                  iconName:
                      _isPasswordVisible ? 'visibility_off' : 'visibility',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
            ),
            validator: _validatePassword,
          ),

          // Password Strength Indicator
          if (_passwordController.text.isNotEmpty) ...[
            SizedBox(height: 1.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: _passwordStrength,
                        backgroundColor: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            _passwordStrengthColor),
                        minHeight: 0.5.h,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _passwordStrengthText,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: _passwordStrengthColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
          SizedBox(height: 3.h),

          // Confirm Password Field
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: !_isConfirmPasswordVisible,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              hintText: 'Re-enter your password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
                icon: CustomIconWidget(
                  iconName: _isConfirmPasswordVisible
                      ? 'visibility_off'
                      : 'visibility',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
            ),
            validator: _validateConfirmPassword,
          ),
          SizedBox(height: 4.h),

          // Next Button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: _handleNext,
              child: Text(
                'Next',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
