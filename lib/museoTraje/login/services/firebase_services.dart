
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices{
  static Future<String?> createAccount(
      String email,
      String password,
      ) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return "Correo ya esta en uso";
      } else if (e.code == "weak-password") {
        return "La contraseña es demasiado débil";
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<String?> signInAccount(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'login-not-found') {
        return 'Correo no encontrado.';
      } else if (e.code == 'wrong-password') {
        return 'Contraseña incorrecta.';
      } else if (e.message ==
          'The supplied auth credential is incorrect, malformed or has expired.') {
        return 'Las credenciales de autenticación proporcionadas son incorrectas.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }



}