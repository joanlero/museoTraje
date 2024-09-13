import 'package:cloud_firestore/cloud_firestore.dart';

class ModelTrajeWeb {
  String? idTraje;
  String? nombreTraje;
  String? descriptionShort;
  String? descriptionLarge;
  String? imageUrls;
  Timestamp? createdAt;

  ModelTrajeWeb({
    required this.idTraje,
    required this.nombreTraje,
    required this.descriptionShort,
    required this.descriptionLarge,
    required this.imageUrls,
    this.createdAt, required timestamp,
  });

}
