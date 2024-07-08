import 'package:cloud_firestore/cloud_firestore.dart';

class MuseoCard {
  String? idTraje;
  String? nombreTraje;
  String? descriptionShort;
  String? descriptionLarge;
  String? imageUrls;

  MuseoCard({
    required this.idTraje,
    required this.nombreTraje,
    required this.descriptionShort,
    required this.descriptionLarge,
    required this.imageUrls,
  });





  static Future<void> addMuseo(MuseoCard museoCard) async {
    CollectionReference db = FirebaseFirestore.instance.collection("trajes");
    Map<String, dynamic> data = {
      "idTraje": museoCard.idTraje,
      "nombreTraje": museoCard.nombreTraje,
      "descriptionShort": museoCard.descriptionShort,
      "descriptionLarge": museoCard.descriptionLarge,
      "imageUrls": museoCard.imageUrls,

    };
    await db.add(data);
  }


  static Future<void> updateMuseoCard(String id, MuseoCard museoCard) async {
    CollectionReference db = FirebaseFirestore.instance.collection("trajes");

    Map<String, dynamic> data = {
      "idTraje": museoCard.idTraje,
      "nombreTraje": museoCard.nombreTraje,
      "descriptionShort": museoCard.descriptionShort,
      "descriptionLarge": museoCard.descriptionLarge,
      "imageUrls": museoCard.imageUrls,
    };
    await db.doc(id).update(data);
  }


  static Future<void> deleteMuseo(String id) async {
    CollectionReference db = FirebaseFirestore.instance.collection("trajes");

    await db.doc(id).delete();
  }
}
