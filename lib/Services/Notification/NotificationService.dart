import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  initFCM() async {
    final permission = await _firebaseMessaging.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.denied) {
      throw Exception('User has denied permission');
    }


    final fcmToken = await _firebaseMessaging.getToken();

    print('FCM token:  $fcmToken');
    
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // nor closed/back, nor in app
      print('Message: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // in app
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android:  AndroidNotificationDetails(
              'id insert here',
              'title insert here',
              channelDescription: 'description here',
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
//ИЗМЕНИТЬ ПУТЬ ВЫШЕ

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
    );

    await createLocalNotificationChannel;
  }

  Future <void> createLocalNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'id insert here',
      'title insert here',
      description: 'description here',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
    >()
        ?.createNotificationChannel(channel);

  }

}

onDidReceiveNotificationResponse (NotificationResponse details) {
  print('Details: $details');
}

onDidReceiveBackgroundNotificationResponse (NotificationResponse details) {
  print('Details: $details');
}