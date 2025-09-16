import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ServiceAreaStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;
  final Map<String, dynamic> initialData;

  const ServiceAreaStep({
    Key? key,
    required this.onDataChanged,
    required this.initialData,
  }) : super(key: key);

  @override
  State<ServiceAreaStep> createState() => _ServiceAreaStepState();
}

class _ServiceAreaStepState extends State<ServiceAreaStep> {
  GoogleMapController? _mapController;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _radiusController =
      TextEditingController(text: '5');

  LatLng _centerLocation =
      LatLng(37.7749, -122.4194); // Default to San Francisco
  double _serviceRadius = 5.0; // Default 5 miles
  Set<Circle> _circles = {};
  Set<Marker> _markers = {};

  final List<String> _predefinedAreas = [
    'Downtown',
    'Residential Areas',
    'Business District',
    'University Area',
    'Shopping Centers',
    'Suburbs',
  ];

  List<String> _selectedAreas = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _updateCircle();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    if (widget.initialData.isNotEmpty) {
      setState(() {
        _addressController.text = widget.initialData['address'] ?? '';
        _serviceRadius = widget.initialData['radius']?.toDouble() ?? 5.0;
        _radiusController.text = _serviceRadius.toString();
        _selectedAreas =
            List<String>.from(widget.initialData['selectedAreas'] ?? []);

        if (widget.initialData['centerLat'] != null &&
            widget.initialData['centerLng'] != null) {
          _centerLocation = LatLng(
            widget.initialData['centerLat'].toDouble(),
            widget.initialData['centerLng'].toDouble(),
          );
        }
      });
      _updateCircle();
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _updateCircle() {
    setState(() {
      _circles = {
        Circle(
          circleId: CircleId('service_area'),
          center: _centerLocation,
          radius: _serviceRadius * 1609.34, // Convert miles to meters
          fillColor:
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
          strokeColor: AppTheme.lightTheme.colorScheme.primary,
          strokeWidth: 2,
        ),
      };

      _markers = {
        Marker(
          markerId: MarkerId('center'),
          position: _centerLocation,
          infoWindow: InfoWindow(
            title: 'Service Center',
            snippet: 'Your business location',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      };
    });
    _updateData();
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _centerLocation = position;
    });
    _updateCircle();
    _reverseGeocode(position);
  }

  void _reverseGeocode(LatLng position) {
    // Simulate reverse geocoding
    setState(() {
      _addressController.text =
          '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
    });
  }

  void _updateRadius(String value) {
    final radius = double.tryParse(value);
    if (radius != null && radius > 0 && radius <= 50) {
      setState(() {
        _serviceRadius = radius;
      });
      _updateCircle();
    }
  }

  void _toggleArea(String area) {
    setState(() {
      if (_selectedAreas.contains(area)) {
        _selectedAreas.remove(area);
      } else {
        _selectedAreas.add(area);
      }
    });
    _updateData();
  }

  void _updateData() {
    widget.onDataChanged({
      'address': _addressController.text,
      'centerLat': _centerLocation.latitude,
      'centerLng': _centerLocation.longitude,
      'radius': _serviceRadius,
      'selectedAreas': _selectedAreas,
    });
  }

  bool get isValid {
    return _addressController.text.isNotEmpty && _serviceRadius > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Area',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Define your service coverage area',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 3.h),

        // Address Input
        TextFormField(
          controller: _addressController,
          decoration: InputDecoration(
            labelText: 'Business Address',
            hintText: 'Enter your business address',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            suffixIcon: IconButton(
              icon: CustomIconWidget(
                iconName: 'my_location',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              onPressed: () {
                // Simulate getting current location
                setState(() {
                  _centerLocation = LatLng(37.7749, -122.4194);
                  _addressController.text = '123 Main St, San Francisco, CA';
                });
                _updateCircle();
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Business address is required';
            }
            return null;
          },
          onChanged: (value) => _updateData(),
        ),
        SizedBox(height: 2.h),

        // Service Radius
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _radiusController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Service Radius (miles)',
                  hintText: '5',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'radio_button_unchecked',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
                validator: (value) {
                  final radius = double.tryParse(value ?? '');
                  if (radius == null || radius <= 0) {
                    return 'Enter valid radius';
                  }
                  if (radius > 50) {
                    return 'Maximum radius is 50 miles';
                  }
                  return null;
                },
                onChanged: _updateRadius,
              ),
            ),
            SizedBox(width: 4.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '≈ ${(_serviceRadius * 3.14159 * _serviceRadius).toStringAsFixed(0)} sq mi',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),

        // Interactive Map
        Container(
          height: 30.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _centerLocation,
                zoom: 12.0,
              ),
              circles: _circles,
              markers: _markers,
              onTap: _onMapTap,
              mapType: MapType.normal,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              mapToolbarEnabled: false,
            ),
          ),
        ),
        SizedBox(height: 2.h),

        // Map Instructions
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'touch_app',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Tap on the map to set your business location',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),

        // Predefined Areas
        Text(
          'Target Areas (Optional)',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Select specific areas you want to focus on',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),

        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _predefinedAreas.map((area) {
            final isSelected = _selectedAreas.contains(area);
            return FilterChip(
              label: Text(area),
              selected: isSelected,
              onSelected: (selected) => _toggleArea(area),
              selectedColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
              checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 3.h),

        // Service Area Guidelines
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
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Service Area Tips',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              _buildTip('Start with a smaller radius and expand as you grow'),
              _buildTip('Consider traffic patterns and travel time'),
              _buildTip('Focus on areas with high demand'),
              _buildTip('You can update your service area anytime'),
            ],
          ),
        ),
      ],
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
