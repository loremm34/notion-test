import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notion_test/data/repository/auth_repository.dart';

// сервис интеграции с firebase для аутентификации
class AuthService implements AuthRepository {
  final _auth = FirebaseAuth.instance;
  // создание юзера через пароль и
  @override
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final res = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return res.user;
    } on FirebaseAuthException catch (e) {
      log('$e');
      rethrow;
    } catch (e) {
      throw Exception('Ошибка при регистрации. Попробуйте еще раз.');
    }
  }

  // логин по паролю и пользователю
  @override
  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return res.user;
    } on FirebaseAuthException catch (e) {
      log('$e');
      rethrow;
    } catch (e) {
      throw Exception('Ошибка при авторизации. Попробуйте еще раз.');
    }
  }

  // логин через гугл
  @override
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      final googleAuth = await googleUser?.authentication;

      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
      return await _auth.signInWithCredential(cred);
    } catch (e) {
      log('Failed while sign in with google - $e');
    }
    return null;
  }

  // выход с аккаунта
  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log('Failed while signing out');
    }
  }
}
