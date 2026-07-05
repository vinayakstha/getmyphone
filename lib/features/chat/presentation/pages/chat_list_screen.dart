import 'package:flutter/material.dart';
import '../widgets/chat_tile.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        title: const Text(
          "Chat",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            /// Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search conversations...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: const [
                  ChatTile(
                    image: "assets/images/iphone15.png",
                    phoneName: "iPhone 15 Pro",
                    senderName: "Michael Scott",
                    lastMessage: "Is the iPhone 15 Pro still available?",
                    time: "2m ago",
                    online: true,
                    unread: true,
                  ),

                  SizedBox(height: 10),

                  ChatTile(
                    image: "assets/images/samsung.png",
                    phoneName: "Samsung S24 Ultra",
                    senderName: "Sarah Jenkins",
                    lastMessage: "Thanks!",
                    time: "45m ago",
                    online: false,
                    unread: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
