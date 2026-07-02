import 'package:flutter/material.dart';

class SellerProfileWidget extends StatelessWidget {
  final String name;
  final double ratingAverage;
  final int ratingCount;
  final String? profilePicture;
  final VoidCallback? onTap;

  const SellerProfileWidget({
    super.key,
    required this.name,
    required this.ratingAverage,
    required this.ratingCount,
    this.profilePicture,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: profilePicture != null
              ? NetworkImage(profilePicture!)
              : null,
          backgroundColor: Colors.grey.shade200,
          child: profilePicture == null
              ? const Icon(Icons.person, color: Colors.grey)
              : null,
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Row(
          children: [
            const Icon(Icons.star, size: 16, color: Colors.amber),
            const SizedBox(width: 4),
            Text(
              '${ratingAverage.toStringAsFixed(1)} ($ratingCount reviews)',
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
