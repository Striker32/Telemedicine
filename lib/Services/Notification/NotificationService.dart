// lib/Services/notification_service.dart

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:last_telemedicine/Services/Videocall_page.dart'; // Путь к вашему экрану звонка

class NotificationService {
  // Создаем синглтон, чтобы был только один экземпляр этого сервиса
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  // Метод для инициализации
  Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // Ваша иконка приложения

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotifications.initialize(
      initializationSettings,
      // Этот обработчик сработает, когда пользователь нажмет на уведомление
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null && response.payload!.startsWith('call:')) {
          final channelName = response.payload!.substring(5); // Убираем префикс 'call:'
          print("Нажато уведомление о звонке! Переходим на канал: $channelName");

          // Используем глобальный ключ для навигации
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => VideoCallPage(channelName: channelName),
            ),
          );
        }
      },
    );
  }

  // Метод для показа уведомления
  Future<void> showCallNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'incoming_calls_channel', // ID канала
      'Входящие звонки',       // Имя, которое пользователь увидит в настройках
      channelDescription: 'Уведомления о входящих видеозвонках.',
      importance: Importance.high, // Обязательно для всплывающего уведомления
      priority: Priority.high,     // Обязательно для всплывающего уведомления
      sound: RawResourceAndroidNotificationSound('ringtone'), // Укажите имя вашего рингтона без расширения (если он есть)
    );

    const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      0,       // ID уведомления. Для звонков всегда можно использовать 0, чтобы новое заменяло старое
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
    