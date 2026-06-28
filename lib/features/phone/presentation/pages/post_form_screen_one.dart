import 'package:client/app/routes/app_routes.dart';
import 'package:client/features/phone/presentation/pages/post_form_screen_two.dart';
import 'package:flutter/material.dart';

class PostFormScreenOne extends StatefulWidget {
  const PostFormScreenOne({super.key});

  @override
  State<PostFormScreenOne> createState() => _PostFormScreenOneState();
}

class _PostFormScreenOneState extends State<PostFormScreenOne> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
              /// Progress Section
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
                            value: 1 / 3,
                            strokeWidth: 7,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF5F6675),
                            ),
                          ),
                        ),
                        const Text(
                          '1 of 3',
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
                        'Upload Photo',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A5568),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Next Step: Details',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFB0B7C3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 36),

              /// Title Field
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Ad Title *',
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
                ),
              ),

              const SizedBox(height: 28),

              /// Upload Box
              GestureDetector(
                onTap: () {
                  // Pick image
                },
                child: Container(
                  width: 120,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey.shade400,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add, size: 46, color: Color(0xFF555555)),
                      SizedBox(height: 14),
                      Text(
                        'Add Images.',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// Edit Photo Text
              Row(
                children: const [
                  Icon(Icons.edit_outlined, size: 20, color: Color(0xFF6B7280)),
                  SizedBox(width: 10),
                  Text(
                    'Tap photo to edit.',
                    style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                  ),
                ],
              ),

              const Spacer(),

              /// Next Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    AppRoutes.push(context, const PostFormScreenTwo(title: ''));
                  },
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
