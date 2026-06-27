import 'package:client/core/api/api_endpoints.dart';
import 'package:client/features/home/presentation/state/category_state.dart';
import 'package:client/features/home/presentation/view_model/catetory_view_model.dart';
import 'package:client/features/home/presentation/widgets/banner_card.dart';
import 'package:client/features/home/presentation/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(categoryViewModelProvider.notifier).getAllCategories(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP BAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(text: "get"),
                        TextSpan(
                          text: "my",
                          style: TextStyle(color: Color(0xFF0464D4)),
                        ),
                        TextSpan(text: "phone"),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Color.fromARGB(255, 118, 116, 116),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // SEARCH BAR
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Search for models, brands, or parts...",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const CardWidget(),

              const SizedBox(height: 16),

              // CATEGORIES LABEL
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Browse by Brand",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "View More",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(255, 118, 116, 116),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // CATEGORY GRID
              Expanded(child: _buildCategoryGrid(categoryState)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(CategoryState categoryState) {
    if (categoryState.status == CategoryStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF0464D4)),
      );
    }

    if (categoryState.status == CategoryStatus.error) {
      return Center(
        child: Text(
          categoryState.errorMessage ?? 'Failed to load categories',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (categoryState.categories.isEmpty) {
      return const Center(child: Text('No categories found'));
    }

    return GridView.builder(
      itemCount: categoryState.categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final category = categoryState.categories[index];
        return CategoryCard(
          imagePath: ApiEndpoints.imageBaseUrl + category.image,
          category: category.name,
          categoryId: category.categoryId ?? '',
        );
      },
    );
  }
}
