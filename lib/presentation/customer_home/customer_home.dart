import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart'; // for AppTheme (and AppRoutes if you re-export it)

class CustomerHomePage extends StatelessWidget {
  const CustomerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final benefits = const [
      'Schedule pickup and delivery at your convenience',
      'Real-time order tracking with live updates',
      'Professional cleaning services for all fabric types',
      'Secure payment options including Apple Pay and Google Pay',
      'Rate and review service providers',
      'Order history and digital receipts',
      'Special instructions and preferences',
      'Emergency and rush order support',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('DigiWash'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 10,
                      offset: Offset(0, 4),
                      color: Color(0x14000000),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      child: const Icon(Icons.local_laundry_service, size: 24),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Customer Home',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text('Your laundry, delivered.',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // Quick actions
              Text('Quick Actions',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 1.h),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _QuickAction(
                    icon: Icons.add_circle_outline,
                    label: 'Book Pickup',
                    onTap: () {
                      // TODO: Navigate to your schedule flow
                      // Navigator.pushNamed(context, AppRoutes.newOrder);
                    },
                  ),
                  _QuickAction(
                    icon: Icons.directions_car_outlined,
                    label: 'Track Order',
                    onTap: () {
                      // TODO: Navigate to order tracking
                    },
                  ),
                  _QuickAction(
                    icon: Icons.receipt_long_outlined,
                    label: 'Order History',
                    onTap: () {
                      // TODO: Navigate to order history
                    },
                  ),
                  _QuickAction(
                    icon: Icons.chat_bubble_outline,
                    label: 'Support',
                    onTap: () {},
                  ),
                ],
              ),

              SizedBox(height: 3.h),

              // Benefits section
              Text('Customer Benefits',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
              SizedBox(height: 1.h),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Benefits & Features:',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      SizedBox(height: 1.h),
                      ...benefits.map(
                        (b) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.check_circle_outline),
                          title: Text(b),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to create order
        },
        icon: const Icon(Icons.add),
        label: const Text('New Order'),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
    );
  }
}

