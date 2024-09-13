import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

class ModelUser {
  String? idUser;
  String? nombreUser;
  String? correoUser;
  String? direccionUser;
  String? passwordUser; // No se almacenará la contraseña sin cifrar

  ModelUser({
    required this.idUser,
    required this.nombreUser,
    required this.correoUser,
    required this.direccionUser,
    required this.passwordUser, // Asegúrate de recibir la contraseña sin cifrar
  });
}
