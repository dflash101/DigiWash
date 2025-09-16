import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationStepThreeWidget extends StatefulWidget {
  final Function(Map<String, String>) onStepComplete;
  final Map<String, String> initialData;

  const RegistrationStepThreeWidget({
    Key? key,
    required this.onStepComplete,
    required this.initialData,
  }) : super(key: key);

  @override
  State<RegistrationStepThreeWidget> createState() =>
      _RegistrationStepThreeWidgetState();
}

class _RegistrationStepThreeWidgetState
    extends State<RegistrationStepThreeWidget> {
  final List<String> _selectedServices = [];
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _acceptTerms = false;
  bool _isCreatingAccount = false;

  final List<Map<String, dynamic>> _serviceTypes = [
    {
      'id': 'wash_fold',
      'name': 'Wash & Fold',
      'description': 'Regular laundry washing and folding service',
      'icon': 'local_laundry_service',
    },
    {
      'id': 'dry_clean',
      'name': 'Dry Cleaning',
      'description': 'Professional dry cleaning for delicate items',
      'icon': 'dry_cleaning',
    },
    {
      'id': 'ironing',
      'name': 'Ironing & Pressing',
      'description': 'Professional ironing and pressing service',
      'icon': 'iron',
    },
    {
      'id': 'pickup_delivery',
      'name': 'Pickup & Delivery',
      'description': 'Convenient pickup and delivery service',
      'icon': 'local_shipping',
    },
    {
      'id': 'express',
      'name': 'Express Service',
      'description': 'Same-day or next-day service',
      'icon': 'flash_on',
    },
    {
      'id': 'commercial',
      'name': 'Commercial Laundry',
      'description': 'Bulk laundry for businesses',
      'icon': 'business',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Initialize from previous data if available
    final services = widget.initialData['selectedServices']?.split(',') ?? [];
    _selectedServices.addAll(services.where((s) => s.isNotEmpty));

    _pushNotifications = widget.initialData['pushNotifications'] == 'true';
    _emailNotifications = widget.initialData['emailNotifications'] == 'true';
    _smsNotifications = widget.initialData['smsNotifications'] == 'true';
    _acceptTerms = widget.initialData['acceptTerms'] == 'true';
  }

  void _toggleService(String serviceId) {
    setState(() {
      if (_selectedServices.contains(serviceId)) {
        _selectedServices.remove(serviceId);
      } else {
        _selectedServices.add(serviceId);
      }
    });
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Privacy Policy',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'LaundryLink Privacy Policy',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'We collect and use your personal information to provide laundry services, including:',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                SizedBox(height: 1.h),
                Text(
                  '• Contact information for service coordination\n'
                  '• Location data for pickup and delivery\n'
                  '• Payment information for transactions\n'
                  '• Service preferences for better experience',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Your data is encrypted and never shared with third parties without your consent.',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Terms of Service',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'LaundryLink Terms of Service',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'By using LaundryLink, you agree to:',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                SizedBox(height: 1.h),
                Text(
                  '• Provide accurate information for service delivery\n'
                  '• Pay for services as agreed\n'
                  '• Follow pickup and delivery guidelines\n'
                  '• Respect service providers and their policies',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Service providers are independent contractors. LaundryLink facilitates connections but is not responsible for service quality.',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleCreateAccount() async {
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Please accept the Terms of Service and Privacy Policy to continue'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
      return;
    }

    if (_selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least one service type'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
      return;
    }

    setState(() {
      _isCreatingAccount = true;
    });

    // Simulate account creation
    await Future.delayed(const Duration(seconds: 2));

    final stepData = {
      'selectedServices': _selectedServices.join(','),
      'pushNotifications': _pushNotifications.toString(),
      'emailNotifications': _emailNotifications.toString(),
      'smsNotifications': _smsNotifications.toString(),
      'acceptTerms': _acceptTerms.toString(),
    };

    setState(() {
      _isCreatingAccount = false;
    });

    widget.onStepComplete(stepData);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Almost Done!',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Set your preferences to personalize your experience',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 4.h),

        // Service Types Section
        Text(
          'Services You\'re Interested In',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 1.2,
          ),
          itemCount: _serviceTypes.length,
          itemBuilder: (context, index) {
            final service = _serviceTypes[index];
            final isSelected = _selectedServices.contains(service['id']);

            return GestureDetector(
              onTap: () => _toggleService(service['id']),
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primaryContainer
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.5),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: service['icon'],
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 6.w,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      service['name'],
                      textAlign: TextAlign.center,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.onPrimaryContainer
                            : AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      service['description'],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.onPrimaryContainer
                                .withValues(alpha: 0.8)
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(height: 4.h),

        // Notification Preferences Section
        Text(
          'Notification Preferences',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),

        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            children: [
              // Push Notifications
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'notifications',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Push Notifications',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Order updates and delivery notifications',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _pushNotifications,
                    onChanged: (value) {
                      setState(() {
                        _pushNotifications = value;
                      });
                    },
                  ),
                ],
              ),
              Divider(height: 3.h),

              // Email Notifications
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'email',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email Notifications',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Receipts and promotional offers',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _emailNotifications,
                    onChanged: (value) {
                      setState(() {
                        _emailNotifications = value;
                      });
                    },
                  ),
                ],
              ),
              Divider(height: 3.h),

              // SMS Notifications
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'sms',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SMS Notifications',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Important delivery updates via text',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _smsNotifications,
                    onChanged: (value) {
                      setState(() {
                        _smsNotifications = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),

        // Terms and Privacy Section
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _acceptTerms,
                onChanged: (value) {
                  setState(() {
                    _acceptTerms = value ?? false;
                  });
                },
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(text: 'I agree to the '),
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _showTermsOfService,
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _showPrivacyPolicy,
                      ),
                      const TextSpan(
                          text:
                              '. I understand that LaundryLink connects me with independent laundry service providers.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),

        // Create Account Button
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton(
            onPressed: _isCreatingAccount ? null : _handleCreateAccount,
            child: _isCreatingAccount
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 4.w,
                        height: 4.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Creating Account...',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Text(
                    'Create Account',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
