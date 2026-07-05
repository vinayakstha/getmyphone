import 'dart:io';
import 'package:client/core/api/api_endpoints.dart';
import 'package:client/core/utils/snackbar_utils.dart';
import 'package:client/features/phone/domain/entities/phone_entity.dart';
import 'package:client/features/phone/presentation/pages/map_picker_screen.dart';
import 'package:client/features/phone/presentation/state/phone_state.dart';
import 'package:client/features/phone/presentation/view_model/phone_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class EditPostScreen extends ConsumerStatefulWidget {
  final PhoneEntity phone;

  const EditPostScreen({super.key, required this.phone});

  @override
  ConsumerState<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends ConsumerState<EditPostScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _cpuCtrl;
  late final TextEditingController _storageCtrl;
  late final TextEditingController _ramCtrl;
  late final TextEditingController _screenCtrl;
  late final TextEditingController _batteryCtrl;
  late final TextEditingController _cameraCtrl;
  late final TextEditingController _usedForCtrl;
  late final TextEditingController _priceCtrl;

  String? selectedCondition;
  String? selectedNegotiable;
  LatLng? _selectedLocation;
  String _locationLabel = '';
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final List<Map<String, String>> conditions = [
    {'label': 'Brand New', 'value': 'new'},
    {'label': 'Like New', 'value': 'like_new'},
    {'label': 'Good', 'value': 'good'},
    {'label': 'Fair', 'value': 'fair'},
    {'label': 'Poor', 'value': 'poor'},
  ];

  final List<Map<String, String>> negotiableOptions = [
    {'label': 'Yes', 'value': 'yes'},
    {'label': 'No', 'value': 'no'},
  ];

  @override
  void initState() {
    super.initState();
    final phone = widget.phone;
    _titleCtrl = TextEditingController(text: phone.title);
    _descriptionCtrl = TextEditingController(text: phone.description);
    _cpuCtrl = TextEditingController(text: phone.cpu);
    _storageCtrl = TextEditingController(text: phone.storage);
    _ramCtrl = TextEditingController(text: phone.ram);
    _screenCtrl = TextEditingController(text: phone.screen);
    _batteryCtrl = TextEditingController(text: phone.battery);
    _cameraCtrl = TextEditingController(text: phone.camera);
    _usedForCtrl = TextEditingController(text: phone.usedFor);
    _priceCtrl = TextEditingController(text: phone.price.toStringAsFixed(0));
    selectedCondition = phone.condition;
    selectedNegotiable = phone.negotiable;
    _selectedLocation = LatLng(
      phone.location.coordinates[1],
      phone.location.coordinates[0],
    );
    _locationLabel =
        '${phone.location.coordinates[1].toStringAsFixed(4)}, ${phone.location.coordinates[0].toStringAsFixed(4)}';
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _cpuCtrl.dispose();
    _storageCtrl.dispose();
    _ramCtrl.dispose();
    _screenCtrl.dispose();
    _batteryCtrl.dispose();
    _cameraCtrl.dispose();
    _usedForCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _requestPermissionAndPick(ImageSource source) async {
    final permission =
        source == ImageSource.camera ? Permission.camera : Permission.photos;
    final status = await permission.request();
    if (status.isGranted) {
      final XFile? picked =
          await _picker.pickImage(source: source, imageQuality: 80);
      if (picked != null) setState(() => _selectedImage = File(picked.path));
    } else if (status.isPermanentlyDenied) {
      if (mounted) openAppSettings();
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined,
                  color: Color(0xFF1565D8)),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _requestPermissionAndPick(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: Color(0xFF1565D8)),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _requestPermissionAndPick(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openMapPicker() async {
    final result = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(builder: (_) => const MapPickerScreen()),
    );
    if (result != null) {
      setState(() {
        _selectedLocation = result;
        _locationLabel =
            '${result.latitude.toStringAsFixed(4)}, ${result.longitude.toStringAsFixed(4)}';
      });
    }
  }

  Future<void> _handleUpdate() async {
    if (_titleCtrl.text.isEmpty ||
        selectedCondition == null ||
        selectedNegotiable == null ||
        _priceCtrl.text.isEmpty) {
      SnackbarUtils.showError(context, 'Please fill in all required fields');
      return;
    }

    final updatedPhone = PhoneEntity(
      phoneId: widget.phone.phoneId,
      title: _titleCtrl.text.trim(),
      photo: widget.phone.photo,
      brand: widget.phone.brand,
      condition: selectedCondition!,
      location: _selectedLocation != null
          ? LocationEntity(
              coordinates: [
                _selectedLocation!.longitude,
                _selectedLocation!.latitude,
              ],
            )
          : widget.phone.location,
      description: _descriptionCtrl.text.trim(),
      cpu: _cpuCtrl.text.trim(),
      storage: _storageCtrl.text.trim(),
      ram: _ramCtrl.text.trim(),
      screen: _screenCtrl.text.trim(),
      battery: _batteryCtrl.text.trim(),
      camera: _cameraCtrl.text.trim(),
      usedFor: _usedForCtrl.text.trim(),
      negotiable: selectedNegotiable!,
      price: double.parse(_priceCtrl.text.trim()),
      sellerId: widget.phone.sellerId,
      sellerName: widget.phone.sellerName,
      sellerProfilePicture: widget.phone.sellerProfilePicture,
      sellerRatingAverage: widget.phone.sellerRatingAverage,
      sellerRatingCount: widget.phone.sellerRatingCount,
    );

    await ref.read(phoneViewModelProvider.notifier).updatePhone(
          widget.phone.phoneId ?? '',
          updatedPhone,
          photoPath: _selectedImage?.path,
        );

    if (!mounted) return;
    final phoneState = ref.read(phoneViewModelProvider);
    if (phoneState.status == PhoneStatus.updated) {
      SnackbarUtils.showSuccess(context, 'Listing updated successfully!');
      Navigator.pop(context);
    } else if (phoneState.status == PhoneStatus.error) {
      SnackbarUtils.showError(
        context,
        phoneState.errorMessage ?? 'Failed to update listing',
      );
    }
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF7A7A7A)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF1565D8)),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String hint,
    List<Map<String, String>> items,
    String? value,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF1565D8)),
          ),
        ),
        hint: Text(hint, style: const TextStyle(color: Color(0xFF7A7A7A))),
        items: items
            .map((e) => DropdownMenuItem(
                  value: e['value'],
                  child: Text(e['label']!),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final phoneState = ref.watch(phoneViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Edit Post',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo
              GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade400),
                    color: Colors.grey.shade100,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!, fit: BoxFit.cover)
                      : widget.phone.photo != null
                          ? Image.network(
                              ApiEndpoints.imageBaseUrl + widget.phone.photo!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.phone_android,
                                size: 60,
                                color: Colors.grey,
                              ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo_outlined,
                                    size: 40, color: Colors.grey),
                                SizedBox(height: 8),
                                Text('Tap to change photo',
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                ),
              ),

              const SizedBox(height: 16),

              _buildTextField('Title *', _titleCtrl),
              _buildDropdown('Condition *', conditions, selectedCondition,
                  (v) => setState(() => selectedCondition = v)),

              // Location
              GestureDetector(
                onTap: _openMapPicker,
                child: Container(
                  height: 56,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: const Color(0xFF1565D8),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _locationLabel.isNotEmpty
                              ? _locationLabel
                              : 'Tap to change location',
                          style: const TextStyle(
                            color: Color(0xFF1565D8),
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios,
                          size: 14, color: Color(0xFF7A7A7A)),
                    ],
                  ),
                ),
              ),

              _buildTextField('Description *', _descriptionCtrl, maxLines: 5),
              _buildTextField('CPU *', _cpuCtrl),
              _buildTextField('Storage *', _storageCtrl),
              _buildTextField('RAM *', _ramCtrl),
              _buildTextField('Screen *', _screenCtrl),
              _buildTextField('Battery *', _batteryCtrl),
              _buildTextField('Camera *', _cameraCtrl),
              _buildTextField('Used for *', _usedForCtrl),
              _buildDropdown('Negotiable *', negotiableOptions,
                  selectedNegotiable, (v) => setState(() => selectedNegotiable = v)),
              _buildTextField('Price (NPR) *', _priceCtrl,
                  keyboardType: TextInputType.number),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: phoneState.status == PhoneStatus.loading
                      ? null
                      : _handleUpdate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565D8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: phoneState.status == PhoneStatus.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Update Listing',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
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
}