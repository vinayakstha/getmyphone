import 'package:client/app/routes/app_routes.dart';
import 'package:client/core/api/api_endpoints.dart';
import 'package:client/core/services/chat/chat_service.dart';
import 'package:client/core/services/storage/user_session_service.dart';
import 'package:client/features/chat/presentation/pages/chat_screen.dart';
import 'package:client/features/chat/presentation/widgets/chat_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.read(userSessionServiceProvider);
    final currentUserId = session.getUserId() ?? '';
    final chatService = ref.read(chatServiceProvider);

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
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search conversations...",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 15,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 22,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: chatService.getUserChats(currentUserId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1565D8),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No conversations yet',
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

                  final chats = snapshot.data!.docs;

                  return ListView.separated(
                    itemCount: chats.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final data = chats[index].data() as Map<String, dynamic>;

                      // get other participant
                      final participants = List<String>.from(
                        data['participants'] ?? [],
                      );
                      final otherUserId = participants.firstWhere(
                        (id) => id != currentUserId,
                        orElse: () => '',
                      );

                      final otherUserName =
                          data['${otherUserId}_name'] ?? 'Unknown';
                      final otherUserPhoto =
                          data['${otherUserId}_photo'] as String?;
                      final lastMessage = data['lastMessage'] ?? '';
                      final lastMessageTime =
                          data['lastMessageTime'] as Timestamp?;

                      return ChatTile(
                        image: otherUserPhoto != null
                            ? ApiEndpoints.getImageUrl(otherUserPhoto)
                            : null,
                        senderName: otherUserName,
                        lastMessage: lastMessage,
                        lastMessageTime: lastMessageTime,
                        onTap: () {
                          AppRoutes.push(
                            context,
                            ChatScreen(
                              receiverId: otherUserId,
                              receiverName: otherUserName,
                              receiverPhoto: otherUserPhoto,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
