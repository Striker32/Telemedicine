// lib/Services/Notification/ChatListenerService.dart

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'NotificationService.dart';

class ChatListenerService {
  StreamSubscription? _chatSubscription;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Начинаем прослушивание
  void startListening(String currentUserId) {
    stopListening();
    print(
      "Начинаю прослушивание новых сообщений для пользователя: $currentUserId",
    );

    _chatSubscription = _firestore
        .collectionGroup('messages')
        .where('recieverID', isEqualTo: currentUserId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
          for (var docChange in snapshot.docChanges) {
            if (docChange.type.name == 'added') {
              print("Обнаружено новое сообщение!");
              _onNewMessageReceived(docChange.doc);
            }
          }
        });
  }

  // Обработчик нового сообщения
  Future<void> _onNewMessageReceived(DocumentSnapshot messageDoc) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      final freshMessageDoc = await messageDoc.reference.get();
      if (!freshMessageDoc.exists) return;

      final messageData = freshMessageDoc.data() as Map<String, dynamic>;
      final bool isRead = messageData['isRead'] ?? false;
      if (isRead) {
        print(
          "Сообщение ${freshMessageDoc.id} было прочитано. Уведомление отменено.",
        );
        return;
      }

      final senderID = messageData['senderID'];
      final messageText = messageData['message'];
      final requestID = messageData['requestID'];
      final receiverID = messageData['recieverID'];

      // 1. ПОЛУЧАЕМ ТОЛЬКО ИМЯ ОТПРАВИТЕЛЯ для уведомления
      final senderName = await _getUserName(senderID);

      // Показываем уведомление
      await NotificationService().showMessageNotification(
        title: senderName,
        body: messageText,
        // 2. ФОРМИРУЕМ ПРОСТОЙ PAYLOAD. Аватар больше не передаем.
        payload: 'chat:$requestID:$receiverID:$senderID',
      );
    } catch (e) {
      print("Ошибка при повторной проверке сообщения: $e");
    }
  }

  // 3. УПРОЩЕННАЯ ФУНКЦИЯ, ВОЗВРАЩАЕТ ТОЛЬКО ИМЯ (String)
  Future<String> _getUserName(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('doctors')
          .doc(userId)
          .get();
      if (!doc.exists) {
        doc = await _firestore.collection('users').doc(userId).get();
      }

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}".trim();
      }
    } catch (e) {
      print("Ошибка при получении имени пользователя: $e");
    }
    return 'Неизвестный';
  }

  // Останавливаем прослушивание
  void stopListening() {
    print("Останавливаю прослушивание сообщений.");
    _chatSubscription?.cancel();
    _chatSubscription = null;
  }
}
