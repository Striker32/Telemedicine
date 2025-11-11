import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:last_telemedicine/components/ChatMessage.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Определение типа пользователя + выгрузка данных
  Future<Map<String, dynamic>?> fetchRecieverData(String uid) async {
    // Проверка в doctors
    final doctorDoc = await _firestore.collection('doctors').doc(uid).get();
    if (doctorDoc.exists) return doctorDoc.data();

    // Проверка в users
    final userDoc = await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists) return userDoc.data();

    // Не найден
    return null;
  }

  // Отправка сообщения
  Future<void> sendMessage(
    String recieverID,
    senderID,
    requestID,
    message,
  ) async {
    // создание нового сообщения
    ChatMessage newMessage = ChatMessage(
      senderID: senderID,
      recieverID: recieverID,
      requestID: requestID,
      message: message,
      createdAt: FieldValue.serverTimestamp(),
      isRead: false, // Мб потом поменять, хз пока че с этим делать
    );

    // отправка нового сообщения в БД
    await _firestore
        .collection("chat_rooms")
        .doc(requestID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // Получение сообщения
  Stream<QuerySnapshot> getMessages(String requestID) {
    return _firestore
        .collection("chat_rooms")
        .doc(requestID)
        .collection("messages")
        .orderBy("createdAt", descending: false)
        .snapshots();
  }
}
