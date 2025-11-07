import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
      // case 'user-not-found':
      // throw 'Пользователь с таким email не найден.';
      // case 'wrong-password':
      // throw 'Неверный пароль.';
      // case 'invalid-email':
      // throw 'Некорректный формат email адреса.';
      // case 'user-disabled':
      // throw 'Аккаунт этого пользователя отключен.';
      // default:
      // throw 'Произошла неизвестная ошибка. Попробуйте снова.';
    }
  }
  // sign up
  Future<UserCredential> signUpUserWithEmailPassword({
    required String pseudoemail,
    required String password,
    required String phone,
    required String name,
    required String surname,
   // required String role,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: pseudoemail,
        password: password,
      );

      // создаём документ в Firestore
      await _db.collection('users').doc(userCredential.user!.uid).set({
        'phone': phone,
        'realEmail': 'Не указана',
        'name' : name,
        'surname' : surname,
        'city': 'Не указан',
        'createdAt': FieldValue.serverTimestamp(),
        // 'role': role,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signUpDoctorWithEmailPassword({
    required String pseudoemail,
    required String password,
    required String phone,
    required String name,
    required String surname,
    // required String role,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: pseudoemail,
        password: password,
      );

      // создаём документ в Firestore
      await _db.collection('doctors').doc(userCredential.user!.uid).set({
        'phone': phone,
        'realEmail': 'Не указана',
        'name' : name,
        'surname' : surname,
        'city': 'Не указан',
        'specialization': 'Не указана',
        'experience': 'Не указан',
        'placeOfWork': 'Не указано',
        'price': 'Не указано',
        'about': 'Не указано',
        'createdAt': FieldValue.serverTimestamp(),
        // 'role': role,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }


  // sign out
  Future<void> signOut( ) async {
    return await _auth.signOut();
  }

// errors
}