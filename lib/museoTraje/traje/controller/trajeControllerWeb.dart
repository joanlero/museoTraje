import 'package:adminmuseo/museoTraje/traje/model/modelTraje.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrajeControllerWeb {
  static Future<void> addTraje(ModelTrajeWeb modeloTraje) async {
    CollectionReference db = FirebaseFirestore.instance.collection("trajes");

    Map<String, dynamic> data = {
      "idTraje": modeloTraje.idTraje,
      "nombreTraje": modeloTraje.nombreTraje,
      "descriptionShort": modeloTraje.descriptionShort,
      "descriptionLarge": modeloTraje.descriptionLarge,
      "imageUrls": modeloTraje.imageUrls,
      "timestamp": FieldValue.serverTimestamp(), // Agregar el timestamp del servidor
    };

    await db.add(data);
  }

  static Future<void> updateTraje(String id, ModelTrajeWeb modeloTraje) async {
    CollectionReference db = FirebaseFirestore.instance.collection("trajes");

    Map<String, dynamic> data = {
      "idTraje": modeloTraje.idTraje,
      "nombreTraje": modeloTraje.nombreTraje,
      "descriptionShort": modeloTraje.descriptionShort,
      "descriptionLarge": modeloTraje.descriptionLarge,
      "imageUrls": modeloTraje.imageUrls,
      // No se actualiza el campo 'timestamp' porque debería ser solo para la creación
    };

    await db.doc(id).update(data);
  }

  static Future<void> deleteTraje(String id) async {
    CollectionReference db = FirebaseFirestore.instance.collection("trajes");

    await db.doc(id).delete();
  }

  // Función para obtener trajes ordenados por 'timestamp'
  static Stream<List<ModelTrajeWeb>> getTrajesStream() {
    CollectionReference db = FirebaseFirestore.instance.collection("trajes");

    return db
        .orderBy('timestamp', descending: true) // Ordenar por 'timestamp' en orden descendente
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return ModelTrajeWeb(
          idTraje: doc['idTraje'],
          nombreTraje: doc['nombreTraje'],
          descriptionShort: doc['descriptionShort'],
          descriptionLarge: doc['descriptionLarge'],
          imageUrls: doc['imageUrls'],
          // Asegúrate de que la clase ModelTrajeWeb tenga el campo `timestamp` si lo necesitas
          timestamp: doc['timestamp'],
        );
      }).toList();
    });
  }
}
