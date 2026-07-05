import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatTile extends StatelessWidget {
  final String? image;
  final String phoneName;
  final String senderName;
  final String lastMessage;
  final Timestamp? lastMessageTime;
  final bool unread;
  final VoidCallback? onTap;

  const ChatTile({
    super.key,
    this.image,
    required this.phoneName,
    required this.senderName,
    required this.lastMessage,
    this.lastMessageTime,
    this.unread = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final initial = senderName.isNotEmpty ? senderName[0].toUpperCase() : '?';
    final timeStr = lastMessageTime != null
        ? timeago.format(lastMessageTime!.toDate())
        : '';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFF1565D8),
              backgroundImage: image != null ? NetworkImage(image!) : null,
              child: image == null
                  ? Text(
                      initial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          senderName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Text(
                        timeStr,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 3),

                  Text(
                    phoneName,
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                      if (unread)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        )
                      else
                        const Icon(
                          Icons.done_all,
                          color: Colors.blue,
                          size: 18,
                        ),
                    ],
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
