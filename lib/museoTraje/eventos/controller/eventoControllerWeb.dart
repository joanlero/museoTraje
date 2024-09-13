import 'package:adminmuseo/museoTraje/eventos/model/modelEventoWeb.dart';
import 'package:adminmuseo/museoTraje/login/vista/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class EventoControllerWeb {

  // Método para añadir un evento
  static Future<void> addEventoMuseo(ModelEventoWeb modelEventoWeb) async {

    final CollectionReference db = FirebaseFirestore.instance.collection("eventos");
    Map<String, dynamic> data = {
      "idEvento": modelEventoWeb.idEvento,
      "titleEvento": modelEventoWeb.titleEvento,
      "descriptionShortEvento": modelEventoWeb.descriptionShortEvento,
      "descriptionLargeEvento": modelEventoWeb.descriptionLargeEvento,
      "imageUrlsEvento": modelEventoWeb.imageUrlsEvento,
      "timestamp": FieldValue.serverTimestamp(),
    };
    try {
      await db.add(data);
    } catch (e) {
      print("Error adding event: $e");
      // Manejo de errores
    }
  }

  // Método para actualizar un evento
  static Future<void> updateEventoMuseoCard(String id, ModelEventoWeb modelEventoWeb) async {

    final CollectionReference db = FirebaseFirestore.instance.collection("eventos");
    Map<String, dynamic> data = {
      "idEvento": modelEventoWeb.idEvento,
      "titleEvento": modelEventoWeb.titleEvento,
      "descriptionShortEvento": modelEventoWeb.descriptionShortEvento,
      "descriptionLargeEvento": modelEventoWeb.descriptionLargeEvento,
      "imageUrlsEvento": modelEventoWeb.imageUrlsEvento,
    };
    try {
      await db.doc(id).update(data);
    } catch (e) {
      print("Error updating event: $e");
      // Manejo de errores
    }
  }

  // Método para eliminar un evento
  Future<void> deleteEventoMuseo(String id) async {
    final CollectionReference db = FirebaseFirestore.instance.collection("eventos");
    try {
      await db.doc(id).delete();
    } catch (e) {
      print("Error deleting event: $e");
      // Manejo de errores
    }
  }

  static Stream<List<ModelEventoWeb>> getEventoStream() {
    CollectionReference db = FirebaseFirestore.instance.collection("eventos");

    return db
        .orderBy('timestamp', descending: true) // Ordenar por 'timestamp' en orden descendente
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return ModelEventoWeb(
          idEvento: doc['idEvento'],
          titleEvento: doc['titleEvento'],
          descriptionShortEvento:doc['descriptionShortEvento'],
          descriptionLargeEvento: doc['descriptionLargeEvento'],
          imageUrlsEvento: doc['imageUrlsEvento'],
          timestamp: doc['timestamp'],
        );
      }).toList();
    });
  }

  // Método para cerrar sesión
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamed(context, LoginScreen.id); // Asegúrate de tener una ruta de login definida
    } catch (e) {
      print("Error signing out: $e");
      // Manejo de errores
    }
  }
}

