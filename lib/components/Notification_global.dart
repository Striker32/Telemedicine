// ui_notifications.dart
import 'package:flutter/material.dart';
import 'package:last_telemedicine/components/Notification.dart';
import '../main.dart' show navigatorKey;

void showGlobalNotification(String text) {
  // Попробуем получить наиболее подходящий контекст:
  final navState = navigatorKey.currentState;
  final ctx = navState?.overlay?.context ?? navigatorKey.currentContext;

  if (ctx == null) {
    // Нет доступного UI контекста — логируем и выходим
    debugPrint('showGlobalNotification: no context available, message: $text');
    return;
  }

  // showCustomNotification сама проверяет mounted/context внутри
  showCustomNotification(ctx, text);
}
