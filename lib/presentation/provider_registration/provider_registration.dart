import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/business_info_step.dart';
import './widgets/completion_screen.dart';
import './widgets/document_verification_step.dart';
import './widgets/registration_progress_indicator.dart';
import './widgets/service_area_step.dart';
import './widgets/service_offerings_step.dart';

class ProviderRegistration extends StatefulWidget {
  const ProviderRegistration({Key? key}) : super(key: key);

  @override
  State<ProviderRegistration> createState() => _ProviderRegistrationState();
}

class _ProviderRegistrationState extends State<ProviderRegistration> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  final List<String> _stepTitles = [
    'Business Info',
    'Documents',
    'Services',
    'Service Area',
  ];

  // Form data storage
  Map<String, dynamic> _registrationData = {
    'businessInfo': <String, String>{},
    'documents': <String, dynamic>{},
    'services': <String, dynamic>{},
    'serviceArea': <String, dynamic>{},
  };

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _updateStepData(String stepKey, Map<String, dynamic> data) {
    setState(() {
      _registrationData[stepKey] = data;
    });
  }

  bool _isStepValid(int step) {
    switch (step) {
      case 0:
        final businessInfo =
            _registrationData['businessInfo'] as Map<String, String>;
        return businessInfo['businessName']?.isNotEmpty == true &&
            businessInfo['ownerName']?.isNotEmpty == true &&
            businessInfo['email']?.isNotEmpty == true &&
            businessInfo['phone']?.isNotEmpty == true &&
            businessInfo['password']?.isNotEmpty == true &&
            businessInfo['confirmPassword'] == businessInfo['password'];
      case 1:
        final documents =
            _registrationData['documents'] as Map<String, dynamic>;
        return documents['businessLicense'] != null &&
            documents['taxId'] != null;
      case 2:
        final services = _registrationData['services'] as Map<String, dynamic>;
        final selectedServices =
            services['selectedServices'] as Map<String, bool>? ?? {};
        return selectedServices.values.any((selected) => selected);
      case 3:
        final serviceArea =
            _registrationData['serviceArea'] as Map<String, dynamic>;
        return serviceArea['address']?.toString().isNotEmpty == true &&
            (serviceArea['radius'] as double? ?? 0) > 0;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (!_isStepValid(_currentStep)) {
      _showErrorMessage(
          'Please complete all required fields before continuing.');
      return;
    }

    if (_currentStep < _stepTitles.length - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitRegistration();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitRegistration() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // Navigate to completion screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            body: SafeArea(
              child: CompletionScreen(
                onContinue: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login-screen',
                    (route) => false,
                  );
                },
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      _showErrorMessage('Registration failed. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Provider Registration'),
        leading: _currentStep > 0
            ? IconButton(
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
                onPressed: _previousStep,
              )
            : IconButton(
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
                onPressed: () => Navigator.pop(context),
              ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login-screen',
                (route) => false,
              );
            },
            child: Text('Login'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Indicator
          RegistrationProgressIndicator(
            currentStep: _currentStep,
            totalSteps: _stepTitles.length,
            stepTitles: _stepTitles,
          ),

          // Step Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                // Step 1: Business Information
                SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: BusinessInfoStep(
                    initialData: _registrationData['businessInfo']
                        as Map<String, String>,
                    onDataChanged: (data) =>
                        _updateStepData('businessInfo', data),
                  ),
                ),

                // Step 2: Document Verification
                SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: DocumentVerificationStep(
                    initialData:
                        _registrationData['documents'] as Map<String, dynamic>,
                    onDataChanged: (data) => _updateStepData('documents', data),
                  ),
                ),

                // Step 3: Service Offerings
                SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: ServiceOfferingsStep(
                    initialData:
                        _registrationData['services'] as Map<String, dynamic>,
                    onDataChanged: (data) => _updateStepData('services', data),
                  ),
                ),

                // Step 4: Service Area
                SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: ServiceAreaStep(
                    initialData: _registrationData['serviceArea']
                        as Map<String, dynamic>,
                    onDataChanged: (data) =>
                        _updateStepData('serviceArea', data),
                  ),
                ),
              ],
            ),
          ),

          // Navigation Buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        child: Text('Previous'),
                      ),
                    ),
                  if (_currentStep > 0) SizedBox(width: 4.w),
                  Expanded(
                    flex: _currentStep > 0 ? 1 : 1,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _nextStep,
                      child: _isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : Text(_currentStep < _stepTitles.length - 1
                              ? 'Next'
                              : 'Submit'),
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
