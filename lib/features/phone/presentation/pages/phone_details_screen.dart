import 'package:client/core/api/api_endpoints.dart';
import 'package:client/features/phone/domain/entities/phone_entity.dart';
import 'package:client/features/phone/presentation/widgets/seller_profile_widget.dart';
import 'package:client/features/saved/presentation/view_model/saved_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhoneDetailsScreen extends ConsumerWidget {
  final PhoneEntity phone;

  const PhoneDetailsScreen({super.key, required this.phone});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedState = ref.watch(savedViewModelProvider);
    final isBookmarked = savedState.savedPhoneIds.contains(phone.phoneId);

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
                onPressed: () {},
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
            // Image + Price + Condition
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
                        onPressed: () {},
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
                              : 'Fixed Price',
                        ),
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Seller Profile
            SellerProfileWidget(
              name: phone.seller,
              ratingAverage: 0,
              ratingCount: 0,
              onTap: () {},
            ),

            const SizedBox(height: 12),

            // Description + Location tabs
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
                        Tab(text: "Description"),
                        Tab(text: "Specs"),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(phone.description),
                          const SizedBox(height: 12),
                          Bullet(text: 'Used for: ${phone.usedFor}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Specifications
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Specifications",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 2.8,
                    children: [
                      SpecItem(title: "CPU", value: phone.cpu),
                      SpecItem(title: "Battery", value: phone.battery),
                      SpecItem(title: "RAM", value: phone.ram),
                      SpecItem(title: "Screen", value: phone.screen),
                      SpecItem(title: "Camera", value: phone.camera),
                      SpecItem(title: "Storage", value: phone.storage),
                    ],
                  ),
                ],
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
