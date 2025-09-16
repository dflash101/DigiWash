import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ServiceOfferingsStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;
  final Map<String, dynamic> initialData;

  const ServiceOfferingsStep({
    Key? key,
    required this.onDataChanged,
    required this.initialData,
  }) : super(key: key);

  @override
  State<ServiceOfferingsStep> createState() => _ServiceOfferingsStepState();
}

class _ServiceOfferingsStepState extends State<ServiceOfferingsStep> {
  Map<String, bool> _selectedServices = {};
  Map<String, TextEditingController> _priceControllers = {};
  Map<String, String> _turnaroundTimes = {};

  final List<Map<String, dynamic>> _serviceTypes = [
    {
      'key': 'washFold',
      'title': 'Wash & Fold',
      'description': 'Standard washing and folding service',
      'icon': 'local_laundry_service',
      'unit': 'per lb',
      'defaultPrice': '2.50',
      'turnaroundOptions': ['Same Day', '24 Hours', '48 Hours', '3-5 Days'],
    },
    {
      'key': 'dryClean',
      'title': 'Dry Cleaning',
      'description': 'Professional dry cleaning service',
      'icon': 'dry_cleaning',
      'unit': 'per item',
      'defaultPrice': '8.00',
      'turnaroundOptions': ['24 Hours', '48 Hours', '3-5 Days', '1 Week'],
    },
    {
      'key': 'ironing',
      'title': 'Ironing & Pressing',
      'description': 'Professional ironing and pressing',
      'icon': 'iron',
      'unit': 'per item',
      'defaultPrice': '3.00',
      'turnaroundOptions': ['Same Day', '24 Hours', '48 Hours', '3-5 Days'],
    },
    {
      'key': 'delicate',
      'title': 'Delicate Care',
      'description': 'Special care for delicate fabrics',
      'icon': 'favorite',
      'unit': 'per item',
      'defaultPrice': '12.00',
      'turnaroundOptions': ['48 Hours', '3-5 Days', '1 Week'],
    },
    {
      'key': 'alterations',
      'title': 'Alterations',
      'description': 'Basic clothing alterations',
      'icon': 'content_cut',
      'unit': 'per item',
      'defaultPrice': '15.00',
      'turnaroundOptions': ['3-5 Days', '1 Week', '2 Weeks'],
    },
    {
      'key': 'pickup',
      'title': 'Pickup & Delivery',
      'description': 'Convenient pickup and delivery service',
      'icon': 'local_shipping',
      'unit': 'per trip',
      'defaultPrice': '5.00',
      'turnaroundOptions': ['Same Day', '24 Hours', '48 Hours'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadInitialData();
  }

  @override
  void dispose() {
    _priceControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _initializeControllers() {
    for (var service in _serviceTypes) {
      final key = service['key'] as String;
      _priceControllers[key] =
          TextEditingController(text: service['defaultPrice']);
      _turnaroundTimes[key] =
          (service['turnaroundOptions'] as List<String>).first;
    }
  }

  void _loadInitialData() {
    if (widget.initialData.isNotEmpty) {
      setState(() {
        _selectedServices = Map<String, bool>.from(
            widget.initialData['selectedServices'] ?? {});
        _turnaroundTimes = Map<String, String>.from(
            widget.initialData['turnaroundTimes'] ?? _turnaroundTimes);

        final prices =
            widget.initialData['prices'] as Map<String, String>? ?? {};
        prices.forEach((key, value) {
          if (_priceControllers.containsKey(key)) {
            _priceControllers[key]!.text = value;
          }
        });
      });
    }
  }

  void _updateData() {
    final prices = <String, String>{};
    _priceControllers.forEach((key, controller) {
      prices[key] = controller.text;
    });

    widget.onDataChanged({
      'selectedServices': _selectedServices,
      'prices': prices,
      'turnaroundTimes': _turnaroundTimes,
    });
  }

  void _toggleService(String serviceKey, bool selected) {
    setState(() {
      _selectedServices[serviceKey] = selected;
    });
    _updateData();
  }

  void _updateTurnaroundTime(String serviceKey, String time) {
    setState(() {
      _turnaroundTimes[serviceKey] = time;
    });
    _updateData();
  }

  bool get isValid {
    return _selectedServices.values.any((selected) => selected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Offerings',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Select services you offer and set your pricing',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 3.h),

        // Service Selection Grid
        ...(_serviceTypes
            .map((service) => _buildServiceCard(service))
            .toList()),

        SizedBox(height: 3.h),

        // Pricing Guidelines
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'lightbulb',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Pricing Tips',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              _buildTip('Research local competitor pricing'),
              _buildTip('Consider your costs and desired profit margin'),
              _buildTip('Offer competitive turnaround times'),
              _buildTip('Bundle services for better value'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    final String key = service['key'];
    final bool isSelected = _selectedServices[key] ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Header
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: service['icon'],
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service['title'],
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          service['description'],
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
                    value: isSelected,
                    onChanged: (value) => _toggleService(key, value),
                  ),
                ],
              ),

              // Service Configuration (shown when selected)
              if (isSelected) ...[
                SizedBox(height: 2.h),
                Divider(color: AppTheme.lightTheme.colorScheme.outline),
                SizedBox(height: 2.h),

                // Price Input
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price (${service['unit']})',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          TextFormField(
                            controller: _priceControllers[key],
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                            decoration: InputDecoration(
                              prefixText: '\$ ',
                              hintText: '0.00',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.5.h),
                            ),
                            onChanged: (value) => _updateData(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Turnaround Time',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          DropdownButtonFormField<String>(
                            value: _turnaroundTimes[key],
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.5.h),
                            ),
                            items:
                                (service['turnaroundOptions'] as List<String>)
                                    .map((String time) {
                              return DropdownMenuItem<String>(
                                value: time,
                                child: Text(
                                  time,
                                  style:
                                      AppTheme.lightTheme.textTheme.bodyMedium,
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                _updateTurnaroundTime(key, newValue);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 0.5.h),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
