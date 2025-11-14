import 'package:cloud_firestore/cloud_firestore.dart';

/// Модель заявки
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Модель заявки
class RequestModel {
  final String id;
  final String userUid;
  final String status; // '0','1','2','3' или другой формат
  final List<Map<String, dynamic>> doctors; // список врачей
  final String reason;
  final String description;
  final String city;
  final String price;
  final String specializationRequested;
  final String? selectedDoctorUid;
  final bool urgent;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  RequestModel({
    required this.id,
    required this.userUid,
    required this.status,
    required this.doctors,
    required this.reason,
    required this.description,
    required this.city,
    required this.price,
    required this.specializationRequested,
    required this.selectedDoctorUid,
    this.urgent = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Проверка: откликнулся ли конкретный доктор
  bool hasResponded(String doctorUid) {
    return doctors.any((doc) => doc['uid'] == doctorUid);
  }

  factory RequestModel.fromMap(String id, Map<String, dynamic> map) {
    final rawDoctors = map['doctorUids'];

    List<Map<String, dynamic>> parsedDoctors = [];
    if (rawDoctors is List) {
      parsedDoctors = rawDoctors
          .whereType<Map<String, dynamic>>() // берём только Map
          .toList();
    }

    return RequestModel(
      id: id,
      userUid: map['userUid']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
      doctors: parsedDoctors,
      reason: map['reason']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      city: map['city']?.toString() ?? '',
      price: map['price']?.toString() ?? '',
      urgent: map['urgent'] ?? false,
      specializationRequested: map['specializationRequested']?.toString() ?? '',
      createdAt: map['createdAt'] as Timestamp?,
      updatedAt: map['updatedAt'] as Timestamp?,
      selectedDoctorUid: map['selectedDoctorUid']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userUid': userUid,
      'status': status,
      'doctorUids': doctors, // всегда список Map
      'reason': reason,
      'description': description,
      'specializationRequested': specializationRequested,
      'city': city,
      'price': price,
      'urgent': urgent,
      'updatedAt': FieldValue.serverTimestamp(),
      'selectedDoctorUid': selectedDoctorUid,
    };
  }

  List<String> get doctorUids {
    return doctors
        .map((doc) => doc['uid']?.toString())
        .where((uid) => uid != null && uid.isNotEmpty)
        .cast<String>()
        .toList();
  }

  bool get isOpen => status == '0' || status.toLowerCase() == 'open';
  bool get isAssigned => status == '1' || status.toLowerCase() == 'assigned';
  bool get isClosed => status == '2' || status.toLowerCase() == 'closed';
  bool get isArchived => status == '3' || status.toLowerCase() == 'archived';
}

/// Сериализация doctorUids в поле doctorUid.
/// Формат: если несколько — сохраняем как Map {uid: true, ...} (удобно для атомарных set/tx),
/// если ровно один — сохраняем как String для совместимости.
class RequestRepository {
  final FirebaseFirestore _db;
  CollectionReference get _col => _db.collection('requests');

  RequestRepository({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  Future<RequestModel?> getRequest(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return RequestModel.fromMap(doc.id, doc.data()! as Map<String, dynamic>);
  }

  Stream<RequestModel?> watchRequest(String id) {
    return _col.doc(id).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return RequestModel.fromMap(doc.id, doc.data()! as Map<String, dynamic>);
    });
  }

  Stream<List<RequestModel>> watchRequestsByUser(String userUid) {
    return _col
        .where('userUid', isEqualTo: userUid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (d) => RequestModel.fromMap(
                  d.id,
                  d.data()! as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  Stream<List<RequestModel>> watchRequestsByStatus(String status) {
    return _col
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (d) => RequestModel.fromMap(
                  d.id,
                  d.data()! as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  Future<String> createRequest(RequestModel model) async {
    final docRef = _col.doc();
    final id = docRef.id;
    await docRef.set({
      ...model.toMap(),
      'id': id,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    return id;
  }

  Future<void> updateRequest(
    String id,
    Map<String, dynamic> patch, {
    String? doctorUid,
  }) async {
    final data = {...patch, 'updatedAt': FieldValue.serverTimestamp()};
    final isStatus2 = patch['status']?.toString() == '2';

    if (isStatus2 && doctorUid != null && doctorUid.isNotEmpty) {
      final doctorRef = _db.collection('doctors').doc(doctorUid);
      final doctorSnap = await doctorRef.get();

      String completedStr = '0';
      if (doctorSnap.exists) {
        final raw = (doctorSnap.data() ?? {})['completed'];
        if (raw != null) completedStr = raw.toString();
      }

      final completedInt = (int.tryParse(completedStr) ?? 0) + 1;
      await doctorRef.set({
        'completed': completedInt.toString(),
      }, SetOptions(merge: true));

      await _col.doc(id).set(data, SetOptions(merge: true));
      return;
    }

    await _col.doc(id).set(data, SetOptions(merge: true));
  }

  Future<void> deleteRequest(String id) async {
    final chatRoomsCol = _db.collection('chat_rooms');

    // Ссылка на документ chat_rooms/{requestId}
    final chatRoomDocRef = chatRoomsCol.doc(id);

    // Удаляем подколлекцию messages порциями (batchSize <= 500)
    const int batchSize = 400;
    final messagesCol = chatRoomDocRef.collection('messages');

    while (true) {
      final msgSnap = await messagesCol.limit(batchSize).get();
      if (msgSnap.docs.isEmpty) break;
      final batch = _db.batch();
      for (final m in msgSnap.docs) batch.delete(m.reference);
      await batch.commit();
      if (msgSnap.docs.length < batchSize) break;
    }

    // Удаляем сам документ chat_rooms/{requestId} (он теперь пуст)
    await chatRoomDocRef.delete();

    // Наконец удаляем документ в коллекции requests
    await _col.doc(id).delete();
  }

  Future<List<RequestModel>> getRequestsPage({
    required String status,
    DocumentSnapshot? startAfter,
    int limit = 10,
  }) async {
    Query q = _db
        .collection('requests')
        .where('status', isEqualTo: status)
        .orderBy('updatedAt', descending: true)
        .limit(limit);

    if (startAfter != null) {
      q = q.startAfterDocument(startAfter);
    }

    final snap = await q.get();
    return snap.docs
        .map(
          (d) => RequestModel.fromMap(d.id, d.data()! as Map<String, dynamic>),
        )
        .toList();
  }

  /// Добавление или удаление врача
  Future<void> assignDoctorAtomically({
    required String requestId,
    required Map<String, dynamic> doctorData,
    bool keepMultiple = false,
    bool remove = false,
    bool select = false, // новый флаг: выбор врача
    String? newStatus, // статус при выборе (например '1' = назначен)
  }) async {
    final ref = _col.doc(requestId);
    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) throw Exception('Request not found');

      final data = snap.data() as Map<String, dynamic>;
      final rawDoctors = data['doctorUids'] as List? ?? [];

      List<Map<String, dynamic>> currentList = rawDoctors
          .whereType<Map<String, dynamic>>()
          .toList();

      if (remove) {
        // удаляем врача по uid
        currentList = currentList
            .where((d) => d['uid'] != doctorData['uid'])
            .toList();

        tx.set(ref, {
          'doctorUids': currentList,
          'selectedDoctorUid': null, // если удаляем выбранного — очищаем
          'status': '0', // возвращаем в "открыта"
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        return;
      }

      if (select) {
        // выбираем врача
        if (!currentList.any((d) => d['uid'] == doctorData['uid'])) {
          // если его ещё нет в списке — добавляем
          currentList.add(doctorData);
        }

        tx.set(ref, {
          'doctorUids': currentList,
          'selectedDoctorUid': doctorData['uid'],
          'status': newStatus ?? '1', // по умолчанию "назначен"
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        return;
      }

      if (keepMultiple) {
        // добавляем, если ещё нет
        if (!currentList.any((d) => d['uid'] == doctorData['uid'])) {
          currentList.add(doctorData);
        }
        tx.set(ref, {
          'doctorUids': currentList,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } else {
        // заменяем на одного врача
        tx.set(ref, {
          'doctorUids': [doctorData],
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    });
  }
}
