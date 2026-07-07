import 'package:client/core/utils/snackbar_utils.dart';
import 'package:client/features/phone/domain/entities/phone_entity.dart';
import 'package:client/features/phone/presentation/state/phone_state.dart';
import 'package:client/features/phone/presentation/view_model/phone_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostFormScreenThree extends ConsumerStatefulWidget {
  final String title;
  final String? photoPath;
  final String brand;
  final String condition;
  final double latitude;
  final double longitude;
  final String description;
  final String cpu;
  final String storage;
  final String ram;
  final String screen;
  final String battery;
  final String camera;
  final String usedFor;

  const PostFormScreenThree({
    super.key,
    required this.title,
    this.photoPath,
    required this.brand,
    required this.condition,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.cpu,
    required this.storage,
    required this.ram,
    required this.screen,
    required this.battery,
    required this.camera,
    required this.usedFor,
  });

  @override
  ConsumerState<PostFormScreenThree> createState() =>
      _PostFormScreenThreeState();
}

class _PostFormScreenThreeState extends ConsumerState<PostFormScreenThree> {
  final _priceCtrl = TextEditingController();
  String? selectedNegotiable;

  final List<Map<String, String>> negotiableOptions = [
    {'label': 'Yes', 'value': 'yes'},
    {'label': 'No', 'value': 'no'},
  ];

  @override
  void dispose() {
    _priceCtrl.dispose();
    super.dispose();
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
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

  Future<void> _handlePostAd() async {
    if (selectedNegotiable == null || _priceCtrl.text.isEmpty) {
      SnackbarUtils.showError(context, 'Please fill in all fields');
      return;
    }

    final phone = PhoneEntity(
      title: widget.title,
      photo: widget.photoPath,
      brand: widget.brand,
      condition: widget.condition,
      location: LocationEntity(
        type: 'Point',
        coordinates: [widget.longitude, widget.latitude],
      ),
      description: widget.description,
      cpu: widget.cpu,
      storage: widget.storage,
      ram: widget.ram,
      screen: widget.screen,
      battery: widget.battery,
      camera: widget.camera,
      usedFor: widget.usedFor,
      negotiable: selectedNegotiable!,
      price: double.parse(_priceCtrl.text.trim()),
      sellerId: '',
      sellerName: '',
    );

    await ref
        .read(phoneViewModelProvider.notifier)
        .createPhone(phone, photoPath: widget.photoPath);
  }

  @override
  Widget build(BuildContext context) {
    final phoneState = ref.watch(phoneViewModelProvider);

    ref.listen<PhoneState>(phoneViewModelProvider, (previous, next) {
      if (previous?.status != next.status) {
        if (next.status == PhoneStatus.error) {
          SnackbarUtils.showError(
            context,
            next.errorMessage ?? 'Something went wrong',
          );
        } else if (next.status == PhoneStatus.created) {
          SnackbarUtils.showSuccess(context, 'Phone ad posted successfully!');
          // pop all post form screens back to navigation screen
          ref.read(phoneViewModelProvider.notifier).getAllPhones();
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    });

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
        child: Padding(
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
                            value: 3 / 3,
                            strokeWidth: 7,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF5F6675),
                            ),
                          ),
                        ),
                        const Text(
                          '3 of 3',
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
                        'Price',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A5568),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Last Step!',
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

              _buildDropdown(
                'Negotiable *',
                negotiableOptions,
                selectedNegotiable,
                (value) => setState(() => selectedNegotiable = value),
              ),

              _buildTextField(
                'Price (NPR) *',
                _priceCtrl,
                keyboardType: TextInputType.number,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: phoneState.status == PhoneStatus.loading
                      ? null
                      : _handlePostAd,
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
                          'Post Ad',
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
