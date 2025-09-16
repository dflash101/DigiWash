import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationStepTwoWidget extends StatefulWidget {
  final Function(Map<String, String>) onStepComplete;
  final Map<String, String> initialData;

  const RegistrationStepTwoWidget({
    Key? key,
    required this.onStepComplete,
    required this.initialData,
  }) : super(key: key);

  @override
  State<RegistrationStepTwoWidget> createState() =>
      _RegistrationStepTwoWidgetState();
}

class _RegistrationStepTwoWidgetState extends State<RegistrationStepTwoWidget> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();

  GoogleMapController? _mapController;
  LatLng _selectedLocation = const LatLng(40.7128, -74.0060); // Default to NYC
  bool _locationPermissionGranted = false;
  bool _isLoadingLocation = false;
  bool _showMap = false;

  final List<Map<String, dynamic>> _mockAddressSuggestions = [
    {
      "address": "123 Main Street",
      "city": "New York",
      "state": "NY",
      "zipCode": "10001",
      "lat": 40.7505,
      "lng": -73.9934,
    },
    {
      "address": "456 Oak Avenue",
      "city": "Los Angeles",
      "state": "CA",
      "zipCode": "90210",
      "lat": 34.0522,
      "lng": -118.2437,
    },
    {
      "address": "789 Pine Road",
      "city": "Chicago",
      "state": "IL",
      "zipCode": "60601",
      "lat": 41.8781,
      "lng": -87.6298,
    },
    {
      "address": "321 Elm Street",
      "city": "Miami",
      "state": "FL",
      "zipCode": "33101",
      "lat": 25.7617,
      "lng": -80.1918,
    },
    {
      "address": "654 Maple Drive",
      "city": "Seattle",
      "state": "WA",
      "zipCode": "98101",
      "lat": 47.6062,
      "lng": -122.3321,
    },
  ];

  List<Map<String, dynamic>> _filteredSuggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.initialData['address'] ?? '';
    _cityController.text = widget.initialData['city'] ?? '';
    _stateController.text = widget.initialData['state'] ?? '';
    _zipCodeController.text = widget.initialData['zipCode'] ?? '';

    _addressController.addListener(_onAddressChanged);

    if (widget.initialData['latitude'] != null &&
        widget.initialData['longitude'] != null) {
      _selectedLocation = LatLng(
        double.parse(widget.initialData['latitude']!),
        double.parse(widget.initialData['longitude']!),
      );
      _showMap = true;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  void _onAddressChanged() {
    final query = _addressController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredSuggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    setState(() {
      _filteredSuggestions = _mockAddressSuggestions
          .where((suggestion) =>
              (suggestion['address'] as String).toLowerCase().contains(query) ||
              (suggestion['city'] as String).toLowerCase().contains(query))
          .toList();
      _showSuggestions = _filteredSuggestions.isNotEmpty;
    });
  }

  void _selectSuggestion(Map<String, dynamic> suggestion) {
    setState(() {
      _addressController.text = suggestion['address'];
      _cityController.text = suggestion['city'];
      _stateController.text = suggestion['state'];
      _zipCodeController.text = suggestion['zipCode'];
      _selectedLocation = LatLng(suggestion['lat'], suggestion['lng']);
      _showSuggestions = false;
      _showMap = true;
    });

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_selectedLocation, 15.0),
      );
    }
  }

  Future<void> _requestLocationPermission() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final status = await Permission.location.request();

      setState(() {
        _locationPermissionGranted = status.isGranted;
        _isLoadingLocation = false;
      });

      if (status.isGranted) {
        // Simulate getting current location
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          _selectedLocation = const LatLng(40.7589, -73.9851); // Times Square
          _addressController.text = "1 Times Square";
          _cityController.text = "New York";
          _stateController.text = "NY";
          _zipCodeController.text = "10036";
          _showMap = true;
        });

        if (_mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(_selectedLocation, 15.0),
          );
        }
      } else if (status.isPermanentlyDenied) {
        _showPermissionDialog();
      }
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Location Permission Required',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'To provide you with the best service, we need access to your location. Please enable location permission in your device settings.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  String? _validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }
    if (value.trim().length < 5) {
      return 'Please enter a complete address';
    }
    return null;
  }

  String? _validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'City is required';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'City can only contain letters and spaces';
    }
    return null;
  }

  String? _validateState(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'State is required';
    }
    if (value.trim().length < 2) {
      return 'Please enter a valid state';
    }
    return null;
  }

  String? _validateZipCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'ZIP code is required';
    }
    if (!RegExp(r'^[0-9]{5}(-[0-9]{4})?$').hasMatch(value.trim())) {
      return 'Please enter a valid ZIP code';
    }
    return null;
  }

  void _handleNext() {
    if (_formKey.currentState?.validate() ?? false) {
      final stepData = {
        'address': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'state': _stateController.text.trim(),
        'zipCode': _zipCodeController.text.trim(),
        'latitude': _selectedLocation.latitude.toString(),
        'longitude': _selectedLocation.longitude.toString(),
        'locationPermissionGranted': _locationPermissionGranted.toString(),
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
            'Your Location',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Help us find laundry services in your area',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 4.h),

          // Location Permission Card
          if (!_locationPermissionGranted) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'location_on',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 8.w,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Enable Location Services',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Allow location access to find nearby laundry services and get accurate pickup times.',
                    textAlign: TextAlign.center,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoadingLocation
                          ? null
                          : _requestLocationPermission,
                      icon: _isLoadingLocation
                          ? SizedBox(
                              width: 4.w,
                              height: 4.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : CustomIconWidget(
                              iconName: 'my_location',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 4.w,
                            ),
                      label: Text(_isLoadingLocation
                          ? 'Getting Location...'
                          : 'Use Current Location'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    'OR',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(child: Divider()),
              ],
            ),
            SizedBox(height: 3.h),
          ],

          // Address Input with Autocomplete
          Stack(
            children: [
              TextFormField(
                controller: _addressController,
                keyboardType: TextInputType.streetAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Street Address',
                  hintText: 'Enter your street address',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'home',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                ),
                validator: _validateAddress,
              ),

              // Address Suggestions
              if (_showSuggestions) ...[
                Positioned(
                  top: 7.h,
                  left: 0,
                  right: 0,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 25.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.5),
                        ),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _filteredSuggestions.length,
                        separatorBuilder: (context, index) =>
                            Divider(height: 1),
                        itemBuilder: (context, index) {
                          final suggestion = _filteredSuggestions[index];
                          return ListTile(
                            leading: CustomIconWidget(
                              iconName: 'location_on',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 5.w,
                            ),
                            title: Text(
                              suggestion['address'],
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              '${suggestion['city']}, ${suggestion['state']} ${suggestion['zipCode']}',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                            onTap: () => _selectSuggestion(suggestion),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 3.h),

          // City and State Row
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _cityController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'City',
                    hintText: 'Enter city',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'location_city',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
                    ),
                  ),
                  validator: _validateCity,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: _stateController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'State',
                    hintText: 'NY',
                  ),
                  validator: _validateState,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // ZIP Code
          TextFormField(
            controller: _zipCodeController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'ZIP Code',
              hintText: 'Enter ZIP code',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'local_post_office',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
            ),
            validator: _validateZipCode,
          ),
          SizedBox(height: 4.h),

          // Map Preview
          if (_showMap) ...[
            Container(
              height: 25.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.5),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation,
                    zoom: 15.0,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  markers: {
                    Marker(
                      markerId: const MarkerId('selected_location'),
                      position: _selectedLocation,
                      infoWindow: InfoWindow(
                        title: 'Your Location',
                        snippet: _addressController.text,
                      ),
                    ),
                  },
                  circles: {
                    Circle(
                      circleId: const CircleId('service_area'),
                      center: _selectedLocation,
                      radius: 5000, // 5km service area
                      fillColor: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      strokeColor: AppTheme.lightTheme.colorScheme.primary,
                      strokeWidth: 2,
                    ),
                  },
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Service area shown in blue. Laundry services within 5km radius.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color:
                            AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
          ],

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
