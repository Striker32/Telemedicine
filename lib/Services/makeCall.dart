// lib/Services/Notification/makeCall.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:last_telemedicine/Services/Videocall_page.dart';

Future<void> makeCall(BuildContext context, {required String applicationId}) async {
  if (applicationId.isEmpty) return;

  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return;

  try {
    // ИСПРАВЛЕНО: используем коллекцию 'requests'
    final docRef = FirebaseFirestore.instance.collection('requests').doc(applicationId);

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

    // Когда звонок завершен, снимаем флаг
    await docRef.update({
      'isCalling': false,
      'callerId': null, // Очищаем поле
    });
    print("Звонок завершен, флаг снят.");

  } catch (e) {
    print("Ошибка при попытке начать звонок: $e");
    // В случае ошибки тоже снимаем флаг
    await FirebaseFirestore.instance.collection('requests').doc(applicationId).update({
      'isCalling': false,
      'callerId': null,
    });
    // ... ваш код для показа ошибки пользователю
  }
}
