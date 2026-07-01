import 'package:client/app/routes/app_routes.dart';
import 'package:client/features/category/presentation/state/category_state.dart';
import 'package:client/features/category/presentation/view_model/catetory_view_model.dart';
import 'package:client/features/phone/presentation/pages/map_picker_screen.dart';
import 'package:client/features/phone/presentation/pages/post_form_screen_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class PostFormScreenTwo extends ConsumerStatefulWidget {
  final String title;
  final String? photoPath;

  const PostFormScreenTwo({super.key, required this.title, this.photoPath});

  @override
  ConsumerState<PostFormScreenTwo> createState() => _PostFormScreenTwoState();
}

class _PostFormScreenTwoState extends ConsumerState<PostFormScreenTwo> {
  final List<Map<String, String>> conditions = [
    {'label': 'Brand New', 'value': 'new'},
    {'label': 'Like New', 'value': 'like_new'},
    {'label': 'Good', 'value': 'good'},
    {'label': 'Fair', 'value': 'fair'},
    {'label': 'Poor', 'value': 'poor'},
  ];

  String? selectedBrandId;
  String? selectedCondition;
  LatLng? _selectedLocation;

  final _descriptionCtrl = TextEditingController();
  final _cpuCtrl = TextEditingController();
  final _storageCtrl = TextEditingController();
  final _ramCtrl = TextEditingController();
  final _screenCtrl = TextEditingController();
  final _batteryCtrl = TextEditingController();
  final _cameraCtrl = TextEditingController();
  final _usedForCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(categoryViewModelProvider.notifier).getAllCategories(),
    );
  }

  @override
  void dispose() {
    _descriptionCtrl.dispose();
    _cpuCtrl.dispose();
    _storageCtrl.dispose();
    _ramCtrl.dispose();
    _screenCtrl.dispose();
    _batteryCtrl.dispose();
    _cameraCtrl.dispose();
    _usedForCtrl.dispose();
    super.dispose();
  }

  // Future<void> _openMapPicker() async {
  //   final result = await Navigator.push<LatLng>(
  //     context,
  //     MaterialPageRoute(builder: (_) => const MapPickerScreen()),
  //   );
  //   if (result != null) {
  //     setState(() => _selectedLocation = result);
  //   }
  // }

  String _locationLabel = '';

  Future<void> _openMapPicker() async {
    final result = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(builder: (_) => const MapPickerScreen()),
    );
    if (result != null) {
      setState(() => _selectedLocation = result);
      // reverse geocode
      try {
        final placemarks = await placemarkFromCoordinates(
          result.latitude,
          result.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          setState(() {
            _locationLabel =
                '${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}'
                    .replaceAll(RegExp(r'^,\s*|,\s*$'), '')
                    .trim();
          });
        }
      } catch (e) {
        setState(
          () => _locationLabel =
              '${result.latitude.toStringAsFixed(4)}, ${result.longitude.toStringAsFixed(4)}',
        );
      }
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
            .map(
              (e) =>
                  DropdownMenuItem(value: e['value'], child: Text(e['label']!)),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  void _handleNext() {
    if (selectedBrandId == null ||
        selectedCondition == null ||
        _selectedLocation == null ||
        _descriptionCtrl.text.isEmpty ||
        _cpuCtrl.text.isEmpty ||
        _storageCtrl.text.isEmpty ||
        _ramCtrl.text.isEmpty ||
        _screenCtrl.text.isEmpty ||
        _batteryCtrl.text.isEmpty ||
        _cameraCtrl.text.isEmpty ||
        _usedForCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields and select a location'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    AppRoutes.push(
      context,
      PostFormScreenThree(
        title: widget.title,
        photoPath: widget.photoPath,
        brand: selectedBrandId!,
        condition: selectedCondition!,
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
        description: _descriptionCtrl.text.trim(),
        cpu: _cpuCtrl.text.trim(),
        storage: _storageCtrl.text.trim(),
        ram: _ramCtrl.text.trim(),
        screen: _screenCtrl.text.trim(),
        battery: _batteryCtrl.text.trim(),
        camera: _cameraCtrl.text.trim(),
        usedFor: _usedForCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Post Ad',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Section
              Row(
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 64,
                          height: 64,
                          child: CircularProgressIndicator(
                            value: 2 / 3,
                            strokeWidth: 7,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF5F6675),
                            ),
                          ),
                        ),
                        const Text(
                          '2 of 3',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A5568),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Next Step: Price & Location',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFB0B7C3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Brand Dropdown from API
              categoryState.status == CategoryStatus.loading
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 14),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF1565D8),
                        ),
                      ),
                    )
                  : _buildDropdown(
                      'Select Brand *',
                      categoryState.categories
                          .map(
                            (e) => {
                              'label': e.name,
                              'value': e.categoryId ?? '',
                            },
                          )
                          .toList(),
                      selectedBrandId,
                      (value) => setState(() => selectedBrandId = value),
                    ),

              _buildDropdown(
                'Condition *',
                conditions,
                selectedCondition,
                (value) => setState(() => selectedCondition = value),
              ),

              // Map Picker
              GestureDetector(
                onTap: _openMapPicker,
                child: Container(
                  height: 56,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(
                      color: _selectedLocation != null
                          ? const Color(0xFF1565D8)
                          : Colors.grey.shade400,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(
                        _selectedLocation != null
                            ? Icons.location_on
                            : Icons.location_on_outlined,
                        color: _selectedLocation != null
                            ? const Color(0xFF1565D8)
                            : const Color(0xFF7A7A7A),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _selectedLocation != null
                              ? _locationLabel.isNotEmpty
                                    ? _locationLabel
                                    : 'Location selected'
                              : 'Tap to select location',
                          style: TextStyle(
                            color: _selectedLocation != null
                                ? const Color(0xFF1565D8)
                                : const Color(0xFF7A7A7A),
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Color(0xFF7A7A7A),
                      ),
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

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _handleNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565D8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Next',
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
