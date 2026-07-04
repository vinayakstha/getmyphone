import 'package:client/app/routes/app_routes.dart';
import 'package:client/core/api/api_endpoints.dart';
import 'package:client/features/phone/presentation/pages/phone_details_screen.dart';
import 'package:client/features/phone/presentation/state/phone_state.dart';
import 'package:client/features/phone/presentation/view_model/phone_view_model.dart';
import 'package:client/core/utils/snackbar_utils.dart';
import 'package:client/features/profile/presentation/widgets/my_post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPostsScreen extends ConsumerStatefulWidget {
  const MyPostsScreen({super.key});

  @override
  ConsumerState<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends ConsumerState<MyPostsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(phoneViewModelProvider.notifier).getPhonesBySeller(),
    );
  }

  void _showOptionsBottomSheet(BuildContext context, String phoneId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xFF1565D8),
                ),
                title: const Text('Edit Post'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: navigate to edit post screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Delete Post',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmDialog(context, phoneId);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, String phoneId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this listing?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(phoneViewModelProvider.notifier)
                  .deletePhone(phoneId);
              if (!mounted) return; // add this
              final phoneState = ref.read(phoneViewModelProvider);
              if (phoneState.status == PhoneStatus.deleted) {
                SnackbarUtils.showSuccess(
                  context,
                  'Listing deleted successfully!',
                );
                ref.read(phoneViewModelProvider.notifier).getPhonesBySeller();
              } else if (phoneState.status == PhoneStatus.error) {
                SnackbarUtils.showError(
                  context,
                  phoneState.errorMessage ?? 'Failed to delete listing',
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
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
          'My Posts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(child: _buildBody(phoneState)),
    );
  }

  Widget _buildBody(PhoneState phoneState) {
    if (phoneState.status == PhoneStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF1565D8)),
      );
    }

    if (phoneState.status == PhoneStatus.error) {
      return Center(
        child: Text(
          phoneState.errorMessage ?? 'Failed to load listings',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (phoneState.phones.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone_android, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No listings yet',
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
        itemCount: phoneState.phones.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          final phone = phoneState.phones[index];
          return MyPostCard(
            image: phone.photo != null
                ? ApiEndpoints.imageBaseUrl + phone.photo!
                : '',
            condition: phone.condition,
            title: phone.title,
            specs: '${phone.ram} RAM • ${phone.storage}',
            price: 'NPR ${phone.price.toStringAsFixed(0)}',
            onTap: () {
              AppRoutes.push(
                context,
                PhoneDetailsScreen(phoneId: phone.phoneId ?? ''),
              );
            },
            onOptions: () =>
                _showOptionsBottomSheet(context, phone.phoneId ?? ''),
          );
        },
      ),
    );
  }
}
