import 'dart:io';
import 'package:client/core/api/api_endpoints.dart';
import 'package:client/core/services/storage/user_session_service.dart';
import 'package:client/core/utils/snackbar_utils.dart';
import 'package:client/features/profile/presentation/state/profile_state.dart';
import 'package:client/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _fullNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final session = ref.read(userSessionServiceProvider);
    _fullNameCtrl = TextEditingController(text: session.getUserFullName());
    _emailCtrl = TextEditingController(text: session.getUserEmail());
    _phoneCtrl = TextEditingController(text: session.getUserPhoneNumber());
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _requestPermissionAndPick(ImageSource source) async {
    final permission = source == ImageSource.camera
        ? Permission.camera
        : Permission.photos;
    final status = await permission.request();

    if (status.isGranted) {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (picked != null) {
        setState(() => _selectedImage = File(picked.path));
      }
    } else if (status.isPermanentlyDenied) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Permission Required'),
            content: const Text(
              'Please enable permission from settings to continue.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.pop(context);
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Image Source',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A5568),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_outlined,
                  color: Color(0xFF1565D8),
                ),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _requestPermissionAndPick(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: Color(0xFF1565D8),
                ),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _requestPermissionAndPick(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleUpdate() async {
    await ref
        .read(profileViewModelProvider.notifier)
        .updateProfile(
          fullName: _fullNameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          phoneNumber: _phoneCtrl.text.trim(),
          photoPath: _selectedImage?.path,
        );

    final profileState = ref.read(profileViewModelProvider);
    if (profileState.status == ProfileStatus.updated) {
      if (mounted) {
        SnackbarUtils.showSuccess(context, 'Profile updated successfully!');
        Navigator.pop(context);
      }
    } else if (profileState.status == ProfileStatus.error) {
      if (mounted) {
        SnackbarUtils.showError(
          context,
          profileState.errorMessage ?? 'Failed to update profile',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.read(userSessionServiceProvider);
    final profilePicture = session.getUserProfilePicture();
    final fullName = session.getUserFullName() ?? 'U';
    final initial = fullName[0].toUpperCase();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Profile Photo
              GestureDetector(
                onTap: _showImageSourceDialog,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 52,
                        backgroundColor: const Color(0xFF0B66E4),
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : profilePicture != null
                            ? NetworkImage(
                                    ApiEndpoints.getImageUrl(profilePicture),
                                  )
                                  as ImageProvider
                            : null,
                        child: _selectedImage == null && profilePicture == null
                            ? Text(
                                initial,
                                style: const TextStyle(
                                  fontSize: 36,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : null,
                      ),
                    ),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "UPLOAD PHOTO",
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 0.6,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 22),

              _buildTextField(controller: _fullNameCtrl, hint: 'Full Name'),

              const SizedBox(height: 12),

              _buildTextField(
                controller: _emailCtrl,
                hint: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 12),

              _buildTextField(
                controller: _phoneCtrl,
                hint: 'Phone Number',
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleUpdate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B66E4),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF0B66E4)),
        ),
      ),
    );
  }
}
