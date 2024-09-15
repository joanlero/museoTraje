
import 'package:adminmuseo/universitaria/tecnicas/model/modelTecnicas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TecnicasControllerWeb {
  static Future<void> addTecnica(ModelTecnicasWeb modelTecnica) async {
    CollectionReference db = FirebaseFirestore.instance.collection("tecnicas");

    Map<String, dynamic> data = {
      "idTecnica": modelTecnica.idTecnica,
      "nombreTecnica": modelTecnica.nombreTecnica,
      "descriptionShortTecnica": modelTecnica.descriptionShortTecnica,
      "descriptionLargeTecnica": modelTecnica.descriptionLargeTecnica,
      "imageUrlsTecnica": modelTecnica.imageUrlsTecnica,
      "timestamp": FieldValue.serverTimestamp(), // Agregar el timestamp del servidor
    };

    await db.add(data);
  }

  static Future<void> updateTecnica(String id, ModelTecnicasWeb modelTecnica) async {
    CollectionReference db = FirebaseFirestore.instance.collection("tecnicas");

    Map<String, dynamic> data = {
      "idTecnica": modelTecnica.idTecnica,
      "nombreTecnica": modelTecnica.nombreTecnica,
      "descriptionShortTecnica": modelTecnica.descriptionShortTecnica,
      "descriptionLargeTecnica": modelTecnica.descriptionLargeTecnica,
      "imageUrlsTecnica": modelTecnica.imageUrlsTecnica,
      // No se actualiza el campo 'timestamp' porque debería ser solo para la creación
    };

    await db.doc(id).update(data);
  }

  static Future<void> deleteTecnica(String id) async {
    CollectionReference db = FirebaseFirestore.instance.collection("tecnicas");

    await db.doc(id).delete();
  }

  // Función para obtener carreras técnicas ordenados por 'timestamp'
  static Stream<List<ModelTecnicasWeb>> getTecnicasStream() {
    CollectionReference db = FirebaseFirestore.instance.collection("tecnicas");

    return db
        .orderBy('timestamp', descending: true) // Ordenar por 'timestamp' en orden descendente
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return ModelTecnicasWeb(
          idTecnica: doc['idTecnica'],
          nombreTecnica: doc['nombreTecnica'],
          descriptionShortTecnica: doc['descriptionShortTecnica'],
          descriptionLargeTecnica: doc['descriptionLargeTecnica'],
          imageUrlsTecnica: doc['imageUrlsTecnica'],
          timestamp: doc['timestamp'],
        );
      }).toList();
    });
  }
}
