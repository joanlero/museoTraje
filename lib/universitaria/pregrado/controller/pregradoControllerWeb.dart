
import 'package:adminmuseo/universitaria/pregrado/model/modelPregrado.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PregradoControllerWeb {
  static Future<void> addPregrado(ModelPregradoWeb modelPregrado) async {
    CollectionReference db = FirebaseFirestore.instance.collection("pregrados");

    Map<String, dynamic> data = {
      "idPregrado": modelPregrado.idPregrado,
      "nombrePregrado": modelPregrado.nombrePregrado,
      "descriptionShortPregrado": modelPregrado.descriptionShortPregrado,
      "descriptionLargePregrado": modelPregrado.descriptionLargePregrado,
      "imageUrlsPregrado": modelPregrado.imageUrlsPregrado,
      "timestamp": FieldValue.serverTimestamp(), // Agregar el timestamp del servidor
    };

    await db.add(data);
  }

  static Future<void> updatePregrado(String id, ModelPregradoWeb modelPregrado) async {
    CollectionReference db = FirebaseFirestore.instance.collection("pregrados");

    Map<String, dynamic> data = {
      "idPregrado": modelPregrado.idPregrado,
      "nombrePregrado": modelPregrado.nombrePregrado,
      "descriptionShortPregrado": modelPregrado.descriptionShortPregrado,
      "descriptionLargePregrado": modelPregrado.descriptionLargePregrado,
      "imageUrlsPregrado": modelPregrado.imageUrlsPregrado,
      // No se actualiza el campo 'timestamp' porque debería ser solo para la creación
    };

    await db.doc(id).update(data);
  }

  static Future<void> deletePregrado(String id) async {
    CollectionReference db = FirebaseFirestore.instance.collection("pregrados");

    await db.doc(id).delete();
  }

  // Función para obtener Pregrados ordenados por 'timestamp'
  static Stream<List<ModelPregradoWeb>> getPregradoStream() {
    CollectionReference db = FirebaseFirestore.instance.collection("pregrados");

    return db
        .orderBy('timestamp', descending: true) // Ordenar por 'timestamp' en orden descendente
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return ModelPregradoWeb(
          idPregrado: doc['idPregrado'],
          nombrePregrado: doc['nombrePregrado'],
          descriptionShortPregrado: doc['descriptionShortPregrado'],
          descriptionLargePregrado: doc['descriptionLargePregrado'],
          imageUrlsPregrado: doc['imageUrlsPregrado'],
          timestamp: doc['timestamp'],
        );
      }).toList();
    });
  }
}
