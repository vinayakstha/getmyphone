import 'package:client/app/routes/app_routes.dart';
import 'package:client/core/api/api_endpoints.dart';
import 'package:client/core/services/storage/user_session_service.dart';
import 'package:client/core/utils/snackbar_utils.dart';
import 'package:client/features/chat/presentation/pages/chat_screen.dart';
import 'package:client/features/phone/presentation/state/phone_state.dart';
import 'package:client/features/phone/presentation/view_model/phone_view_model.dart';
import 'package:client/features/phone/presentation/widgets/seller_profile_widget.dart';
import 'package:client/features/rating/presentation/view_model/rating_view_model.dart';
import 'package:client/features/saved/presentation/view_model/saved_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';

class PhoneDetailsScreen extends ConsumerStatefulWidget {
  final String phoneId;

  const PhoneDetailsScreen({super.key, required this.phoneId});

  @override
  ConsumerState<PhoneDetailsScreen> createState() => _PhoneDetailsScreenState();
}

class _PhoneDetailsScreenState extends ConsumerState<PhoneDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(phoneViewModelProvider.notifier)
          .getPhoneById(widget.phoneId),
    );
  }

  void _showSellerBottomSheet(BuildContext context) {
    final phone = ref.read(phoneViewModelProvider).selectedPhone!;
    final sessionService = ref.read(userSessionServiceProvider);
    final currentUserId = sessionService.getUserId();
    final isSelf = currentUserId == phone.sellerId;
    double selectedRating = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: const EdgeInsets.all(24),
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
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: phone.sellerProfilePicture != null
                    ? NetworkImage(
                        ApiEndpoints.imageBaseUrl + phone.sellerProfilePicture!,
                      )
                    : null,
                child: phone.sellerProfilePicture == null
                    ? const Icon(Icons.person, size: 40, color: Colors.grey)
                    : null,
              ),
              const SizedBox(height: 12),
              Text(
                phone.sellerName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    '${phone.sellerRatingAverage.toStringAsFixed(1)} (${phone.sellerRatingCount} reviews)',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (isSelf) ...[
                const Text(
                  'You cannot rate yourself',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ] else ...[
                const Text(
                  'Rate this seller',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () => setState(() => selectedRating = index + 1.0),
                      child: Icon(
                        index < selectedRating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 40,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: selectedRating == 0
                        ? null
                        : () async {
                            Navigator.pop(context);
                            await ref
                                .read(ratingViewModelProvider.notifier)
                                .submitRating(
                                  targetId: phone.sellerId,
                                  score: selectedRating,
                                );
                            await ref
                                .read(phoneViewModelProvider.notifier)
                                .getPhoneById(phone.phoneId ?? '');
                            if (context.mounted) {
                              SnackbarUtils.showSuccess(
                                context,
                                'Rating submitted successfully!',
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565D8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Submit Rating',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final phoneState = ref.watch(phoneViewModelProvider);
    final phone = phoneState.selectedPhone;

    if (phone == null || phoneState.status == PhoneStatus.loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF1565D8)),
        ),
      );
    }

    final savedState = ref.watch(savedViewModelProvider);
    final isBookmarked = savedState.savedPhoneIds.contains(phone.phoneId);

    final lat = phone.location.coordinates.length >= 2
        ? phone.location.coordinates[1]
        : 27.7172;
    final lng = phone.location.coordinates.isNotEmpty
        ? phone.location.coordinates[0]
        : 85.3240;

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          phone.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  final session = ref.read(userSessionServiceProvider);
                  final currentUserId = session.getUserId() ?? '';
                  if (currentUserId == phone.sellerId) {
                    SnackbarUtils.showError(
                      context,
                      'You cannot chat with yourself',
                    );
                    return;
                  }
                  AppRoutes.push(
                    context,
                    ChatScreen(
                      receiverId: phone.sellerId,
                      receiverName: phone.sellerName,
                    ),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text("Chat"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  foregroundColor: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.call),
                label: const Text("Call"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565D8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: phone.photo != null
                        ? Image.network(
                            ApiEndpoints.imageBaseUrl + phone.photo!,
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 220,
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.phone_android,
                                size: 80,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : Container(
                            height: 220,
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.phone_android,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'NPR ${phone.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Share.share(
                            'Check out this phone on GetMyPhone!\n${phone.title}\nNPR ${phone.price.toStringAsFixed(0)}',
                          );
                        },
                        icon: const Icon(Icons.share_outlined),
                      ),
                      IconButton(
                        onPressed: () async {
                          await ref
                              .read(savedViewModelProvider.notifier)
                              .toggleSave(phone.phoneId ?? '');
                          ref
                              .read(savedViewModelProvider.notifier)
                              .getSavedByUser();
                        },
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked
                              ? const Color(0xFF1565D8)
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Chip(
                        label: Text(phone.condition),
                        backgroundColor: Colors.blue.shade50,
                        labelStyle: const TextStyle(color: Color(0xff3E5EA8)),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(
                          phone.negotiable == 'yes'
                              ? 'Negotiable'
                              : 'Non Negotiable',
                        ),
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            SellerProfileWidget(
              name: phone.sellerName,
              ratingAverage: phone.sellerRatingAverage,
              ratingCount: phone.sellerRatingCount,
              profilePicture: phone.sellerProfilePicture != null
                  ? ApiEndpoints.imageBaseUrl + phone.sellerProfilePicture!
                  : null,
              onTap: () => _showSellerBottomSheet(context),
            ),

            const SizedBox(height: 12),

            Container(
              color: Colors.white,
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Color(0xFF1565D8),
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: "Details"),
                        Tab(text: "Location"),
                      ],
                    ),
                    SizedBox(
                      height: 420,
                      child: TabBarView(
                        children: [
                          SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Description",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(phone.description),
                                const SizedBox(height: 12),
                                Bullet(text: 'Used for: ${phone.usedFor}'),
                                const SizedBox(height: 20),
                                const Text(
                                  "Specifications",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                GridView.count(
                                  crossAxisCount: 2,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  childAspectRatio: 2.8,
                                  children: [
                                    SpecItem(title: "CPU", value: phone.cpu),
                                    SpecItem(
                                      title: "Battery",
                                      value: phone.battery,
                                    ),
                                    SpecItem(title: "RAM", value: phone.ram),
                                    SpecItem(
                                      title: "Screen",
                                      value: phone.screen,
                                    ),
                                    SpecItem(
                                      title: "Camera",
                                      value: phone.camera,
                                    ),
                                    SpecItem(
                                      title: "Storage",
                                      value: phone.storage,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(lat, lng),
                              initialZoom: 15,
                              interactionOptions: const InteractionOptions(
                                flags: InteractiveFlag.none,
                              ),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.client',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: LatLng(lat, lng),
                                    width: 50,
                                    height: 50,
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Color(0xFF1565D8),
                                      size: 46,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class Bullet extends StatelessWidget {
  final String text;
  const Bullet({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class SpecItem extends StatelessWidget {
  final String title;
  final String value;
  const SpecItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
