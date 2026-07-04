import 'package:client/app/routes/app_routes.dart';
import 'package:client/core/api/api_endpoints.dart';
import 'package:client/core/services/storage/user_session_service.dart';
import 'package:client/features/auth/presentation/pages/login_screen.dart';
import 'package:client/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:client/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:client/features/profile/presentation/widgets/profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.read(userSessionServiceProvider);
    final fullName = session.getUserFullName() ?? 'User';
    final phoneNumber = session.getUserPhoneNumber() ?? '';
    final profilePicture = session.getUserProfilePicture();
    final ratingAverage = session.getUserRatingAverage();
    final ratingCount = session.getUserRatingCount();
    final initial = fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: const Color(0xff1565D8),
                      backgroundImage: profilePicture != null
                          ? NetworkImage(
                              ApiEndpoints.imageBaseUrl + profilePicture,
                            )
                          : null,
                      child: profilePicture == null
                          ? Text(
                              initial,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          phoneNumber,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              return Icon(
                                index < ratingAverage.floor()
                                    ? Icons.star
                                    : index < ratingAverage
                                    ? Icons.star_half
                                    : Icons.star_border,
                                color: const Color(0xffF4D03F),
                                size: 18,
                              );
                            }),
                            const SizedBox(width: 6),
                            Text(
                              '${ratingAverage.toStringAsFixed(1)} ($ratingCount)',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                // Menu Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ProfileTile(
                        icon: Icons.person_outline,
                        title: "Edit Profile",
                        onTap: () =>
                            AppRoutes.push(context, const EditProfileScreen()),
                      ),
                      ProfileTile(
                        icon: Icons.lock_outline,
                        title: "Change Password",
                        onTap: () {},
                      ),
                      ProfileTile(
                        icon: Icons.work_outline,
                        title: "My Posts",
                        onTap: () {},
                      ),
                      ProfileTile(
                        icon: Icons.notifications_none,
                        title: "Notifications",
                        onTap: () {},
                      ),
                      ProfileTile(
                        icon: Icons.headset_mic_outlined,
                        title: "Help & Support",
                        onTap: () {},
                      ),
                      ProfileTile(
                        icon: Icons.logout,
                        title: "Logout",
                        color: Colors.red,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Logout'),
                              content: const Text(
                                'Are you sure you want to logout?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'No',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await ref
                                        .read(authViewModelProvider.notifier)
                                        .logout();
                                    if (context.mounted) {
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (_) => const LoginScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
