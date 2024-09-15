import 'dart:convert';
import 'package:adminmuseo/universitaria/user/model/museoUsuarioModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

class UserControllerWeb {

  // Método estático para añadir un usuario a Firestore
  static Future<void> addUser(ModelUser modelUser) async {
    CollectionReference db = FirebaseFirestore.instance.collection("usuarios");
    Map<String, dynamic> data = {
      "idUser": modelUser.idUser,
      "nombreUser": modelUser.nombreUser,
      "correoUser": modelUser.correoUser,
      "direccionUser": modelUser.direccionUser,
      "passwordUser": hashPassword(modelUser.passwordUser!), // Guardar la contraseña cifrada
    };
    await db.add(data);
  }

  // Método estático para actualizar un usuario en Firestore
  static Future<void> updateUser(String id, ModelUser modelUser) async {
    CollectionReference db = FirebaseFirestore.instance.collection("usuarios");

    Map<String, dynamic> data = {
      "idUser": modelUser.idUser,
      "nombreUser": modelUser.nombreUser,
      "correoUser": modelUser.correoUser,
      "direccionUser": modelUser.direccionUser,
      "passwordUser": hashPassword(modelUser.passwordUser!), // Actualizar la contraseña cifrada
    };
    await db.doc(id).update(data);
  }

  // Método estático para eliminar un usuario en Firestore
  static Future<void> deleteUser(String id) async {
    CollectionReference db = FirebaseFirestore.instance.collection("usuarios");

    await db.doc(id).delete();
  }

  // Método para convertir la contraseña en hash SHA-256
  static String hashPassword(String password) {
    var bytes = utf8.encode(password); // Codificar la contraseña en bytes UTF-8
    var hash = sha256.convert(bytes); // Aplicar hash SHA-256
    return hash.toString(); // Devolver la cadena hexadecimal del hash
  }

  // Método para verificar la contraseña al iniciar sesión
  static Future<bool> verifyPassword(String email, String password) async {
    CollectionReference db = FirebaseFirestore.instance.collection("usuarios");

    var snapshot = await db.where('correoUser', isEqualTo: email).get();
    if (snapshot.docs.isNotEmpty) {
      var userDoc = snapshot.docs.first;
      var hashedPassword = userDoc['passwordUser'];

      // Encriptar la contraseña proporcionada para compararla con la almacenada
      var hashedInputPassword = hashPassword(password);

      // Comparar contraseñas encriptadas
      return hashedPassword == hashedInputPassword;
    } else {
      return false; // Usuario no encontrado
    }
  }

  // Método estático para obtener el ID de usuario por correo electrónico
  static Future<String?> getUserIdByEmail(String email) async {
    CollectionReference db = FirebaseFirestore.instance.collection("usuarios");

    var snapshot = await db.where('correoUser', isEqualTo: email).get();
    if (snapshot.docs.isNotEmpty) {
      var userDoc = snapshot.docs.first;
      return userDoc.id; // Devuelve el ID del usuario encontrado
    } else {
      return null; // Usuario no encontrado
    }
  }
}
