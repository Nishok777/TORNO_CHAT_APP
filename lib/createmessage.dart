// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';

// Initialize Firestore instance
FirebaseFirestore firestore = FirebaseFirestore.instance;
// Reference to the 'messages' collection
CollectionReference messagesCollection = firestore.collection('messages');

// Create a message document
void createMessage(String message, String senderId, String receiverId,
    String? senderName, String receiverName) async {
  try {
    await messagesCollection.add({
      'message': message,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderName': senderName,
      'receiverName': receiverName,
      'time': Timestamp.now(),
    });
  } catch (e) {
  }
}

// Call createMessage with parameters


