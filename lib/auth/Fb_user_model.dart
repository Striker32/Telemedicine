import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class UserRepository {
  final _db = FirebaseFirestore.instance;

  Future<UserModel> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return UserModel.fromMap(doc.data()!);
  }


  Stream<UserModel> watchUser(String uid) {
    return _db.collection('users').doc(uid).snapshots().map(
          (doc) => UserModel.fromMap(doc.data()!),
    );
  }

  // ← добавлен метод обновления
  Future<void> updateUser(String uid, Map<String, dynamic> patch) async {
    final data = {
      ...patch,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await _db.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }
}


class UserModel {
  final String name;
  final String surname;
  final String realEmail;
  final String phone;
  final String city;

  UserModel({
    required this.name,
    required this.surname,
    required this.realEmail,
    required this.phone,
    required this.city,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      surname: map['surname'] ?? '',
      realEmail: map['realEmail'] ?? '',
      phone: map['phone'] ?? '',
      city: map['city'] ?? '',
    );
  }
}

Future<void> updateUser(String uid, Map<String, dynamic> patch) async {
  final data = {
    ...patch,
    'updatedAt': FieldValue.serverTimestamp(),
  };
  await FirebaseFirestore.instance.collection('users').doc(uid).set(data, SetOptions(merge: true));
}


