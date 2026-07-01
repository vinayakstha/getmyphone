import 'package:client/app/routes/app_routes.dart';
import 'package:client/features/category/presentation/pages/category_phones_screen.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.imagePath,
    required this.category,
    required this.categoryId,
  });

  final String imagePath;
  final String category;
  final String categoryId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRoutes.push(
          context,
          CategoryPhonesScreen(categoryId: categoryId, categoryName: category),
        );
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(imagePath, height: 60, fit: BoxFit.contain),
            const SizedBox(height: 8),
            Text(
              category,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
