// lib/Services/Notification/Listener_call_listener_service.dart

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'NotificationService.dart';

class CallListenerService {
  // Теперь нам нужен только один StreamSubscription, так как запрос будет один
  StreamSubscription? _callSubscription;

  void startListening(String currentUserId) {
    // Останавливаем старую подписку на всякий случай
    stopListening();

    print("Начинаю прослушивание звонков для пользователя: $currentUserId");

    // --- ФОРМИРУЕМ ЕДИНЫЙ ЗАПРОС ---
    // Firestore не поддерживает логическое 'ИЛИ' в разных полях.
    // Самый надежный способ - слушать все активные звонки
    // и фильтровать их уже на стороне клиента.
    _callSubscription = FirebaseFirestore.instance
        .collection('requests') // Правильная коллекция
        .where('isCalling', isEqualTo: true) // Слушаем только активные звонки
        .snapshots()
        .listen((snapshot) {
      // Перебираем все заявки, в которых сейчас идет звонок
      for (var doc in snapshot.docs) {
        final requestData = doc.data();
        final userUid = requestData['userUid'];
        final selectedDoctorUid = requestData['selectedDoctorUid'];
        final callerId = requestData['callerId'];

        // --- ГЛАВНАЯ ЛОГИКА ФИЛЬТРАЦИИ ---
        // 1. Убеждаемся, что мы имеем отношение к этой заявке
        // 2. Убеждаемся, что звонящий - не мы сами
        bool isMyRequest = (userUid == currentUserId || selectedDoctorUid == currentUserId);
        bool isNotMyCall = (callerId != null && callerId != currentUserId);

        if (isMyRequest && isNotMyCall) {
          // Если оба условия верны, это входящий звонок для нас.
          // Передаем управление в _onCallReceived.
          _onCallReceived(doc);
          // Прерываем цикл, чтобы не показывать несколько уведомлений
          // если вдруг окажется несколько активных звонков (маловероятно, но надежно)
          break;
        }
      }
    });
  }

  // Общий обработчик для входящего звонка
  Future<void> _onCallReceived(DocumentSnapshot requestDoc) async {
    final requestData = requestDoc.data() as Map<String, dynamic>;

    final channelName = requestDoc.id; // ID заявки - это имя канала
    final callerId = requestData['callerId'] as String;

    // Получаем имя звонящего
    String callerName = await _getUserName(callerId);

    print("Обнаружен входящий звонок от $callerName по каналу $channelName!");

    NotificationService().showCallNotification(
      title: 'Входящий звонок',
      body: 'Вам звонит $callerName',
      payload: 'call:$channelName',
    );
  }

  // Вспомогательная функция для получения имени пользователя по его ID
  // (Остается без изменений, так как уже была исправлена)
  Future<String> _getUserName(String userId) async {
    try {
      var doc = await FirebaseFirestore.instance.collection('doctors').doc(userId).get();
      if (doc.exists) {
        final data = doc.data()!;
        return "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}".trim();
      }
      doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data()!;
        return "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}".trim();
      }
    } catch (e) {
      print("Ошибка при получении имени пользователя: $e");
    }
    return 'Неизвестный';
  }

  void stopListening() {
    print("Останавливаю прослушивание звонков.");
    _callSubscription?.cancel();
    _callSubscription = null;
  }
}
