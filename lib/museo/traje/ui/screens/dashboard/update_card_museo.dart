import 'dart:io';


import 'package:adminmuseo/museo/eventos/model/museoEventoModel.dart';
import 'package:adminmuseo/museo/eventos/ui/screens/dashboard/listar_evento_museo.dart';
import 'package:adminmuseo/museo/traje/model/museoModel.dart';
import 'package:adminmuseo/museo/traje/ui/screens/dashboard/listar_card_museo.dart';
import 'package:adminmuseo/user/ui/screen/dashboard/listar_usuario.dart';


import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

class WebMainUpdateCardMuseo extends StatefulWidget {
  static const String idRoute = "updatecardmuseo";

  WebMainUpdateCardMuseo({Key? key, this.id, this.museo}) : super(key: key);

  final String? id;
  final MuseoCard? museo;

  @override
  State<WebMainUpdateCardMuseo> createState() => _WebMainUpdateCardMuseoState();
}

class _WebMainUpdateCardMuseoState extends State<WebMainUpdateCardMuseo> {
  Widget selectedScreen = WebMainUpdateCardMuseo();
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleC = TextEditingController();
  TextEditingController descriptionShortC = TextEditingController();
  TextEditingController descriptionLargeC = TextEditingController();

  chooseScreens(item) {
    switch (item) {
      case ListarMuseoScreen.id:
        Navigator.pushNamed(context, ListarMuseoScreen.id);
        break;
      case ListarEventoScreen.id:
        Navigator.pushNamed(context, ListarEventoScreen.id);
        break;
      case ListarUsuarioScreen.id: // Asumiendo que ListarUsuarioScreen.id existe
        Navigator.pushNamed(context, ListarUsuarioScreen.id);
        break;
    // Agrega casos para las demás pantallas...
    }
  }

  String? selectedValue;
  final imagePicker = ImagePicker();
  List<XFile> images = [];
  String imageUrls = '';
  bool isLoading = false;
  bool isSaving = false;
  var uuid = Uuid();

  @override
  void initState() {
    super.initState();
    if (widget.museo != null) {
      Widget selectedScreen = WebMainUpdateCardMuseo();
      titleC.text = widget.museo!.nombreTraje!;
      descriptionShortC.text = widget.museo!.descriptionShort!;
      descriptionLargeC.text = widget.museo!.descriptionLarge!;
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
              ModelEventoMuseoTraje.logout(context);
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
            route: ListarUsuarioScreen.id, // Ajusta según tu ruta para usuarios
          ),
        ],
        selectedRoute: WebMainUpdateCardMuseo.idRoute,
        onSelected: (item) {
          chooseScreens(item.route);
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xFFF55A07),
          child: const Center(
            child: Text(
              'MUSEO DEL TRAJE',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
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
                        "EDITAR CARD MUSEO",
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
                                  return "Titulo no puede estar Vacio";
                                }
                                return null;
                              },
                              controller: titleC,
                              maxLines: null,
                              maxLength: 100,
                              decoration: InputDecoration(
                                hintText: 'Titulo',
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
                                  return "Descripción corta no puede estar Vacio";
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
                      SizedBox(width: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "Descripción larga no puede estar Vacio";
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
                      //CONTENEDOR PARA SUBIR IMAGEN
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: images.isNotEmpty
                              ? Image.network(
                            File(images.first.path).path,
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
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
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
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
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
      await MuseoCard.updateMuseoCard(
        widget.id!,
        MuseoCard(
          idTraje: widget.id,
          nombreTraje: titleC.text,
          descriptionShort: descriptionShortC.text,
          descriptionLarge: descriptionLargeC.text,
          imageUrls: imageUrls,
        ),
      ).whenComplete(() {
        setState(() {
          isSaving = false;
          images.clear();
          clearFields();
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Actualización Exitosa")),
      );
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

  Future postImages(XFile? imageFile) async {
    setState(() {
      isLoading = true;
    });
    String? urls;
    Reference ref =
    FirebaseStorage.instance.ref().child("images").child(imageFile!.name);
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

  uploadImages() async {
    for (var image in images) {
      await postImages(image).then((downLoadUrl) {
        if (imageUrls.isNotEmpty) {
          imageUrls += ';' + downLoadUrl;
        } else {
          imageUrls = downLoadUrl;
        }
      });
    }

    Navigator.of(context).pushNamed(ListarMuseoScreen.id);
  }
}

