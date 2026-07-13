import 'package:client/app/routes/app_routes.dart';
import 'package:client/core/api/api_endpoints.dart';
import 'package:client/features/phone/presentation/pages/phone_details_screen.dart';
import 'package:client/features/phone/presentation/widgets/phone_card.dart';
import 'package:client/features/saved/presentation/state/saved_state.dart';
import 'package:client/features/saved/presentation/view_model/saved_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavedScreen extends ConsumerStatefulWidget {
  const SavedScreen({super.key});

  @override
  ConsumerState<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends ConsumerState<SavedScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(savedViewModelProvider.notifier).getSavedByUser(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final savedState = ref.watch(savedViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        title: const Text(
          "Saved",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),
      body: SafeArea(child: _buildBody(savedState)),
    );
  }

  Widget _buildBody(SavedState savedState) {
    if (savedState.status == SavedStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF1565D8)),
      );
    }

    if (savedState.status == SavedStatus.error) {
      return Center(
        child: Text(
          savedState.errorMessage ?? 'Failed to load saved listings',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (savedState.savedListings.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No saved listings yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: savedState.savedListings.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          final saved = savedState.savedListings[index];
          return PhoneCard(
            image: saved.phone.photo != null
                ? ApiEndpoints.getImageUrl(saved.phone.photo!)
                : '',
            condition: saved.phone.condition,
            title: saved.phone.title,
            specs: '${saved.phone.ram} RAM • ${saved.phone.storage}',
            price: 'NPR ${saved.phone.price.toStringAsFixed(0)}',
            isBookmarked: true,
            onTap: () {
              AppRoutes.push(
                context,
                PhoneDetailsScreen(phoneId: saved.phone.phoneId ?? ''),
              );
            },
            onBookmark: () async {
              await ref
                  .read(savedViewModelProvider.notifier)
                  .toggleSave(saved.phone.phoneId ?? '');
              ref.read(savedViewModelProvider.notifier).getSavedByUser();
            },
          );
        },
      ),
    );
  }
}
