import 'dart:typed_data';

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Модель данных доктора
class DoctorModel {
  final String uid;
  final String name;
  final String surname;
  final String phone;
  final String realEmail; // поле, которое хранит "псевдо‑email" для Auth
  final String city;
  final String specialization;
  final String experience;
  final String placeOfWork;
  final String price;
  final String about;
  final String rating;
  final String rating_count;
  final String completed;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final Blob? avatar;

  const DoctorModel({
    required this.uid,
    required this.name,
    required this.surname,
    required this.phone,
    required this.realEmail,
    required this.city,
    required this.specialization,
    required this.experience,
    required this.placeOfWork,
    required this.price,
    required this.about,
    required this.rating,
    required this.rating_count,
    required this.completed,
    this.createdAt,
    this.updatedAt,
    this.avatar,
  });

  static Blob? _parseAvatar(dynamic avatarRaw) {
    try {
      if (avatarRaw == null) return null;
      if (avatarRaw is Blob) return avatarRaw;

      if (avatarRaw is List) {
        try {
          return _blobFromList(avatarRaw.cast<int>());
        } catch (e) {
          debugPrint('avatar: failed to cast top-level List to int: $e');
          return null;
        }
      }

      if (avatarRaw is Map) {
        final bs =
            avatarRaw['_byteString'] ??
            avatarRaw['bytes'] ??
            avatarRaw['value'] ??
            avatarRaw['data'] ??
            avatarRaw['raw'];
        if (bs != null) {
          if (bs is String) {
            try {
              return _blobFromBytes(Uint8List.fromList(base64Decode(bs)));
            } catch (_) {
              try {
                return _blobFromBytes(Uint8List.fromList(bs.codeUnits));
              } catch (e) {
                debugPrint('avatar: failed to decode String _byteString: $e');
                return null;
              }
            }
          }
          if (bs is List) {
            try {
              return _blobFromList(bs.cast<int>());
            } catch (e) {
              debugPrint(
                'avatar: failed to cast Map._byteString List to int: $e',
              );
              return null;
            }
          }
        }
      }

      if (avatarRaw is String) {
        try {
          return _blobFromBytes(Uint8List.fromList(base64Decode(avatarRaw)));
        } catch (e) {
          debugPrint('avatar: failed to base64Decode top-level String: $e');
        }
      }

      debugPrint('Неожиданный тип avatar: ${avatarRaw.runtimeType}');
      return null;
    } catch (e, st) {
      debugPrint('Ошибка парсинга avatar общий catch: $e\n$st');
      return null;
    }
  }

  // небольшой helper чтобы централизовать создание Blob — адаптируй конструктор под свою версию cloud_firestore
  static Blob? _blobFromBytes(Uint8List bytes) {
    try {
      // Конструктор Blob(Uint8List) есть в большинстве версий SDK
      return Blob(bytes);
    } catch (e) {
      debugPrint('Failed to construct Blob from bytes: $e');
      return null;
    }
  }

  static Blob? _blobFromList(List<int> list) {
    return _blobFromBytes(Uint8List.fromList(list));
  }

  factory DoctorModel.fromMap(String uid, Map<String, dynamic> map) {
    final parsedAvatar = _parseAvatar(map['avatar']);

    return DoctorModel(
      uid: uid,
      name: map['name'] ?? '',
      surname: map['surname'] ?? '',
      phone: map['phone'] ?? '',
      realEmail: map['realEmail'] ?? map['email'] ?? '',
      city: map['city'] ?? 'Не указан',
      specialization: map['specialization'] ?? 'Не указана',
      experience: map['experience'] ?? 'Не указано',
      placeOfWork: map['placeOfWork'] ?? 'Не указано',
      price: map['price'] ?? 'Не указано',
      about: map['about'] ?? '',
      createdAt: map['createdAt'] as Timestamp?,
      updatedAt: map['updatedAt'] as Timestamp?,
      avatar: parsedAvatar,
      rating: map['rating'] ?? '5',
      rating_count: map['rating_count'] ?? '10',
      completed: map['completed'] ?? '0',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
      'phone': phone,
      'realEmail': realEmail,
      'city': city,
      'specialization': specialization,
      'experience': experience,
      'placeOfWork': placeOfWork,
      'price': price,
      'about': about,
      'avatar': avatar,
      "rating": rating,
      'rating_count': rating_count,
      "completed": completed,
      // createdAt/updatedAt устанавливаются в репозитории через FieldValue.serverTimestamp()
    };
  }
}

/// Репозиторий для коллекции doctors
class DoctorRepository {
  final FirebaseFirestore _db;
  CollectionReference get _col => _db.collection('doctors'); // коллекция врачей

  DoctorRepository({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  Future<List<DoctorModel>> getDoctorsByUids(List<String> uids) async {
    if (uids.isEmpty) return [];
    final snap = await _col.where(FieldPath.documentId, whereIn: uids).get();
    return snap.docs
        .map(
          (d) => DoctorModel.fromMap(d.id, d.data()! as Map<String, dynamic>),
        )
        .toList();
  }

  /// Получить доктора однократно
  Future<DoctorModel?> getDoctor(String uid) async {
    final doc = await _col.doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return DoctorModel.fromMap(doc.id, doc.data()! as Map<String, dynamic>);
  }

  /// Подписка на изменения документа доктора
  Stream<DoctorModel?> watchDoctor(String uid) {
    return _col.doc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return DoctorModel.fromMap(doc.id, doc.data()! as Map<String, dynamic>);
    });
  }

  /// Частичное обновление полей доктора (update)
  Future<void> updateDoctor(String uid, Map<String, dynamic> patch) async {
    final data = {...patch, 'updatedAt': FieldValue.serverTimestamp()};
    await _col.doc(uid).set(data, SetOptions(merge: true));
  }

  /// Создать документ доктора (инициализация) — использует merge, чтобы не перезаписывать
  Future<void> createDoctor(String uid, DoctorModel model) async {
    final data = {
      ...model.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await _col.doc(uid).set(data, SetOptions(merge: true));
  }

  /// Upsert: создать если нет, иначе обновить
  Future<void> upsertDoctor(String uid, Map<String, dynamic> patch) async {
    final data = {...patch, 'updatedAt': FieldValue.serverTimestamp()};
    await _col.doc(uid).set(data, SetOptions(merge: true));
  }
}
