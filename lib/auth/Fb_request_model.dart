import 'package:cloud_firestore/cloud_firestore.dart';

/// Модель заявки
class RequestModel {
  final String id;
  final String userUid; // кто открыл заявку
  final String status; // статус как строка ('0','1','2' или 'open','assigned','closed' и т.д.)
  final List<String> doctorUids; // нормализованное представление: 0..n doctor uid
  final String reason;
  final String description;
  final String city;
  final String price;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  RequestModel({
    required this.id,
    required this.userUid,
    required this.status,
    required this.doctorUids,
    required this.reason,
    required this.description,
    required this.city,
    required this.price,
    this.createdAt,
    this.updatedAt,
  });

  /// Фабрика из данных Firestore
  /// map может содержать:
  /// - doctorUid: String (один доктор)
  /// - doctorUid: List<dynamic> (массив uid)
  /// - doctorUid: Map<String, dynamic> (реже) — попытаемся извлечь значимые значения
  factory RequestModel.fromMap(String id, Map<String, dynamic> map) {
    // нормализация doctorUid в List<String>
    List<String> parseDoctorField(dynamic raw) {
      if (raw == null) return <String>[];
      if (raw is String) return <String>[raw];
      if (raw is List) {
        return raw.where((e) => e != null).map((e) => e.toString()).toList();
      }
      if (raw is Map) {
        // возможный случай: {'doc1': true, 'doc2': true}
        return raw.keys.map((k) => k.toString()).toList();
      }
      return <String>[];
    }

    return RequestModel(
      id: id,
      userUid: map['userUid']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
      doctorUids: parseDoctorField(map['doctorUid'] ?? map['doctorUids']),
      reason: map['reason']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      city: map['city']?.toString() ?? '',
      price: map['price']?.toString() ?? '',
      createdAt: map['createdAt'] as Timestamp?,
      updatedAt: map['updatedAt'] as Timestamp?,
    );
  }

  /// Сериализация обратно в map для записи в Firestore.
  /// По умолчанию doctorUids сериализуются как List<String> если их больше одного,
  /// либо как String если только один — это помогает совместимости с существующей БД.
  Map<String, dynamic> toMap({bool preferListForDoctors = true}) {
    final doctorField = () {
      if (doctorUids.isEmpty) return null;
      if (doctorUids.length == 1 && !preferListForDoctors) return doctorUids.first;
      return doctorUids;
    }();

    final m = <String, dynamic>{
      'userUid': userUid,
      'status': status,
      if (doctorField != null) 'doctorUid': doctorField,
      'reason': reason,
      'description': description,
      'city': city,
      'price': price,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // createdAt обычно ставится при создании в репозитории
    return m;
  }

  /// Удобные геттеры для фронта
  bool get isOpen => status == '0' || status.toLowerCase() == 'open';
  bool get isAssigned => status == '1' || status.toLowerCase() == 'assigned';
  bool get isClosed => status == '2' || status.toLowerCase() == 'closed';

  /// Если назначен ровно один доктор, возвращает его uid, иначе null
  String? get singleDoctorUid => doctorUids.length == 1 ? doctorUids.first : null;
}


/// Репозиторий для работы с коллекцией requests
class RequestRepository {
  final FirebaseFirestore _db;
  CollectionReference get _col => _db.collection('requests');

  RequestRepository({FirebaseFirestore? firestore}) : _db = firestore ?? FirebaseFirestore.instance;

  /// Получить заявку один раз
  Future<RequestModel?> getRequest(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return RequestModel.fromMap(doc.id, doc.data()! as Map<String, dynamic>);
  }

  /// Подписка на одну заявку
  Stream<RequestModel?> watchRequest(String id) {
    return _col.doc(id).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return RequestModel.fromMap(doc.id, doc.data()! as Map<String, dynamic>);
    });
  }

  /// Подписка на все заявки пользователя (удобно для списка "мои заявки")
  Stream<List<RequestModel>> watchRequestsByUser(String userUid) {
    return _col.where('userUid', isEqualTo: userUid).orderBy('createdAt', descending: true).snapshots().map(
          (snap) => snap.docs.map((d) => RequestModel.fromMap(d.id, d.data()! as Map<String, dynamic>)).toList(),
    );
  }

  /// Подписка на открытые заявки (status == '0')
  Stream<List<RequestModel>> watchOpenRequests() {
    return _col.where('status', isEqualTo: '0').orderBy('createdAt', descending: true).snapshots().map(
          (snap) => snap.docs.map((d) => RequestModel.fromMap(d.id, d.data()! as Map<String, dynamic>)).toList(),
    );
  }

  /// Создать новую заявку (создаёт createdAt и updatedAt)
  Future<String> createRequest(RequestModel model) async {
    final docRef = _col.doc();
    final data = model.toMap(preferListForDoctors: true);
    await docRef.set({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    return docRef.id;
  }

  /// Частичный апдейт заявки (merge)
  Future<void> updateRequest(String id, Map<String, dynamic> patch) async {
    final data = {
      ...patch,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await _col.doc(id).set(data, SetOptions(merge: true));
  }

  /// Атомарное назначение доктора:
  /// Если статус == '0' (open) — добавляет доктора в список (если нужно несколько)
  /// Если нужно назначить одного доктора и перевести статус в '1' (assigned) — используем transaction
  Future<void> assignDoctorAtomically({
    required String requestId,
    required String doctorUid,
    required String newStatus, // например '1'
    bool keepMultiple = false, // если true и статус == '0' — добавим к списку, иначе заменим
  }) async {
    final ref = _col.doc(requestId);
    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) throw Exception('Request not found');

      final data = snap.data() as Map<String, dynamic>;
      final currentStatus = data['status']?.toString() ?? '';
      final rawDoctor = data['doctorUid'];

      // нормализуем текущий список докторов
      List<String> current = [];
      if (rawDoctor is String) current = [rawDoctor];
      else if (rawDoctor is List) current = rawDoctor.map((e) => e.toString()).toList();
      else if (rawDoctor is Map) current = rawDoctor.keys.map((k) => k.toString()).toList();

      if (currentStatus == '0' && keepMultiple) {
        // добавляем доктора в список (если нет)
        if (!current.contains(doctorUid)) current.add(doctorUid);
        tx.set(ref, {
          'doctorUid': current,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } else {
        // заменяем на одного доктора и обновляем статус
        tx.set(ref, {
          'doctorUid': doctorUid,
          'status': newStatus,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    });
  }
}

