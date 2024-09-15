import 'dart:io';
import 'package:adminmuseo/universitaria/circulares/vista/screens/dashboard/listar_circular.dart';
import 'package:adminmuseo/universitaria/eventos/controller/eventoControllerWeb.dart';
import 'package:adminmuseo/universitaria/eventos/vista/screens/dashboard/listar_evento.dart';
import 'package:adminmuseo/universitaria/posgrado/vista/screens/dashboard/listar_posgrado.dart';
import 'package:adminmuseo/universitaria/tecnicas/vista/screens/dashboard/listar_tecnica.dart';
import 'package:adminmuseo/universitaria/user/controller/userControllerWeb.dart';
import 'package:adminmuseo/universitaria/user/model/museoUsuarioModel.dart';
import 'package:adminmuseo/universitaria/user/vista/screen/dashboard/listar_usuario.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

import '../../../../pregrado/vista/screens/dashboard/listar_pregrado.dart';

class WebMainUpdateUser extends StatefulWidget {
  static const String idRoute = "updatecardmuseo";

  WebMainUpdateUser({Key? key, this.id, this.museoUser}) : super(key: key);

  final String? id;
  final ModelUser? museoUser;

  @override
  State<WebMainUpdateUser> createState() => _WebMainUpdateUserState();
}

class _WebMainUpdateUserState extends State<WebMainUpdateUser> {
  Widget selectedScreen = WebMainUpdateUser();
  final _formKey = GlobalKey<FormState>();
  final EventoControllerWeb _eventoController = EventoControllerWeb();

  TextEditingController nombreUserEC = TextEditingController();
  TextEditingController correoUserEC = TextEditingController();
  TextEditingController direccionUserEC = TextEditingController();
  TextEditingController passwordUserEC = TextEditingController();

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

  String? selectedValue;
  bool isLoading = false;
  bool isSaving = false;
  var uuid = Uuid();

  @override
  void initState() {
    super.initState();
    if (widget.museoUser != null) {
      Widget selectedScreen = WebMainUpdateUser();
      nombreUserEC.text = widget.museoUser!.nombreUser!;
      correoUserEC.text = widget.museoUser!.correoUser!;
      direccionUserEC.text = widget.museoUser!.direccionUser!;
      passwordUserEC.text = widget.museoUser!.passwordUser!;
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
        selectedRoute: WebMainUpdateUser.idRoute,
        onSelected: (item) {
          chooseScreens(item.route);
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xFF03045e),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagen (asegúrate de tener el archivo de imagen en tu proyecto)
              Image.asset(
                'assets/images/splash/logoUniversitaria.png', // Ruta de tu imagen
                height: 60, // Ajusta el tamaño según sea necesario
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
                        "EDITAR USUARIO",
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
                                  return "Usuario no puede estar Vacio";
                                }
                                return null;
                              },
                              controller: nombreUserEC,
                              maxLines: null,
                              maxLength: 100,
                              decoration: InputDecoration(
                                hintText: 'Nombre Usuario',
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
                                  return "Correo Usuario no puede estar Vacio";
                                }
                                return null;
                              },
                              controller: correoUserEC,
                              maxLines: null,
                              maxLength: 200,
                              decoration: InputDecoration(
                                hintText: 'Correo Usuario',
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
                                  return "Password Usuario no puede estar Vacio";
                                }
                                return null;
                              },
                              controller: passwordUserEC,
                              maxLines: null,
                              maxLength: 200,
                              decoration: InputDecoration(
                                hintText: 'Password Usuario',
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
                                  return "Dirección no puede estar Vacio";
                                }
                                return null;
                              },
                              controller: direccionUserEC,
                              maxLines: null,
                              maxLength: 2000,
                              decoration: InputDecoration(
                                hintText: 'Dirección Usuario',
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
                      SizedBox(height: 20),
                      Row(
                        children: [
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
      nombreUserEC.clear();
      correoUserEC.clear();
      direccionUserEC.clear();
    });
  }

  Future<void> save() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final encryptedPassword = UserControllerWeb.hashPassword(passwordUserEC.text);
        await UserControllerWeb.updateUser(
          widget.id!,
          ModelUser(
            idUser: uuid.v4(),
            nombreUser: nombreUserEC.text,
            correoUser: correoUserEC.text,
            direccionUser: direccionUserEC.text,
            passwordUser: encryptedPassword,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Actualización Exitosa")),
        );

        // Navegar a ListarMuseoScreen después de la actualización exitosa
        Navigator.of(context).pushNamed(ListarUsuarioScreen.id);

      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al actualizar: $error")),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}

