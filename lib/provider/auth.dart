import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> createAccount(String correo, String pass) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: correo,
        password: pass,
      );
      if (userCredential.user != null) {
        return userCredential.user?.uid;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'weak-password';
      } else if (e.code == 'email-already-in-use') {
        return 'email-already-in-use';
      }
    } catch (e) {
      return 'error';
    }
    return null;
  }

  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = userCredential.user;
      if (user?.uid != null) {
        return user?.uid;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'user-not-found';
      } else if (e.code == 'wrong-password') {
        return 'wrong-password';
      }
    }
    return null;
  }
}
