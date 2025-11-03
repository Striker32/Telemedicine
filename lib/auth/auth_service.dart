import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
  Future<UserCredential> signUpWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
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