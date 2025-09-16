import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/provider_registration/provider_registration.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/role_selection_screen/role_selection_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/customer_registration/customer_registration.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String providerRegistration = '/provider-registration';
  static const String login = '/login-screen';
  static const String roleSelection = '/role-selection-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String customerRegistration = '/customer-registration';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    providerRegistration: (context) => const ProviderRegistration(),
    login: (context) => const LoginScreen(),
    roleSelection: (context) => const RoleSelectionScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    customerRegistration: (context) => const CustomerRegistration(),
    // TODO: Add your other routes here
  };
}
