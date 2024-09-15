import 'package:cloud_firestore/cloud_firestore.dart';

class ModelCircularWeb {
  String? idCircular;
  String? nombreCircular;
  String? descriptionShortCircular;
  String? descriptionLargeCircular;
  String? imageUrls;
  Timestamp? createdAt;

  ModelCircularWeb({
    required this.idCircular,
    required this.nombreCircular,
    required this.descriptionShortCircular,
    required this.descriptionLargeCircular,
    required this.imageUrls,
    this.createdAt, required timestamp,
  });

}
