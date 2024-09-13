

import 'package:adminmuseo/museoTraje/login/vista/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ModelEventoWeb {
  String? idEvento;
  String? titleEvento;
  String? descriptionShortEvento;
  String? descriptionLargeEvento;
  String? imageUrlsEvento;
  Timestamp? createdAt;


  ModelEventoWeb({
    required this.idEvento,
    required this.titleEvento,
    required this.descriptionShortEvento,
    required this.descriptionLargeEvento,
    required this.imageUrlsEvento,
    this.createdAt, required timestamp,
  });

}