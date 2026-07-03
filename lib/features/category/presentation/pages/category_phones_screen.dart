import 'package:client/app/routes/app_routes.dart';
import 'package:client/core/api/api_endpoints.dart';
import 'package:client/features/category/presentation/state/category_phone_state.dart';
import 'package:client/features/category/presentation/view_model/category_phone_view_model.dart';
import 'package:client/features/phone/presentation/pages/phone_details_screen.dart';
import 'package:client/features/phone/presentation/widgets/phone_card.dart';
import 'package:client/features/saved/presentation/view_model/saved_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryPhonesScreen extends ConsumerStatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryPhonesScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  ConsumerState<CategoryPhonesScreen> createState() =>
      _CategoryPhonesScreenState();
}

class _CategoryPhonesScreenState extends ConsumerState<CategoryPhonesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(categoryPhoneViewModelProvider.notifier)
          .getPhonesByBrand(widget.categoryId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final phoneState = ref.watch(categoryPhoneViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(child: _buildBody(phoneState)),
    );
  }

  Widget _buildBody(CategoryPhoneState phoneState) {
    if (phoneState.status == CategoryPhoneStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF0464D4)),
      );
    }

    if (phoneState.status == CategoryPhoneStatus.error) {
      return Center(
        child: Text(
          phoneState.errorMessage ?? 'Failed to load listings',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (phoneState.phones.isEmpty) {
      return Center(
        child: Text(
          'No listings found for ${widget.categoryName}',
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    final savedState = ref.watch(savedViewModelProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: phoneState.phones.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          final phone = phoneState.phones[index];
          return PhoneCard(
            image: phone.photo != null
                ? ApiEndpoints.imageBaseUrl + phone.photo!
                : '',
            condition: phone.condition,
            title: phone.title,
            specs: '${phone.ram} RAM • ${phone.storage}',
            price: 'NPR ${phone.price.toStringAsFixed(0)}',
            isBookmarked: savedState.savedPhoneIds.contains(phone.phoneId),
            onTap: () {
              AppRoutes.push(
                context,
                PhoneDetailsScreen(phoneId: phone.phoneId ?? ''),
              );
            },
            onBookmark: () async {
              await ref
                  .read(savedViewModelProvider.notifier)
                  .toggleSave(phone.phoneId ?? '');
            },
          );
        },
      ),
    );
  }
}
