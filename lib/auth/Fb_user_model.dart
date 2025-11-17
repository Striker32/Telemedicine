import 'dart:typed_data';

import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:last_telemedicine/components/Notification.dart';
import 'package:last_telemedicine/components/Notification_global.dart';

class UserRepository {
  final _db = FirebaseFirestore.instance;

  Future<UserModel> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return UserModel.fromMap(doc.data()!);
  }

  Stream<UserModel?> watchUser(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }

      try {
        return UserModel.fromMap(doc.data()!);
      } catch (e, stacktrace) {
        debugPrint('Ошибка маппинга UserModel: $e');
        debugPrint('Stacktrace: $stacktrace');
        return null; // Возвращаем null, чтобы не было краша
      }
    });
  }

  // ← добавлен метод обновления
  Future<void> updateUser(String uid, Map<String, dynamic> patch) async {
    final data = {...patch, 'updatedAt': FieldValue.serverTimestamp()};
    await _db.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }
}

class UserModel {
  final String name;
  final String surname;
  final String realEmail;
  final String phone;
  final String city;

  final Blob? avatar;

  UserModel({
    required this.name,
    required this.surname,
    required this.realEmail,
    required this.phone,
    required this.city,
    this.avatar,
  });

  static Blob? _parseAvatar(dynamic avatarRaw) {
    try {
      if (avatarRaw == null) return null;

      if (avatarRaw is Blob) return avatarRaw;

      // Иногда Firestore кладёт Map с ключом _byteString
      if (avatarRaw is Map<String, dynamic>) {
        final bs = avatarRaw['_byteString'];
        if (bs == null) return null;

        // Если приходит base64-строка
        if (bs is String) {
          try {
            final bytes = base64Decode(bs);
            return Blob(bytes);
          } catch (_) {
            // не base64 — как fallback попробуем codeUnits (мало вероятно коректно)
            try {
              return Blob(Uint8List.fromList(bs.codeUnits));
            } catch (e) {
              showGlobalNotification(
                'avatar: failed to decode String _byteString: $e',
              );
              return null;
            }
          }
        }

        // Если приходит список чисел
        if (bs is List) {
          try {
            final listInt = bs.cast<int>();
            return Blob(Uint8List.fromList(listInt));
          } catch (e) {
            showGlobalNotification(
              'avatar: failed to cast List _byteString: $e',
            );
            return null;
          }
        }

        // Если в map лежат щё другие варианты, попробуем найти 'bytes'
        final alt = avatarRaw['bytes'] ?? avatarRaw['value'];
        if (alt is List) {
          try {
            return Blob(Uint8List.fromList(alt.cast<int>()));
          } catch (e) {
            showGlobalNotification('avatar: failed to parse alt bytes: $e');
          }
        }
      }

      // Если приходит прямо List<int>
      if (avatarRaw is List<int>) return Blob(Uint8List.fromList(avatarRaw));

      // На крайний случай — если пришла строка (возможно base64 без _byteString)
      if (avatarRaw is String) {
        try {
          return Blob(base64Decode(avatarRaw));
        } catch (e) {
          showGlobalNotification(
            'avatar: failed to base64Decode top-level String: $e',
          );
        }
      }

      showGlobalNotification(
        'Неожиданный тип avatar: ${avatarRaw.runtimeType}',
      );
      return null;
    } catch (e) {
      showGlobalNotification('Ошибка парсинга avatar общий catch: $e');
      return null;
    }
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final parsedAvatar = _parseAvatar(map['avatar']);
    return UserModel(
      name: map['name'] ?? '',
      surname: map['surname'] ?? '',
      realEmail: map['realEmail'] ?? '',
      phone: map['phone'] ?? '',
      city: map['city'] ?? '',
      avatar: parsedAvatar,
    );
  }
}

Future<void> updateUser(String uid, Map<String, dynamic> patch) async {
  final data = {...patch, 'updatedAt': FieldValue.serverTimestamp()};
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .set(data, SetOptions(merge: true));
}
