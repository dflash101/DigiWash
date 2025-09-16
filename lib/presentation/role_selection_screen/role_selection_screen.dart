import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/role_card_widget.dart';
import './widgets/role_info_bottom_sheet.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                SizedBox(height: 4.h),
                _buildHeader(),
                SizedBox(height: 6.h),
                _buildRoleCards(context),
                SizedBox(height: 4.h),
                _buildSignInLink(context),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'local_laundry_service',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 10.w,
            ),
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          'LaundryLink',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 24.sp,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Your Laundry, Delivered',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleCards(BuildContext context) {
    return Column(
      children: [
        RoleCardWidget(
          title: 'I Need Laundry Service',
          description:
              'Schedule pickup and delivery for your laundry. Track orders in real-time and enjoy professional cleaning services.',
          iconName: 'shopping_basket',
          onTap: () => _handleRoleSelection(context, 'customer'),
          onLearnMore: () => _showCustomerInfo(context),
        ),
        SizedBox(height: 6.w),
        RoleCardWidget(
          title: 'I Provide Laundry Service',
          description:
              'Join our network of service providers. Manage orders, set your rates, and grow your laundry business.',
          iconName: 'local_laundry_service',
          onTap: () => _handleRoleSelection(context, 'provider'),
          onLearnMore: () => _showProviderInfo(context),
        ),
      ],
    );
  }

  Widget _buildSignInLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontSize: 13.sp,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/login-screen'),
          child: Text(
            'Sign In',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
        ),
      ],
    );
  }

  void _handleRoleSelection(BuildContext context, String role) {
    HapticFeedback.lightImpact();

    if (role == 'customer') {
      Navigator.pushNamed(context, '/customer-registration');
    } else if (role == 'provider') {
      Navigator.pushNamed(context, '/provider-registration');
    }
  }

  void _showCustomerInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RoleInfoBottomSheet(
        title: 'Customer Benefits',
        iconName: 'shopping_basket',
        benefits: [
          'Schedule pickup and delivery at your convenience',
          'Real-time order tracking with live updates',
          'Professional cleaning services for all fabric types',
          'Secure payment options including Apple Pay and Google Pay',
          'Rate and review service providers',
          'Order history and digital receipts',
          'Special instructions and preferences',
          'Emergency and rush order support',
        ],
        actionText: 'Get Started as Customer',
        onAction: () {
          Navigator.pop(context);
          _handleRoleSelection(context, 'customer');
        },
      ),
    );
  }

  void _showProviderInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RoleInfoBottomSheet(
        title: 'Provider Opportunities',
        iconName: 'local_laundry_service',
        benefits: [
          'Manage orders and set your own service rates',
          'Route optimization for efficient pickup and delivery',
          'Earnings dashboard with detailed transaction history',
          'Customer communication through in-app chat and calls',
          'Service catalog management and pricing control',
          'Verification process for trusted provider status',
          'Commission-based earnings with transparent payouts',
          'Analytics and reporting for business insights',
        ],
        actionText: 'Join as Service Provider',
        onAction: () {
          Navigator.pop(context);
          _handleRoleSelection(context, 'provider');
        },
      ),
    );
  }
}
