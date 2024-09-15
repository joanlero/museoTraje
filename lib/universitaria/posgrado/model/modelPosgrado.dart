import 'package:cloud_firestore/cloud_firestore.dart';

class ModelPosgradoWeb {
  String? idPosgrado;
  String? nombrePosgrado;
  String? descriptionShortPosgrado;
  String? descriptionLargePosgrado;
  String? imageUrls;
  Timestamp? createdAt;

  ModelPosgradoWeb({
    required this.idPosgrado,
    required this.nombrePosgrado,
    required this.descriptionShortPosgrado,
    required this.descriptionLargePosgrado,
    required this.imageUrls,
    this.createdAt, required timestamp,
  });

}
