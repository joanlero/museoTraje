
import 'package:adminmuseo/universitaria/posgrado/model/modelPosgrado.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PosgradoControllerWeb {
  static Future<void> addPosgrado(ModelPosgradoWeb modelPosgrado) async {
    CollectionReference db = FirebaseFirestore.instance.collection("posgrados");

    Map<String, dynamic> data = {
      "idPosgrado": modelPosgrado.idPosgrado,
      "nombrePosgrado": modelPosgrado.nombrePosgrado,
      "descriptionShortPosgrado": modelPosgrado.descriptionShortPosgrado,
      "descriptionLargePosgrado": modelPosgrado.descriptionLargePosgrado,
      "imageUrls": modelPosgrado.imageUrls,
      "timestamp": FieldValue.serverTimestamp(), // Agregar el timestamp del servidor
    };

    await db.add(data);
  }

  static Future<void> updatePosgrado(String id, ModelPosgradoWeb modelPosgrado) async {
    CollectionReference db = FirebaseFirestore.instance.collection("posgrados");

    Map<String, dynamic> data = {
      "idPosgrado": modelPosgrado.idPosgrado,
      "nombrePosgrado": modelPosgrado.nombrePosgrado,
      "descriptionShortPosgrado": modelPosgrado.descriptionShortPosgrado,
      "descriptionLargePosgrado": modelPosgrado.descriptionLargePosgrado,
      "imageUrls": modelPosgrado.imageUrls,
      // No se actualiza el campo 'timestamp' porque debería ser solo para la creación
    };

    await db.doc(id).update(data);
  }

  static Future<void> deletePosgrados(String id) async {
    CollectionReference db = FirebaseFirestore.instance.collection("posgrados");

    await db.doc(id).delete();
  }

  // Función para obtener Posgrados ordenados por 'timestamp'
  static Stream<List<ModelPosgradoWeb>> getPosgradosStream() {
    CollectionReference db = FirebaseFirestore.instance.collection("posgrados");

    return db
        .orderBy('timestamp', descending: true) // Ordenar por 'timestamp' en orden descendente
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return ModelPosgradoWeb(
          idPosgrado: doc['idPosgrado'],
          nombrePosgrado: doc['nombrePosgrado'],
          descriptionShortPosgrado: doc['descriptionShortPosgrado'],
          descriptionLargePosgrado: doc['descriptionLargePosgrado'],
          imageUrls: doc['imageUrls'],
          timestamp: doc['timestamp'],
        );
      }).toList();
    });
  }
}
