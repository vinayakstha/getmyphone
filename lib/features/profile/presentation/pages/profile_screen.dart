import 'package:client/features/profile/presentation/widgets/profile_tile.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // App Bar
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes back button
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
                /// Profile Header
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 38,
                      backgroundColor: Color(0xff1565D8),
                      child: Text(
                        "V",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Vinayak Shrestha",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "9808880705",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ...List.generate(
                              5,
                              (index) => const Icon(
                                Icons.star,
                                color: Color(0xffF4D03F),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              "5.0",
                              style: TextStyle(
                                fontSize: 16,
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

                /// Menu Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
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
                        onTap: () {},
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
                        onTap: () {},
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
