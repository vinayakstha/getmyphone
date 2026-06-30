import 'package:flutter/material.dart';

class PhoneCard extends StatelessWidget {
  final String image;
  final String condition;
  final String title;
  final String specs;
  final String price;
  final VoidCallback? onTap;
  final VoidCallback? onBookmark;

  const PhoneCard({
    super.key,
    required this.image,
    required this.condition,
    required this.title,
    required this.specs,
    required this.price,
    this.onTap,
    this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xffD6DCE5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Image + Bookmark
            Stack(
              children: [
                Center(
                  child: SizedBox(
                    height: 110,
                    width: double.infinity,
                    child: image.isNotEmpty
                        ? Image.network(
                            image,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.phone_android,
                                  size: 60,
                                  color: Color(0xffD6DCE5),
                                ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              );
                            },
                          )
                        : const Icon(
                            Icons.phone_android,
                            size: 60,
                            color: Color(0xffD6DCE5),
                          ),
                  ),
                ),

                Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                    onTap: onBookmark,
                    child: const Icon(
                      Icons.bookmark_border,
                      color: Color(0xff444B59),
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// Condition
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

            const SizedBox(height: 8),

            /// Title
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xff2C2C2C),
              ),
            ),

            const SizedBox(height: 4),

            /// Specs
            Text(
              specs,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Color(0xff707070)),
            ),

            const SizedBox(height: 4),

            /// Price
            Text(
              price,
              style: const TextStyle(
                fontSize: 16,
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
