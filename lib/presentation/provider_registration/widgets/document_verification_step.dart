
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DocumentVerificationStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;
  final Map<String, dynamic> initialData;

  const DocumentVerificationStep({
    Key? key,
    required this.onDataChanged,
    required this.initialData,
  }) : super(key: key);

  @override
  State<DocumentVerificationStep> createState() =>
      _DocumentVerificationStepState();
}

class _DocumentVerificationStepState extends State<DocumentVerificationStep> {
  final ImagePicker _picker = ImagePicker();
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isUploading = false;

  Map<String, XFile?> _documents = {
    'businessLicense': null,
    'taxId': null,
    'insurance': null,
  };

  Map<String, double> _uploadProgress = {
    'businessLicense': 0.0,
    'taxId': 0.0,
    'insurance': 0.0,
  };

  final List<Map<String, dynamic>> _documentTypes = [
    {
      'key': 'businessLicense',
      'title': 'Business License',
      'description': 'Valid business registration certificate',
      'icon': 'description',
      'required': true,
    },
    {
      'key': 'taxId',
      'title': 'Tax ID Certificate',
      'description': 'Federal tax identification document',
      'icon': 'receipt_long',
      'required': true,
    },
    {
      'key': 'insurance',
      'title': 'Insurance Certificate',
      'description': 'Business liability insurance proof',
      'icon': 'security',
      'required': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadInitialData();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    if (widget.initialData.isNotEmpty) {
      setState(() {
        _documents = Map<String, XFile?>.from(widget.initialData);
      });
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) return;

      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
          camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

      await _cameraController!.initialize();

      // Apply platform-specific settings
      try {
        await _cameraController!.setFocusMode(FocusMode.auto);
      } catch (e) {}

      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {}
      }

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<void> _captureDocument(String documentKey) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      await _initializeCamera();
    }

    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final XFile photo = await _cameraController!.takePicture();
        await _uploadDocument(documentKey, photo);
      } catch (e) {
        _showErrorMessage('Failed to capture photo. Please try again.');
      }
    } else {
      _showErrorMessage('Camera not available. Please use gallery option.');
    }
  }

  Future<void> _pickFromGallery(String documentKey) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        await _uploadDocument(documentKey, image);
      }
    } catch (e) {
      _showErrorMessage('Failed to pick image from gallery.');
    }
  }

  Future<void> _pickFromFiles(String documentKey) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        XFile xFile;

        if (kIsWeb && file.bytes != null) {
          xFile = XFile.fromData(file.bytes!, name: file.name);
        } else if (file.path != null) {
          xFile = XFile(file.path!);
        } else {
          _showErrorMessage('Failed to access selected file.');
          return;
        }

        await _uploadDocument(documentKey, xFile);
      }
    } catch (e) {
      _showErrorMessage('Failed to pick file.');
    }
  }

  Future<void> _uploadDocument(String documentKey, XFile file) async {
    setState(() {
      _isUploading = true;
      _uploadProgress[documentKey] = 0.0;
    });

    try {
      // Simulate upload progress
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(Duration(milliseconds: 50));
        if (mounted) {
          setState(() {
            _uploadProgress[documentKey] = i / 100.0;
          });
        }
      }

      setState(() {
        _documents[documentKey] = file;
        _isUploading = false;
      });

      _updateData();
      _showSuccessMessage('Document uploaded successfully!');
    } catch (e) {
      setState(() {
        _isUploading = false;
        _uploadProgress[documentKey] = 0.0;
      });
      _showErrorMessage('Upload failed. Please try again.');
    }
  }

  void _updateData() {
    widget.onDataChanged(_documents);
  }

  void _showDocumentOptions(String documentKey) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Upload Document',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),

            // Camera Option
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Take Photo'),
              subtitle: Text('Capture document with camera'),
              onTap: () {
                Navigator.pop(context);
                _captureDocument(documentKey);
              },
            ),

            // Gallery Option
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Choose from Gallery'),
              subtitle: Text('Select from photo gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery(documentKey);
              },
            ),

            // File Option
            ListTile(
              leading: CustomIconWidget(
                iconName: 'folder',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Browse Files'),
              subtitle: Text('Select PDF or image file'),
              onTap: () {
                Navigator.pop(context);
                _pickFromFiles(documentKey);
              },
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );
  }

  bool get isValid {
    return _documents['businessLicense'] != null && _documents['taxId'] != null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Document Verification',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Upload required business documents for verification',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 3.h),

        // Document Upload Cards
        ...(_documentTypes
            .map((docType) => _buildDocumentCard(docType))
            .toList()),

        SizedBox(height: 3.h),

        // Upload Guidelines
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
                    'Upload Guidelines',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              _buildGuideline('Ensure documents are clear and readable'),
              _buildGuideline('Accepted formats: PDF, JPG, PNG'),
              _buildGuideline('Maximum file size: 5MB per document'),
              _buildGuideline('Documents must be current and valid'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentCard(Map<String, dynamic> docType) {
    final String key = docType['key'];
    final bool hasDocument = _documents[key] != null;
    final bool isUploading = _isUploading && _uploadProgress[key]! > 0;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: hasDocument
                ? AppTheme.getSuccessColor(true)
                : AppTheme.lightTheme.colorScheme.outline,
            width: hasDocument ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: hasDocument
                          ? AppTheme.getSuccessColor(true)
                              .withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: hasDocument ? 'check_circle' : docType['icon'],
                      color: hasDocument
                          ? AppTheme.getSuccessColor(true)
                          : AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              docType['title'],
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (docType['required'])
                              Text(
                                ' *',
                                style: TextStyle(
                                  color: AppTheme.lightTheme.colorScheme.error,
                                  fontSize: 16,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          docType['description'],
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (isUploading) ...[
                SizedBox(height: 2.h),
                LinearProgressIndicator(
                  value: _uploadProgress[key],
                  backgroundColor: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Uploading... ${(_uploadProgress[key]! * 100).toInt()}%',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ] else if (hasDocument) ...[
                SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'check',
                        color: AppTheme.getSuccessColor(true),
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'Document uploaded successfully',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.getSuccessColor(true),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _showDocumentOptions(key),
                        child: Text('Replace'),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                SizedBox(height: 2.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showDocumentOptions(key),
                    icon: CustomIconWidget(
                      iconName: 'upload',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    label: Text('Upload Document'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideline(String text) {
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
