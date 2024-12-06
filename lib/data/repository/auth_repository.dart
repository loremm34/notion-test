import 'package:firebase_auth/firebase_auth.dart';

// абстрактный класс для работы с аутентификацией
abstract class AuthRepository {
  Future<User?> createUserWithEmailAndPassword(String email, String password);
  Future<User?> loginUserWithEmailAndPassword(String email, String password);
  Future<UserCredential?> signInWithGoogle();
  Future<void> signOut();
}
