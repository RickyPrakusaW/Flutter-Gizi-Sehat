import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create or retrieve existing chat room
  Future<String> getChatRoomId(String userId, String doctorId) async {
    // Check if room exists
    final query = await _firestore
        .collection('chat_rooms')
        .where('users', arrayContains: userId)
        .get();

    for (var doc in query.docs) {
      final users = List<String>.from(doc['users']);
      if (users.contains(doctorId)) {
        return doc.id;
      }
    }

    // Create new room
    final docRef = await _firestore.collection('chat_rooms').add({
      'users': [userId, doctorId],
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  // Send message
  Future<void> sendMessage(String roomId, String senderId, String text,
      {String type = 'text', String? imageUrl}) async {
    await _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .add({
      'senderId': senderId,
      'text': text,
      'type': type,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Update last message in room
    String displayMessage = type == 'image' ? '📷 Image' : text;
    await _firestore.collection('chat_rooms').doc(roomId).update({
      'lastMessage': displayMessage,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  // Get messages stream
  Stream<QuerySnapshot> getMessages(String roomId) {
    return _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Get user's chat rooms
  Stream<QuerySnapshot> getUserChats(String userId) {
    return _firestore
        .collection('chat_rooms')
        .where('users', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }
}
