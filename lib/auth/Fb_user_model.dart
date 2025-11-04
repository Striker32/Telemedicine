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
}

class UserModel {
  final String name;
  final String surname;
  final String email;
  final String phone;
  final String city;

  UserModel({
    required this.name,
    required this.surname,
    required this.email,
    required this.phone,
    required this.city,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      surname: map['surname'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      city: map['city'] ?? '',
    );
  }
}

