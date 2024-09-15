import 'package:cloud_firestore/cloud_firestore.dart';

class ModelPregradoWeb {
  String? idPregrado;
  String? nombrePregrado;
  String? descriptionShortPregrado;
  String? descriptionLargePregrado;
  String? imageUrlsPregrado;
  Timestamp? createdAt;

  ModelPregradoWeb({
    required this.idPregrado,
    required this.nombrePregrado,
    required this.descriptionShortPregrado,
    required this.descriptionLargePregrado,
    required this.imageUrlsPregrado,
    this.createdAt, required timestamp,
  });

}
