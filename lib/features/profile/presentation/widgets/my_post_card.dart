import 'package:flutter/material.dart';

class MyPostCard extends StatelessWidget {
  final String image;
  final String condition;
  final String title;
  final String specs;
  final String price;
  final VoidCallback? onTap;
  final VoidCallback? onOptions;

  const MyPostCard({
    super.key,
    required this.image,
    required this.condition,
    required this.title,
    required this.specs,
    required this.price,
    this.onTap,
    this.onOptions,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xffD6DCE5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + Options button
            Stack(
              children: [
                Center(
                  child: SizedBox(
                    height: 120,
                    child: image.startsWith('http')
                        ? Image.network(
                            image,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.phone_android,
                              size: 60,
                              color: Colors.grey,
                            ),
                          )
                        : const Icon(
                            Icons.phone_android,
                            size: 60,
                            color: Colors.grey,
                          ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onOptions,
                    child: const Icon(
                      Icons.more_vert,
                      size: 22,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Condition
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xffEAF1FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                condition,
                style: const TextStyle(
                  color: Color(0xff3E5EA8),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Title
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xff2C2C2C),
              ),
            ),

            const SizedBox(height: 4),

            // Specs
            Text(
              specs,
              style: const TextStyle(fontSize: 13, color: Color(0xff707070)),
            ),

            const SizedBox(height: 6),

            // Price
            Text(
              price,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF1565D8),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
