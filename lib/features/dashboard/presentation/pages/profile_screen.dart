import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../auth/presentation/pages/login_screen.dart';
import 'package:quick_menu/core/services/storage/user_session_service.dart';
import 'package:quick_menu/features/auth/domain/usecases/upload_user_photo_usecase.dart';
import 'package:quick_menu/features/payment/presentation/pages/order_history_screen.dart';
import 'package:quick_menu/features/offers/presentation/pages/special_offers_screen.dart';
import 'package:quick_menu/core/services/biometric_auth_service.dart';
import 'package:quick_menu/core/api/api_endpoint.dart';
import 'about_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  File? _profileImage;
  bool _isEditing = false;
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _biometricSupported = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _loadNotificationPreference();
    _checkBiometricSupport();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userSessionService = ref.read(userSessionServiceProvider);
    _nameController.text = userSessionService.getCurrentUserFullName() ?? '';
    _emailController.text = userSessionService.getCurrentUserEmail() ?? '';
    _phoneController.text =
        userSessionService.getCurrentUserPhoneNumber() ?? '';
  }

  Future<void> _loadNotificationPreference() async {
    // Check notification permission status
    final notificationStatus = await Permission.notification.status;

    if (notificationStatus.isDenied) {
      // Request notification permission if not already requested
      final result = await Permission.notification.request();
      setState(() {
        _notificationsEnabled = result.isGranted;
      });
    } else if (notificationStatus.isGranted) {
      setState(() {
        _notificationsEnabled = true;
      });
    } else if (notificationStatus.isPermanentlyDenied) {
      // Permission is permanently denied, show dialog directing to settings
      _showNotificationPermissionDialog();
      setState(() {
        _notificationsEnabled = false;
      });
    } else {
      setState(() {
        _notificationsEnabled = true;
      });
    }
  }

  void _showNotificationPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Notification Permission'),
        content: const Text(
          'This app needs notification permission to send you updates. '
          'Please enable it in settings.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Go to Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveNotificationPreference(bool value) async {
    setState(() {
      _notificationsEnabled = value;
    });
    // Save to local storage here if needed
    // Example: await SharedPreferences.getInstance().setBool('notifications_enabled', value);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _notificationsEnabled
              ? 'Notifications enabled'
              : 'Notifications disabled',
        ),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Check if biometric is supported on device
  Future<void> _checkBiometricSupport() async {
    print('👤 Profile: Checking biometric support...');
    final biometricService = ref.read(biometricAuthServiceProvider);
    final isSupported = await biometricService.isBiometricSupported();
    final isEnabled = await biometricService.isBiometricEnabled();

    print('👤 Profile: Supported=$isSupported, Enabled=$isEnabled');

    if (mounted) {
      setState(() {
        _biometricSupported = isSupported;
        _biometricEnabled = isEnabled;
      });
    }
  }

  /// Toggle biometric authentication
  Future<void> _toggleBiometric(bool value) async {
    print('👤 Profile: Toggle biometric to: $value');
    final biometricService = ref.read(biometricAuthServiceProvider);
    final userSessionService = ref.read(userSessionServiceProvider);

    if (value) {
      // Enable biometric - need credentials
      final email = userSessionService.getCurrentUserEmail();
      print('👤 Profile: User email: ${email?.substring(0, 3)}...');

      if (email == null || email.isEmpty) {
        print('❌ Profile: No email found in session');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to enable biometric. Please login again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Show dialog to get password
      print('👤 Profile: Showing password dialog...');
      _showPasswordDialogForBiometric(email);
    } else {
      // Disable biometric
      print('👤 Profile: Disabling biometric...');
      final success = await biometricService.disableBiometric();

      print('👤 Profile: Disable result: $success');

      if (mounted) {
        setState(() {
          _biometricEnabled = success ? false : _biometricEnabled;
        });

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Biometric login disabled'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    }
  }

  /// Show dialog to enter password for enabling biometric
  void _showPasswordDialogForBiometric(String email) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Enable Biometric Login'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your password to enable fingerprint login:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              passwordController.dispose();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final password = passwordController.text;

              if (password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter your password'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              print('👤 Profile: Password entered, closing dialog...');
              // Close dialog first
              Navigator.pop(context);

              // Show loading indicator
              if (mounted) {
                print('👤 Profile: Showing loading indicator...');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Text('Setting up biometric...'),
                      ],
                    ),
                    duration: Duration(seconds: 10),
                  ),
                );
              }

              // Enable biometric with credentials
              print('👤 Profile: Calling enableBiometric...');
              final biometricService = ref.read(biometricAuthServiceProvider);

              // First check if biometric is properly enrolled
              final availableBiometrics = await biometricService
                  .getAvailableBiometrics();
              print('👤 Profile: Available biometrics: $availableBiometrics');

              if (availableBiometrics.isEmpty) {
                print('❌ Profile: No biometrics enrolled');
                passwordController.dispose();

                if (mounted) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        '⚠️ No fingerprint enrolled!\n\n'
                        'Steps to add:\n'
                        '1. Open Settings\n'
                        '2. Security → Fingerprint\n'
                        '3. Add your fingerprint\n'
                        '4. Return and try again',
                      ),
                      backgroundColor: Colors.orange,
                      duration: Duration(seconds: 8),
                    ),
                  );
                }
                return;
              }

              // Test biometric before enabling
              print('👤 Profile: Testing biometric first...');
              final testResult = await biometricService.testBiometric();
              print('👤 Profile: Test result: $testResult');

              if (!testResult) {
                print('❌ Profile: Biometric test failed');
                passwordController.dispose();

                if (mounted) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        '❌ Fingerprint test failed!\n\n'
                        'Troubleshooting:\n'
                        '• Clean your fingerprint sensor\n'
                        '• Wipe your finger dry\n'
                        '• Try different finger\n'
                        '• Check Settings → Security → Fingerprint works',
                      ),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 8),
                    ),
                  );
                }
                return;
              }

              // Now enable biometric
              final success = await biometricService.enableBiometric(
                email: email,
                password: password,
              );

              print('👤 Profile: Enable result: $success');
              passwordController.dispose();

              if (mounted) {
                setState(() {
                  _biometricEnabled = success;
                });

                // Show result message
                print('👤 Profile: Showing result message...');
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? '✓ Biometric login enabled!\n\nYou can now login with fingerprint'
                          : '❌ Setup incomplete!\n\nThe fingerprint test worked but setup failed.\nPlease try again.',
                    ),
                    backgroundColor: success ? Colors.green : Colors.orange,
                    duration: Duration(seconds: success ? 4 : 7),
                  ),
                );
              }
            },
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Constructs the full backend URL for the profile picture
  /// Handles URL encoding and cache busting
  String _constructProfileImageUrl(String photoPath) {
    // Use dynamic server URL from ApiEndpoints
    final String backendBaseUrl = ApiEndpoints.serverUrl;

    print('📸 Input photoPath: $photoPath');

    // If it's already a full URL, use it
    if (photoPath.startsWith('http')) {
      print('✅ Already full URL, using as-is');
      return photoPath;
    }

    // Remove /public/ prefix if present (backend might include it in the path)
    String cleanPath = photoPath;
    if (cleanPath.startsWith('/public/')) {
      cleanPath = cleanPath.replaceFirst('/public/', '/');
      print('📸 Removed /public/ prefix: $cleanPath');
    }

    // Ensure cleanPath starts with /
    if (!cleanPath.startsWith('/')) {
      cleanPath = '/$cleanPath';
      print('📸 Added leading slash: $cleanPath');
    }

    // Construct full URL from relative path
    final fullUrl = '$backendBaseUrl$cleanPath';
    print('📸 Constructed URL (before encoding): $fullUrl');

    // Add cache buster to force fresh image load
    final urlWithTimestamp =
        '$fullUrl?t=${DateTime.now().millisecondsSinceEpoch}';

    print('✅ Final Profile Image URL: $urlWithTimestamp');
    return urlWithTimestamp;
  }

  /// Build image provider for profile picture with fallback
  ImageProvider _buildProfileImageProvider() {
    final userSessionService = ref.read(userSessionServiceProvider);
    final photoUrl = userSessionService.getCurrentUserPhotoUrl();

    print('🖼️ Building profile image provider');
    print('🖼️ PhotoUrl from session: $photoUrl');

    // Show placeholder if no profile picture
    if (photoUrl == null || photoUrl.isEmpty) {
      print('⚠️ No profile picture URL found, showing placeholder');
      return const AssetImage('assets/image/background.jpg');
    }

    try {
      final fullUrl = _constructProfileImageUrl(photoUrl);
      print('🖼️ Full constructed URL: $fullUrl');

      // Add timestamp to bust cache
      final cacheBustedUrl =
          '$fullUrl?t=${DateTime.now().millisecondsSinceEpoch}';
      print('🖼️ Cache-busted URL: $cacheBustedUrl');

      return CachedNetworkImageProvider(cacheBustedUrl);
    } catch (e) {
      print('❌ Error constructing image URL: $e');
      return const AssetImage('assets/image/background.jpg');
    }
  }

  Future<void> _pickProfileImage() async {
    try {
      // Check current permission statuses
      final cameraStatus = await Permission.camera.status;
      final photosStatus = await Permission.photos.status;
      final storageStatus = await Permission.storage.status;

      print('📸 Checking permissions before showing source dialog...');
      print('📸 Camera status: $cameraStatus');
      print('📸 Photos status: $photosStatus');
      print('📸 Storage status: $storageStatus');

      // Request camera permission if not granted
      if (!cameraStatus.isGranted) {
        print('📸 Requesting camera permission...');
        final cameraResult = await Permission.camera.request();
        if (!cameraResult.isGranted) {
          print('❌ Camera permission denied');
          if (cameraResult.isPermanentlyDenied) {
            _showGoToSettingsDialog();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Camera permission is required to take photos'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }

      // Request gallery permissions if not granted
      if (!photosStatus.isGranted && !storageStatus.isGranted) {
        print('📸 Requesting gallery permissions...');
        final photosResult = await Permission.photos.request();
        PermissionStatus galleryResult = photosResult;

        if (!photosResult.isGranted) {
          galleryResult = await Permission.storage.request();
        }

        if (!galleryResult.isGranted) {
          print('❌ Gallery permissions denied');
          if (galleryResult.isPermanentlyDenied) {
            _showGoToSettingsDialogForGallery();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Gallery permission is required to select photos',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }

      // Permissions granted, show source selection dialog
      print('✅ All permissions granted, showing source dialog');
      _showImageSourceDialog();
    } catch (e) {
      print('❌ Error requesting permissions: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error accessing permissions: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Choose Image Source'),
        content: const Text('Select where to pick your profile photo from:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickFromGallery();
            },
            child: const Text('Gallery'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickFromCamera();
            },
            child: const Text('Camera'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    try {
      print('📸 Opening gallery picker...');
      _openGalleryPicker();
    } catch (e) {
      print('❌ Error accessing gallery: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error accessing gallery: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      print('📸 Opening camera picker...');
      _openCameraPicker();
    } catch (e) {
      print('❌ Error accessing camera: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error accessing camera: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _openCameraPicker() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      print('✅ Image captured from camera: ${file.path}');
      print('✅ File exists: ${await file.exists()}');
      print('✅ File size: ${await file.length()} bytes');

      setState(() {
        _profileImage = file;
      });
    }
  }

  void _showGoToSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Camera Permission Denied'),
        content: const Text(
          'Camera permission has been permanently denied. Please enable it in your app settings to use the camera.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Go to Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _openGalleryPicker() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      print('✅ Image picked from gallery: ${file.path}');
      print('✅ File exists: ${await file.exists()}');
      print('✅ File size: ${await file.length()} bytes');

      setState(() {
        _profileImage = file;
      });
    }
  }

  void _showGoToSettingsDialogForGallery() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Gallery Permission Denied'),
        content: const Text(
          'Gallery permission has been permanently denied. Please enable it in your app settings to select photos from gallery.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Go to Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveProfileChanges() async {
    final userSessionService = ref.read(userSessionServiceProvider);
    final userId = userSessionService.getCurrentUserId();

    if (userId != null) {
      // If user selected a new profile image, upload it
      if (_profileImage != null) {
        try {
          // Upload photo using the usecase
          final uploadResult = await ref
              .read(uploadUserPhotoUsecaseProvider)
              .call(
                UploadUserPhotoParams(
                  userId: userId,
                  photoPath: _profileImage!.path,
                ),
              );

          // Handle the result
          if (uploadResult.isRight()) {
            // Photo upload successful
            final dynamic updatedUser = uploadResult.fold(
              (l) => null,
              (r) => r,
            );
            final photoUrl = updatedUser?.photoUrl;

            print('📸 Photo upload successful!');
            print('📸 Updated photo URL: $photoUrl');

            // Photo uploaded successfully, save to session
            await userSessionService.saveUserSession(
              userId: userId,
              email: _emailController.text,
              fullName: _nameController.text,
              phoneNumber: _phoneController.text,
              photoUrl: photoUrl,
            );

            if (mounted) {
              // Clear image cache to force reload of new image
              imageCache.clear();
              imageCache.clearLiveImages();

              setState(() {
                _isEditing = false;
                _profileImage = null;
              });

              // Force rebuild after a short delay to ensure cache is cleared
              await Future.delayed(const Duration(milliseconds: 300));
              if (mounted) {
                setState(() {});
                print('📸 Profile rebuilt with new photo');
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          } else {
            // Photo upload failed
            final failure = uploadResult.fold((l) => l, (r) => null);
            if (failure != null && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Photo upload failed: ${failure.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error uploading photo: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        // No photo change, just update other info
        await userSessionService.saveUserSession(
          userId: userId,
          email: _emailController.text,
          fullName: _nameController.text,
          phoneNumber: _phoneController.text,
        );

        setState(() {
          _isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userSessionService = ref.read(userSessionServiceProvider);

    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              // 🎨 CREATIVE HEADER WITH STATS
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 28,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE05757), Color(0xFFF7971E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  children: [
                    // Header title with Edit button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "👤 My Profile",
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isEditing ? Icons.close : Icons.edit_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              if (_isEditing) {
                                // Reset to original values
                                _nameController.text =
                                    userSessionService
                                        .getCurrentUserFullName() ??
                                    '';
                                _emailController.text =
                                    userSessionService.getCurrentUserEmail() ??
                                    '';
                                _phoneController.text =
                                    userSessionService
                                        .getCurrentUserPhoneNumber() ??
                                    '';
                                _profileImage = null;
                              }
                              _isEditing = !_isEditing;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Avatar with Edit Button
                    Stack(
                      children: [
                        CircleAvatar(
                          key: ValueKey(
                            userSessionService.getCurrentUserPhotoUrl(),
                          ),
                          radius: 48,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          child: _profileImage != null
                              ? ClipOval(
                                  child: Image.file(
                                    _profileImage!,
                                    fit: BoxFit.cover,
                                    width: 92,
                                    height: 92,
                                    cacheHeight: 92,
                                    cacheWidth: 92,
                                    errorBuilder: (context, error, stackTrace) {
                                      print('Error loading image: $error');
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.person),
                                      );
                                    },
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 46,
                                  backgroundColor: Colors.white,
                                  backgroundImage: _buildProfileImageProvider(),
                                ),
                        ),
                        if (_isEditing)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickProfileImage,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Color(0xFFE05757),
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Name - Editable
                    if (_isEditing)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: _nameController,
                          style: const TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: "Enter your name",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontFamily: 'OpenSans',
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      Text(
                        _nameController.text.isNotEmpty
                            ? _nameController.text
                            : "Not provided",
                        style: const TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    const SizedBox(height: 4),

                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "🌟 User",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 📧 EMAIL & PHONE SECTION (EDITABLE)
              if (_isEditing)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "📋 Edit Information",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _saveProfileChanges,
                              icon: const Icon(Icons.save),
                              label: const Text("Save Changes"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "📋 Contact Information",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      infoTile(
                        icon: Icons.person,
                        label: "Full Name",
                        value: _nameController.text.isNotEmpty
                            ? _nameController.text
                            : "Not provided",
                        emoji: "👤",
                      ),
                      const SizedBox(height: 12),
                      infoTile(
                        icon: Icons.email,
                        label: "Email",
                        value: _emailController.text.isNotEmpty
                            ? _emailController.text
                            : "Not provided",
                        emoji: "✉️",
                      ),
                      const SizedBox(height: 12),
                      infoTile(
                        icon: Icons.phone,
                        label: "Phone",
                        value: _phoneController.text.isNotEmpty
                            ? _phoneController.text
                            : "Not provided",
                        emoji: "📱",
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              // 🎯 PREFERENCES & SETTINGS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "⚙️ Preferences & More",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SpecialOffersScreen(),
                          ),
                        );
                      },
                      child: _SettingsTile(
                        icon: Icons.local_offer,
                        label: "Special Offers",
                        emoji: "🎉",
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _SettingsTile(
                      icon: Icons.notifications,
                      label: "Notifications",
                      emoji: "🔔",
                      trailing: Switch(
                        value: _notificationsEnabled,
                        onChanged: _saveNotificationPreference,
                        activeThumbColor: Colors.green,
                      ),
                    ),
                    if (_biometricSupported) ...[
                      const SizedBox(height: 10),
                      _SettingsTile(
                        icon: Icons.fingerprint,
                        label: "Biometric Login",
                        emoji: "🔐",
                        trailing: Switch(
                          value: _biometricEnabled,
                          onChanged: _toggleBiometric,
                          activeThumbColor: Colors.green,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    _SettingsTile(
                      icon: Icons.card_giftcard,
                      label: "Loyalty Points",
                      emoji: "🏆",
                      trailing: const Text(
                        "250 Pts",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // � ORDER HISTORY
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "📜 Orders",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderHistoryScreen(),
                          ),
                        );
                      },
                      child: _SettingsTile(
                        icon: Icons.receipt_long,
                        label: "Order History",
                        emoji: "📋",
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // �📞 SUPPORT & HELP
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "💬 Help & Support",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutScreen(),
                          ),
                        );
                      },
                      child: _SettingsTile(
                        icon: Icons.mail_outline,
                        label: "Contact Us",
                        emoji: "📧",
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        // Chat functionality can be added here
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Chat feature coming soon!'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      },
                      child: _SettingsTile(
                        icon: Icons.chat_bubble_outline,
                        label: "Chat Support",
                        emoji: "💬",
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),

          // LOGOUT BUTTON
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton.extended(
              backgroundColor: const Color(0xFFE05757),
              icon: const Icon(Icons.logout),
              label: const Text(
                "Logout",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () async {
                await userSessionService.clearSession();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget infoTile({
  required IconData icon,
  required String label,
  required String value,
  required String emoji,
}) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE05757).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 18)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// ⚙️ Settings tile widget
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String emoji;
  final Widget trailing;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.emoji,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
