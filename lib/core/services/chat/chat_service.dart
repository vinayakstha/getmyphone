import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatServiceProvider = Provider<ChatService>((ref) => ChatService());

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // generate consistent chat ID from two user IDs and phone ID
  String getChatId(String userId1, String userId2, String phoneId) {
    final sortedIds = [userId1, userId2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}_$phoneId';
  }

  // send a message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String message,
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

    // update chat metadata
    await _firestore.collection('chats').doc(chatId).set({
      'lastMessage': message,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'participants': chatId.split('_').take(2).toList(),
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
