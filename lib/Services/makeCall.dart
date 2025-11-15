// lib/Services/makeCall.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:last_telemedicine/Services/Videocall_page.dart';

Future<void> makeCall(BuildContext context, {required String applicationId}) async {
  if (applicationId.isEmpty) return;

  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return;

  final docRef = FirebaseFirestore.instance.collection('requests').doc(applicationId);

  try {
    // 1. Просто устанавливаем флаги в Firestore. Всю проверку сделает получатель.
    await docRef.update({
      'isCalling': true,
      'callerId': currentUser.uid,
    });

    print("Отправлен сигнал к звонку. Переход на экран звонка.");

    // 2. Переходим на экран звонка
    if (context.mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoCallPage(channelName: applicationId),
        ),
      );
    }

    // 3. Когда звонок завершен штатно, просто сбрасываем флаги
    await docRef.update({
      'isCalling': false,
      'callerId': null,
    });
    print("Звонок завершен, флаг снят.");

  } catch (e) {
    print("Ошибка при попытке начать звонок: $e");
    // В случае ошибки тоже пытаемся все очистить
    await docRef.update({'isCalling': false, 'callerId': null});
  }
}
