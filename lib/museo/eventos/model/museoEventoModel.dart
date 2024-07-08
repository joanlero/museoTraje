import 'package:adminmuseo/login/ui/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ModelEventoMuseoTraje {
  String? idEvento;
  String? titleEvento;
  String? descriptionShortEvento;
  String? descriptionLargeEvento;
  String? imageUrlsEvento;


  ModelEventoMuseoTraje({
    required this.idEvento,
    required this.titleEvento,
    required this.descriptionShortEvento,
    required this.descriptionLargeEvento,
    required this.imageUrlsEvento,
  });





  static Future<void> addEventoMuseo(ModelEventoMuseoTraje modelEventoMuseoTraje) async {
    CollectionReference db = FirebaseFirestore.instance.collection("eventos");
    Map<String, dynamic> data = {
      "idEvento": modelEventoMuseoTraje.idEvento,
      "titleEvento": modelEventoMuseoTraje.titleEvento,
      "descriptionShortEvento": modelEventoMuseoTraje.descriptionShortEvento,
      "descriptionLargeEvento": modelEventoMuseoTraje.descriptionLargeEvento,
      "imageUrlsEvento": modelEventoMuseoTraje.imageUrlsEvento,

    };
    await db.add(data);
  }


  static Future<void> updateEventoMuseoCard(String id, ModelEventoMuseoTraje modelEventoMuseoTraje) async {
    CollectionReference db = FirebaseFirestore.instance.collection("eventos");

    Map<String, dynamic> data = {
      "idEvento": modelEventoMuseoTraje.idEvento,
      "titleEvento": modelEventoMuseoTraje.titleEvento,
      "descriptionShortEvento": modelEventoMuseoTraje.descriptionShortEvento,
      "descriptionLargeEvento": modelEventoMuseoTraje.descriptionLargeEvento,
      "imageUrlsEvento": modelEventoMuseoTraje.imageUrlsEvento,
    };
    await db.doc(id).update(data);
  }


  static Future<void> deleteEventoMuseo(String id) async {
    CollectionReference db = FirebaseFirestore.instance.collection("eventos");

    await db.doc(id).delete();
  }

  static Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, LoginScreen.id); // Asegúrate de tener una ruta de login definida
  }
}
