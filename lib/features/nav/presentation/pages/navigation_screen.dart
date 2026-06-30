import 'package:client/app/routes/app_routes.dart';
import 'package:client/features/home/presentation/pages/home_screen.dart';
import 'package:client/features/phone/presentation/pages/post_form_screen_one.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Scaffold(body: Center(child: Text('Chat'))),
    const Scaffold(body: Center(child: Text('Saved'))),
    const Scaffold(body: Center(child: Text('Profile'))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex >= 2 ? _selectedIndex + 1 : _selectedIndex,
        onTap: (index) {
          if (index == 2) {
            AppRoutes.push(context, const PostFormScreenOne());
            return;
          }
          final screenIndex = index > 2 ? index - 1 : index;
          setState(() => _selectedIndex = screenIndex);
        },
        selectedItemColor: const Color(0xFF1565D8),
        unselectedItemColor: Color.fromARGB(255, 118, 116, 116),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark),
            label: "Saved",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
