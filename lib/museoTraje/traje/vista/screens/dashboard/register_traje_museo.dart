import 'dart:io';
import 'package:adminmuseo/museoTraje/eventos/controller/eventoControllerWeb.dart';
import 'package:adminmuseo/museoTraje/eventos/model/modelEventoWeb.dart';
import 'package:adminmuseo/museoTraje/eventos/vista/screens/dashboard/listar_evento_museo.dart';
import 'package:adminmuseo/museoTraje/traje/controller/trajeControllerWeb.dart'; // Importa el controlador
import 'package:adminmuseo/museoTraje/traje/model/modelTraje.dart';
import 'package:adminmuseo/museoTraje/traje/vista/screens/dashboard/listar_traje_museo.dart';
import 'package:adminmuseo/museoTraje/user/vista/screen/dashboard/listar_usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

class WebMainRegisterCardMuseo extends StatefulWidget {
  static const String id = "addcardmuseo";

  @override
  State<WebMainRegisterCardMuseo> createState() => _WebMainRegisterCardMuseoState();
}

class _WebMainRegisterCardMuseoState extends State<WebMainRegisterCardMuseo> {
  final EventoControllerWeb _eventoController = EventoControllerWeb();
  TextEditingController titleC = TextEditingController();
  TextEditingController descriptionShortC = TextEditingController();
  TextEditingController descriptionLargeC = TextEditingController();

  String? selectedValue;
  final imagePicker = ImagePicker();
  List<XFile> images = [];
  String imageUrls = '';
  bool isLoading = false;
  bool isSaving = false;
  var uuid = Uuid();

  final _formKey = GlobalKey<FormState>();

  chooseScreens(item) {
    switch (item) {
      case ListarMuseoScreen.id:
        Navigator.pushNamed(context, ListarMuseoScreen.id);
        break;
      case ListarEventoScreen.id:
        Navigator.pushNamed(context, ListarEventoScreen.id);
        break;
      case ListarUsuarioScreen.id:
        Navigator.pushNamed(context, ListarUsuarioScreen.id);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF66212),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black, size: 35,),
            onPressed: () {
              // Aquí debes agregar la lógica para cerrar sesión
              _eventoController.logout(context);
            },
          ),
        ],
      ),
      sideBar: SideBar(
        textStyle: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.normal, fontSize: 14),
        backgroundColor: Color(0xFFF55A07),
        activeIconColor: Colors.white,
        borderColor: const Color(0xFFE7E7E7),
        iconColor: Colors.white,
        activeBackgroundColor: Colors.white,
        items: const [
          AdminMenuItem(
            title: 'INICIO',
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'TARJETA MUSEO',
            icon: Icons.museum,
            route: ListarMuseoScreen.id,
          ),
          AdminMenuItem(
            title: 'EVENTOS',
            icon: Icons.museum,
            route: ListarEventoScreen.id,
          ),
          AdminMenuItem(
            title: 'USUARIOS',
            icon: Icons.person,
            route: ListarUsuarioScreen.id,
          ),
        ],
        selectedRoute: WebMainRegisterCardMuseo.id,
        onSelected: (item) {
          chooseScreens(item.route);
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xFFF55A07),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagen (asegúrate de tener el archivo de imagen en tu proyecto)
              Image.asset(
                'assets/images/splash/logo.png', // Ruta de tu imagen
                height: 35, // Ajusta el tamaño según sea necesario
              ),
              SizedBox(width: 10), // Espacio entre la imagen y el texto
              Text(
                'Museo Traje Bogotá D.C.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: Color(0xFFF55A07),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
        child: Card(
          elevation: 5,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "FORMULARIO DE REGISTRO",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            fontFamily: ''),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "Titulo no puede estar Vacío";
                                }
                                return null;
                              },
                              controller: titleC,
                              maxLines: null,
                              maxLength: 100,
                              decoration: InputDecoration(
                                hintText: 'Título',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "Descripción corta no puede estar Vacía";
                                }
                                return null;
                              },
                              controller: descriptionShortC,
                              maxLines: null,
                              maxLength: 200,
                              decoration: InputDecoration(
                                hintText: 'Descripción Corta',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "Descripción larga no puede estar Vacía";
                                }
                                return null;
                              },
                              controller: descriptionLargeC,
                              maxLines: null,
                              maxLength: 2000,
                              decoration: InputDecoration(
                                hintText: 'Descripción Larga del Traje',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      // CONTENEDOR PARA SUBIR IMAGEN
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: images.isNotEmpty
                              ? kIsWeb
                              ? Image.network(
                            images.first.path,
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.height * 0.3,
                            fit: BoxFit.cover,
                          )
                              : Image.file(
                            File(images.first.path),
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.height * 0.3,
                            fit: BoxFit.cover,
                          )
                              : Center(
                            child: Text(
                              'No hay imagen seleccionada',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: ElevatedButton(
                                onPressed: () {
                                  pickImage();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: Text(
                                  'CARGAR IMAGEN',
                                  style: TextStyle(fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : () => save(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF003F5D),
                                ),
                                child: isLoading
                                    ? CircularProgressIndicator()
                                    : Text(
                                  'ENVIAR',
                                  style: TextStyle(fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  clearFields() {
    setState(() {
      titleC.clear();
      descriptionShortC.clear();
      descriptionLargeC.clear();
    });
  }

  save() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSaving = true;
      });
      await uploadImages();
      await TrajeControllerWeb.addTraje(
        ModelTrajeWeb(
          idTraje: uuid.v4(),
          nombreTraje: titleC.text,
          descriptionShort: descriptionShortC.text,
          descriptionLarge: descriptionLargeC.text,
          imageUrls: imageUrls,
          timestamp: FieldValue.serverTimestamp(),
        ),
      ).whenComplete(() {
        setState(() {
          images.clear();
          clearFields();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registro Exitoso")));
        });
      });
    }
  }

  pickImage() async {
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      setState(() {
        if (images.isNotEmpty) {
          images[0] = pickedImage;
        } else {
          images.add(pickedImage);
        }
      });
    } else {
      print("No hay imagen seleccionada");
    }
  }

  Future<String?> postImages(XFile? imageFile) async {
    setState(() {
      isLoading = true;
    });
    String? urls;
    Reference ref = FirebaseStorage.instance.ref().child("images").child(imageFile!.name);
    if (kIsWeb) {
      await ref.putData(
        await imageFile.readAsBytes(),
        SettableMetadata(contentType: "image/jpeg"),
      );
      urls = await ref.getDownloadURL();
      setState(() {
        isLoading = false;
      });
      return urls;
    }
  }

  Future<void> uploadImages() async {
    for (var image in images) {
      await postImages(image).then((downLoadUrl) {
        if (imageUrls.isNotEmpty) {
          imageUrls += ';' + downLoadUrl!;
        } else {
          imageUrls = downLoadUrl!;
        }
      });
    }
    Navigator.of(context).pushNamed(ListarMuseoScreen.id);
  }
}
