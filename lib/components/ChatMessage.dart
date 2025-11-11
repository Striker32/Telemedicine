import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String senderID;
  final String recieverID;
  final String requestID;
  final String message;
  final FieldValue createdAt;
  final bool isRead;

  const ChatMessage({
    required this.senderID,
    required this.recieverID,
    required this.requestID,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'recieverID': recieverID,
      'requestID': requestID,
      'message': message,
      'createdAt': createdAt,
      'isRead': isRead,
    };
  }
}
