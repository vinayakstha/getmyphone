import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatServiceProvider = Provider<ChatService>((ref) => ChatService());

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // generate consistent chat ID from two user IDs and phone ID
  String getChatId(String userId1, String userId2) {
    final sortedIds = [userId1, userId2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }

  // send a message
Future<void> sendMessage({
  required String chatId,
  required String senderId,
  required String senderName,
  required String receiverId,
  required String receiverName,
  required String message,
  String? senderPhoto,
  String? receiverPhoto,
}) async {
  await _firestore
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .add({
    'senderId': senderId,
    'senderName': senderName,
    'message': message,
    'timestamp': FieldValue.serverTimestamp(),
  });

  await _firestore.collection('chats').doc(chatId).set({
    'lastMessage': message,
    'lastMessageTime': FieldValue.serverTimestamp(),
    'participants': [senderId, receiverId],
    '${senderId}_name': senderName,
    '${receiverId}_name': receiverName,
    if (senderPhoto != null) '${senderId}_photo': senderPhoto,
    if (receiverPhoto != null) '${receiverId}_photo': receiverPhoto,
  }, SetOptions(merge: true));
}

  // get messages stream
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // get all chats for a user
  Stream<QuerySnapshot> getUserChats(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }
}
