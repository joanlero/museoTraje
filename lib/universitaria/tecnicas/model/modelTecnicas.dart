import 'package:cloud_firestore/cloud_firestore.dart';

class ModelTecnicasWeb {
  String? idTecnica;
  String? nombreTecnica;
  String? descriptionShortTecnica;
  String? descriptionLargeTecnica;
  String? imageUrlsTecnica;
  Timestamp? createdAt;

  ModelTecnicasWeb({
    required this.idTecnica,
    required this.nombreTecnica,
    required this.descriptionShortTecnica,
    required this.descriptionLargeTecnica,
    required this.imageUrlsTecnica,
    this.createdAt, required timestamp,
  });

}
