
import 'package:adminmuseo/universitaria/circulares/model/modelCircular.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CircularesControllerWeb {
  static Future<void> addCircular(ModelCircularWeb modelCircular) async {
    CollectionReference db = FirebaseFirestore.instance.collection("circulares");

    Map<String, dynamic> data = {
      "idCircular": modelCircular.idCircular,
      "nombreCircular": modelCircular.nombreCircular,
      "descriptionShortCircular": modelCircular.descriptionShortCircular,
      "descriptionLargeCircular": modelCircular.descriptionLargeCircular,
      "imageUrls": modelCircular.imageUrls,
      "timestamp": FieldValue.serverTimestamp(), // Agregar el timestamp del servidor
    };

    await db.add(data);
  }

  static Future<void> updateCircular(String id, ModelCircularWeb modelCircular) async {
    CollectionReference db = FirebaseFirestore.instance.collection("circulares");

    Map<String, dynamic> data = {
      "idCircular": modelCircular.idCircular,
      "nombreCircular": modelCircular.nombreCircular,
      "descriptionShortCircular": modelCircular.descriptionShortCircular,
      "descriptionShortCircular": modelCircular.descriptionShortCircular,
      "imageUrls": modelCircular.imageUrls,
      // No se actualiza el campo 'timestamp' porque debería ser solo para la creación
    };

    await db.doc(id).update(data);
  }

  static Future<void> deleteCircular(String id) async {
    CollectionReference db = FirebaseFirestore.instance.collection("circulares");

    await db.doc(id).delete();
  }

  // Función para obtener Circulares ordenados por 'timestamp'
  static Stream<List<ModelCircularWeb>> getCircularStream() {
    CollectionReference db = FirebaseFirestore.instance.collection("circulares");

    return db
        .orderBy('timestamp', descending: true) // Ordenar por 'timestamp' en orden descendente
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return ModelCircularWeb(
          idCircular: doc['idCircular'],
          nombreCircular: doc['nombreCircular'],
          descriptionShortCircular: doc['descriptionShortCircular'],
          descriptionLargeCircular: doc['descriptionLargeCircular'],
          imageUrls: doc['imageUrls'],
          timestamp: doc['timestamp'],
        );
      }).toList();
    });
  }
}
