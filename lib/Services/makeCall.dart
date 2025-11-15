// lib/Services/makeCall.dart

import 'package:cloud_firestore/cloud_firestore.dart';
// 1. ДОБАВЛЯЕМ ИМПОРТЫ
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:last_telemedicine/Services/Videocall_page.dart';

Future<void> makeCall(BuildContext context, {required String applicationId}) async {
  if (applicationId.isEmpty) return;

  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return;

  // Ссылки на документы и узлы
  final docRef = FirebaseFirestore.instance.collection('requests').doc(applicationId);
  // 2. ССЫЛКА НА УЗЕЛ В REALTIME DATABASE ДЛЯ КОМАНДЫ onDisconnect
  final onDisconnectRef = FirebaseDatabase.instance.ref('disconnect_commands/${currentUser.uid}');

  try {
    // 3. УСТАНАВЛИВАЕМ КОМАНДУ onDisconnect ПЕРЕД НАЧАЛОМ ЗВОНКА
    // Эта команда выполнится на сервере, если приложение звонящего "умрет".
    // Она указывает путь в Firestore, который нужно обновить.
    await onDisconnectRef.set({
      'path': docRef.path, // Путь к документу в Firestore: 'requests/{applicationId}'
      'data': {
        'isCalling': false,
        'callerId': null,
      }
    });
    print("Команда onDisconnect для сброса звонка установлена в Realtime Database.");

    // Устанавливаем флаг звонка и ID звонящего
    await docRef.update({
      'isCalling': true,
      'callerId': currentUser.uid,
    });

    print("Отправлен сигнал к звонку. Переход на экран звонка с каналом: $applicationId");

    // Переходим на экран звонка
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoCallPage(channelName: applicationId),
      ),
    );

    // --- ЗВОНОК ЗАВЕРШЕН ШТАТНО ---

    // 4. УДАЛЯЕМ КОМАНДУ onDisconnect, так как она больше не нужна
    await onDisconnectRef.remove();
    print("Команда onDisconnect удалена.");

    // Снимаем флаг звонка штатным образом
    await docRef.update({
      'isCalling': false,
      'callerId': null,
    });
    print("Звонок завершен, флаг снят.");

  } catch (e) {
    print("Ошибка при попытке начать звонок: $e");
    // В случае ошибки тоже пытаемся все очистить
    await onDisconnectRef.remove();
    await docRef.update({
      'isCalling': false,
      'callerId': null,
    });
  }
}
