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

      // Уже Blob
      if (avatarRaw is Blob) return avatarRaw;

      // Если верхнеуровневый список байтов
      if (avatarRaw is List) {
        try {
          final listInt = avatarRaw.cast<int>();
          return Blob(Uint8List.fromList(listInt));
        } catch (e) {
          showGlobalNotification(
            'avatar: failed to cast top-level List to int: $e',
          );
          return null;
        }
      }

      // Map с разными вариантами сериализации
      if (avatarRaw is Map) {
        // Вариант _byteString может быть String (base64) или List
        final bs =
            avatarRaw['_byteString'] ??
            avatarRaw['bytes'] ??
            avatarRaw['value'];
        if (bs != null) {
          // base64 строка
          if (bs is String) {
            // иногда _byteString может быть "List<int>" в виде строки — попробуем base64 сначала
            try {
              final bytes = base64Decode(bs);
              return Blob(Uint8List.fromList(bytes));
            } catch (_) {
              // fallback: если строка — вероятно codeUnits, но это редко; логируем
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

          // список чисел внутри map
          if (bs is List) {
            try {
              final listInt = bs.cast<int>();
              return Blob(Uint8List.fromList(listInt));
            } catch (e) {
              showGlobalNotification(
                'avatar: failed to cast Map._byteString List to int: $e',
              );
              return null;
            }
          }
        }

        // Дополнительные поля: возможно просто поле 'data'/'raw'
        final alt = avatarRaw['data'] ?? avatarRaw['raw'];
        if (alt is List) {
          try {
            return Blob(Uint8List.fromList(alt.cast<int>()));
          } catch (e) {
            showGlobalNotification('avatar: failed to parse alt bytes: $e');
          }
        }
      }

      // Если пришла строка (возможно base64 без обёртки)
      if (avatarRaw is String) {
        try {
          return Blob(Uint8List.fromList(base64Decode(avatarRaw)));
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
    } catch (e, st) {
      showGlobalNotification('Ошибка парсинга avatar общий catch: $e\n$st');
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
