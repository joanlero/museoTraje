import 'dart:io';

import 'package:adminmuseo/universitaria/circulares/vista/screens/dashboard/listar_circular.dart';
import 'package:adminmuseo/universitaria/eventos/controller/eventoControllerWeb.dart';
import 'package:adminmuseo/universitaria/eventos/model/modelEventoWeb.dart';
import 'package:adminmuseo/universitaria/eventos/vista/screens/dashboard/listar_evento.dart';
import 'package:adminmuseo/universitaria/posgrado/vista/screens/dashboard/listar_posgrado.dart';
import 'package:adminmuseo/universitaria/pregrado/vista/screens/dashboard/listar_pregrado.dart';
import 'package:adminmuseo/universitaria/tecnicas/vista/screens/dashboard/listar_tecnica.dart';
import 'package:adminmuseo/universitaria/user/vista/screen/dashboard/listar_usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';


class WebMainUpdateEventoUniversitaria extends StatefulWidget {
  static const String idRoute = "updatecardUniveristaria";

  WebMainUpdateEventoUniversitaria({Key? key, this.id, this.universitariaEvento}) : super(key: key);

  final String? id;
  final ModelEventoWeb? universitariaEvento;

  @override
  State<WebMainUpdateEventoUniversitaria> createState() => _WebMainUpdateEventoUniversitariaState();
}

class _WebMainUpdateEventoUniversitariaState extends State<WebMainUpdateEventoUniversitaria> {
  final EventoControllerWeb _eventoController = EventoControllerWeb(); // Controlador
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleEC = TextEditingController();
  TextEditingController descriptionShortEC = TextEditingController();
  TextEditingController descriptionLargeEC = TextEditingController();

  final imagePicker = ImagePicker();
  List<XFile> images = [];
  String imageUrlsEvento = '';
  bool isLoading = false;
  bool isSaving = false;
  var uuid = Uuid();

  @override
  void initState() {
    super.initState();
    if (widget.universitariaEvento != null) {
      titleEC.text = widget.universitariaEvento!.titleEvento!;
      descriptionShortEC.text = widget.universitariaEvento!.descriptionShortEvento!;
      descriptionLargeEC.text = widget.universitariaEvento!.descriptionLargeEvento!;
    }
  }

  void chooseScreens(item) {
    switch (item) {
      case ListarCircularScreen.id:
        Navigator.pushNamed(context, ListarCircularScreen.id);
        break;
      case ListarEventoScreen.id:
        Navigator.pushNamed(context, ListarEventoScreen.id);
        break;
      case ListarPosgradoScreen.id:
        Navigator.pushNamed(context, ListarPosgradoScreen.id);
        break;
      case ListarPregradoScreen.id:
        Navigator.pushNamed(context, ListarPregradoScreen.id);
        break;
      case ListarTecnicaScreen.id:
        Navigator.pushNamed(context, ListarTecnicaScreen.id);
        break;
      case ListarUsuarioScreen.id:
        Navigator.pushNamed(context, ListarUsuarioScreen.id);
        break;
    // Agrega casos para las demás pantallas...
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF03045e),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white, size: 35,),
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
        backgroundColor: Color(0xFF03045e),
        activeIconColor: Colors.white,
        borderColor: const Color(0xFFE7E7E7),
        iconColor: Colors.white,
        items: const [
          AdminMenuItem(
            title: 'INICIO',
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'CIRCULAR',
            icon: Icons.book,
            route: ListarCircularScreen.id,
          ),
          AdminMenuItem(
            title: 'EVENTOS',
            icon: Icons.event,
            route: ListarEventoScreen.id,
          ),
          AdminMenuItem(
            title: 'CARRERAS',
            icon: Icons.menu_book,
            children: [
              AdminMenuItem(
                icon: Icons.menu_book,
                title: 'POSGRADOS',
                route: ListarPosgradoScreen.id,
              ),
              AdminMenuItem(
                icon: Icons.menu_book,
                title: 'PREGRADOS',
                route: ListarPregradoScreen.id,
              ),
              AdminMenuItem(
                icon: Icons.menu_book,
                title: 'CARRERAS TÉCNICAS',
                route: ListarTecnicaScreen.id,
              ),
            ],
          ),
          AdminMenuItem(
              title: 'USUARIOS',
              icon: Icons.file_copy,
              route: ListarUsuarioScreen.id
          ),
        ],
        selectedRoute: ListarEventoScreen.id,
        onSelected: (item) {
          chooseScreens(item.route);
        },
        header: Container(
          height: 120,
          width: double.infinity,
          color: const Color(0xFF03045e),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagen (asegúrate de tener el archivo de imagen en tu proyecto)
              Image.asset(
                'assets/images/splash/logoUniversitaria.png', // Ruta de tu imagen
                height: 120, // Ajusta el tamaño según sea necesario
              ),

            ],
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: Color(0xFF03045e),
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
                        "EDITAR EVENTO",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            fontFamily: ''),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "Título no puede estar vacío";
                                }
                                return null;
                              },
                              controller: titleEC,
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
                      SizedBox(width: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "Descripción corta no puede estar vacía";
                                }
                                return null;
                              },
                              controller: descriptionShortEC,
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
                      SizedBox(width: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "Descripción larga no puede estar vacía";
                                }
                                return null;
                              },
                              controller: descriptionLargeEC,
                              maxLines: null,
                              maxLength: 2000,
                              decoration: InputDecoration(
                                hintText: 'Descripción Larga del Evento',
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

  void clearFields() {
    setState(() {
      titleEC.clear();
      descriptionShortEC.clear();
      descriptionLargeEC.clear();
    });
  }

  Future<void> save() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSaving = true;
      });
      await uploadImages();
      await EventoControllerWeb.updateEventoUniversitaria(
        widget.id!,
        ModelEventoWeb(
          idEvento: uuid.v4(),
          titleEvento: titleEC.text,
          descriptionShortEvento: descriptionShortEC.text,
          descriptionLargeEvento: descriptionLargeEC.text,
          imageUrlsEvento: imageUrlsEvento,
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

  Future<void> pickImage() async {
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
    try {
      if (kIsWeb) {
        await ref.putData(
          await imageFile.readAsBytes(),
          SettableMetadata(contentType: "image/jpeg"),
        );
      } else {
        await ref.putFile(File(imageFile.path));
      }
      urls = await ref.getDownloadURL();
    } catch (e) {
      print("Error al subir la imagen: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return urls;
  }

  Future<void> uploadImages() async {
    for (var image in images) {
      await postImages(image).then((downLoadUrl) {
        if (downLoadUrl != null) {
          if (imageUrlsEvento.isNotEmpty) {
            imageUrlsEvento += ';' + downLoadUrl;
          } else {
            imageUrlsEvento = downLoadUrl;
          }
        }
      });
    }

    Navigator.of(context).pushNamed(ListarEventoScreen.id);
  }
}
