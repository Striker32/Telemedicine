// lib/Services/Notification/NotificationService.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:last_telemedicine/Services/Videocall_page.dart';

import '../../pages/Chat.dart';

class NotificationService {
  // --- Реализация паттерна Синглтон (Singleton) ---
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();
  // ---------------------------------------------------

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  GlobalKey<NavigatorState>? _navigatorKey;

  Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    _navigatorKey = navigatorKey;

    // Используем вашу кастомную иконку для уведомлений
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          // 1. Запрашиваем разрешения (это у вас уже было)
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,

          // 2. Указываем, что нужно показывать уведомление,
          //    даже если приложение в этот момент открыто (foreground)
          defaultPresentAlert: true,
          defaultPresentBadge: true,
          defaultPresentSound: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      // 2. Универсальный обработчик нажатий на уведомления
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload == null) return;

        final payload = response.payload!;

        // --- Обработка нажатия на уведомление о ЗВОНКЕ ---
        if (payload.startsWith('call:')) {
          final channelName = payload.substring(5);
          print(
            "Нажато уведомление о звонке! Перехожу на VideoCallPage с каналом: $channelName",
          );
          _navigatorKey?.currentState?.push(
            MaterialPageRoute(
              builder: (context) => VideoCallPage(channelName: channelName),
            ),
          );
        }
        // --- Обработка нажатия на уведомление о СООБЩЕНИИ ---
        else if (payload.startsWith('chat:')) {
          // payload: 'chat:requestID:receiverID:senderID'
          final parts = payload.split(':');

          // Частей теперь 4
          if (parts.length == 4) {
            final requestID = parts[1];
            final receiverID = parts[2];
            final senderID = parts[3];

            // _navigatorKey?.currentState?.push(
            //   MaterialPageRoute(
            //       builder: (context) => ChatScreen(
            //         requestID: requestID,
            //         recieverID: receiverID,
            //         senderID: senderID,
            //         // Аватар больше не передается отсюда.
            //         // ChatScreen должен сам его загрузить по ID.
            //       )),
            // );
          }
        }
      },
    );
  }

  // --- Метод для показа уведомлений о ЗВОНКАХ ---
  Future<void> showCallNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidBitmap<Object> largeIcon = DrawableResourceAndroidBitmap(
      '@mipmap/app_icon_color',
    );
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'incoming_calls_channel',
          'Входящие звонки',
          channelDescription: 'Уведомления о входящих видеозвонках.',
          importance: Importance.max,
          priority: Priority.high,
          //sound: RawResourceAndroidNotificationSound('ringtone'),
          playSound: true,
          // Основной цвет приложения для кружка под иконкой
          color: Colors.red,
          largeIcon: largeIcon,
        );

    // Добавляем детали для iOS
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true, // Показать баннер
      presentBadge: true, // Обновить бэдж (если нужно)
      presentSound: true, // Проиграть звук
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // ID = 0 для звонков
    await _localNotifications.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // 3. --- НОВЫЙ метод для показа уведомлений о СООБЩЕНИЯХ ---
  Future<void> showMessageNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidBitmap<Object> largeIcon = DrawableResourceAndroidBitmap(
      '@mipmap/app_icon_color',
    );
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'new_messages_channel', // Другой ID канала
          'Новые сообщения',
          channelDescription: 'Уведомления о новых сообщениях в чатах.',
          importance:
              Importance.defaultImportance, // Обычная важность, не как у звонка
          priority: Priority.defaultPriority,
          color: Colors.blue, // Другой цвет для кружка
          // Используем стандартный звук уведомлений, а не рингтон
          largeIcon: largeIcon,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    // ID = 1 для сообщений, чтобы не затирать уведомление о звонке
    await _localNotifications.show(
      DateTime.now()
          .millisecond, // Используем уникальный ID, чтобы сообщения не перезаписывали друг друга
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
