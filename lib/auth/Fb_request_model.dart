import 'package:cloud_firestore/cloud_firestore.dart';

/// Модель данных доктора
class BidModel {
  final String uid;
  final String userUid;
  final String reason;
  final String description;
  final String city;
  final String price;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const BidModel({
    required this.uid,
    required this.userUid,
    required this.reason,
    required this.description,
    required this.city,
    required this.price,

    this.createdAt,
    this.updatedAt,
  });

  factory BidModel.fromMap(String uid, Map<String, dynamic> map) {
    return BidModel(
      uid: uid,
      userUid: map['userUid'] ?? '',
      reason: map['reason'] ?? '',
      description: map['description'] ?? '',
      city: map['city'] ?? '',
      price: map['price'] ?? '',
      createdAt: map['createdAt'] as Timestamp?,
      updatedAt: map['updatedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'price': price,

      // createdAt/updatedAt устанавливаются в репозитории через FieldValue.serverTimestamp()
    };
  }
}