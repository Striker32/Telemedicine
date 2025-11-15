// lib/Services/Notification/NotificationService.dart

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:last_telemedicine/Services/Videocall_page.dart'; // Убедитесь, что путь верный

class NotificationService {
  // 1. === СОЗДАЕМ ЕДИНСТВЕННЫЙ ЭКЗЕМПЛЯР ===
  // `static final` гарантирует, что этот объект будет создан только один раз.
  static final NotificationService _instance = NotificationService._internal();

  // 2. === СОЗДАЕМ "ФАБРИКУ" ДЛЯ ПОЛУЧЕНИЯ ЭКЗЕМПЛЯРА ===
  // Теперь, когда вы будете писать NotificationService(), вы всегда будете получать
  // один и тот же _instance, а не создавать новый.
  factory NotificationService() {
    return _instance;
  }

  // 3. === Приватный конструктор, чтобы никто не мог создать новый экземпляр случайно ===
  NotificationService._internal();

  // --- Остальной код остается почти без изменений ---

  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  GlobalKey<NavigatorState>? _navigatorKey;

  Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    _navigatorKey = navigatorKey;

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null && response.payload!.startsWith('call:')) {
          final channelName = response.payload!.substring(5);
          print("Нажато уведомление! Перехожу на VideoCallPage с каналом: $channelName");

          _navigatorKey?.currentState?.push(
            MaterialPageRoute(
              builder: (context) => VideoCallPage(channelName: channelName),
            ),
          );
        }
      },
    );
  }

  Future<void> showCallNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'incoming_calls_channel',
      'Входящие звонки',
      channelDescription: 'Уведомления о входящих видеозвонках.',
      importance: Importance.max,
      priority: Priority.high,
      //sound: RawResourceAndroidNotificationSound('ringtone'), // Убедитесь, что файл ringtone.mp3/wav есть в android/app/src/main/res/raw
      playSound: true,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
