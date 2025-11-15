// D:/IT projects/last_telemedicine/lib/Services/Notification/Listener_call_listener_service.dart

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
// 1. ДОБАВЛЯЕМ ИМПОРТ REALTIME DATABASE
import 'package:firebase_database/firebase_database.dart';
import 'package:last_telemedicine/Services/Notification/NotificationService.dart'; // Убедитесь, что путь верный

class ListenerCallListenerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // 2. СОЗДАЕМ ЭКЗЕМПЛЯР REALTIME DATABASE
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Оставляем подписки как приватные поля класса
  StreamSubscription? _callSubscription;
  StreamSubscription? _callerPresenceSubscription;

  void startListening(String myId) {
    // Останавливаем предыдущие слушатели, если они были
    stopListening();
    print("CallListenerService: Начинаю прослушивание звонков для $myId");

    // Ваш запрос к Firestore для поиска входящих звонков
    // (Я использую примерный запрос, у вас он может быть другим)
    _callSubscription = _firestore.collection('requests')
        .where('doctorId', isEqualTo: myId) // Пример вашего фильтра
        .snapshots()
        .listen((snapshot) {

      // При каждом новом событии от Firestore, отменяем старую проверку статуса
      _callerPresenceSubscription?.cancel();

      // Ищем первый документ, где есть активный звонок
      final callDocs = snapshot.docs.where((doc) => doc.data()['isCalling'] == true).toList();

      if (callDocs.isEmpty) {
        return; // Нет активных звонков, выходим
      }

      final callDoc = callDocs.first;
      final data = callDoc.data();
      final String? callerId = data['callerId'];

      if (callerId != null) {
        print("CallListenerService: Обнаружен флаг звонка от $callerId. Проверяю его онлайн-статус...");

        // 3. ПОДПИСЫВАЕМСЯ НА ОНЛАЙН-СТАТУС ЗВОНЯЩЕГО В REALTIME DATABASE
        // Путь 'presence/$callerId/online' должен соответствовать тому,
        // что записывает ваш PresenceService
        _callerPresenceSubscription = _database.ref('presence/$callerId/online').onValue.listen((event) {

          // Проверяем значение: оно должно быть именно true
          final bool isCallerOnline = event.snapshot.value == true;

          // 4. ПРИНИМАЕМ РЕШЕНИЕ
          if (isCallerOnline) {
            // Звонящий онлайн + флаг isCalling=true. ЭТО РЕАЛЬНЫЙ ЗВОНОК!
            print("CallListenerService: Звонящий онлайн. Показываю уведомление.");
            // Вызываем ваш сервис уведомлений
            NotificationService().showCallNotification(
              title: 'Входящий звонок',
              body: 'Вам звонят...',
              payload: 'call:${callDoc.id}',
            );
          } else {
            // Звонящий оффлайн! ЭТО "ФАНТОМНЫЙ" ЗВОНОК.
            print("CallListenerService: Звонящий оффлайн. Сбрасываю 'фантомный' звонок.");
            // САМОСТОЯТЕЛЬНО СБРАСЫВАЕМ ФЛАГИ В FIRESTORE
            callDoc.reference.update({
              'isCalling': false,
              'callerId': null,
            });
          }
        });
      }
    });
  }

  void stopListening() {
    print("CallListenerService: Останавливаю прослушивание.");
    // Важно отменять обе подписки
    _callSubscription?.cancel();
    _callerPresenceSubscription?.cancel();
  }
}
