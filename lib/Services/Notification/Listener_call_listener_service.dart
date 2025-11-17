// lib/Services/Notification/Listener_call_listener_service.dart

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'NotificationService.dart';

class CallListenerService {
  StreamSubscription? _callSubscription;

  // 1. === ИСПРАВЛЕНИЕ: СОЗДАЕМ ЭКЗЕМПЛЯР ПЛАГИНА ===
  // Эта строка создает "пульт управления" уведомлениями, который мы будем использовать ниже.
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 2. === ИСПРАВЛЕНИЕ: ДЕЛАЕМ МЕТОД АСИНХРОННЫМ (`async`) ===
  void startListening(String currentUserId) async {
    stopListening();

    // 3. === ТЕПЕРЬ ЭТОТ КОД РАБОТАЕТ ===
    // Запрашиваем разрешение у пользователя
    bool? granted = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    print("Разрешение на уведомления предоставлено: $granted");

    if (granted == false) {
      // Если пользователь отказал, нет смысла слушать звонки.
      print(
        "Пользователь отказал в разрешении на уведомления. Прослушивание не начнется.",
      );
      return;
    }

    print("Начинаю прослушивание звонков для пользователя: $currentUserId");

    // --- Остальной код остается без изменений ---
    _callSubscription = FirebaseFirestore.instance
        .collection('requests')
        .where('isCalling', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
          for (var doc in snapshot.docs) {
            final requestData = doc.data();
            final userUid = requestData['userUid'];
            final selectedDoctorUid = requestData['selectedDoctorUid'];
            final callerId = requestData['callerId'];

            bool isMyRequest =
                (userUid == currentUserId ||
                selectedDoctorUid == currentUserId);
            bool isNotMyCall = (callerId != null && callerId != currentUserId);

            if (isMyRequest && isNotMyCall) {
              _onCallReceived(doc);
              break;
            }
          }
        });
  }

  // Общий обработчик для входящего звонка (без изменений)
  Future<void> _onCallReceived(DocumentSnapshot requestDoc) async {
    final requestData = requestDoc.data() as Map<String, dynamic>;
    final channelName = requestDoc.id;
    final reason = requestData['reason'] as String;
    final callerId = requestData['callerId'] as String;
    String callerName = await _getUserName(callerId);

    print("Обнаружен входящий звонок от $callerName по каналу $channelName!");

    await NotificationService().showCallNotification(
      title: 'Входящий звонок',
      body: 'Вам звонит $callerName по заявке $reason',
      payload: 'call:$channelName',
    );

    try {
      await requestDoc.reference.update({
        'isCalling': false,
        'callerId': null, // FieldValue.delete() также хороший вариант
      });
      print("Флаги звонка для заявки $channelName немедленно сброшены.");
    } catch (e) {
      print("Ошибка при сбросе флагов звонка: $e");
    }
  }

  // Вспомогательная функция для получения имени (без изменений)
  Future<String> _getUserName(String userId) async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(userId)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        return "${data['name'] ?? ''} ${data['surname'] ?? ''}".trim();
      }
      doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        return "${data['name'] ?? ''} ${data['surname'] ?? ''}".trim();
      }
    } catch (e) {
      print("Ошибка при получении имени пользователя: $e");
    }
    return 'Неизвестный';
  }

  // Метод остановки (без изменений)
  void stopListening() {
    print("Останавливаю прослушивание звонков.");
    _callSubscription?.cancel();
    _callSubscription = null;
  }
}
