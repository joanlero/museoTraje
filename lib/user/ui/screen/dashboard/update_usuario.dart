import 'dart:io';


import 'package:adminmuseo/museo/eventos/model/museoEventoModel.dart';
import 'package:adminmuseo/museo/eventos/ui/screens/dashboard/listar_evento_museo.dart';
import 'package:adminmuseo/museo/traje/ui/screens/dashboard/listar_card_museo.dart';
import 'package:adminmuseo/user/model/museoUsuarioModel.dart';
import 'package:adminmuseo/user/ui/screen/dashboard/listar_usuario.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

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
  TextEditingController nombreUserEC = TextEditingController();
  TextEditingController correoUserEC = TextEditingController();
  TextEditingController direccionUserEC = TextEditingController();
  TextEditingController passwordUserEC = TextEditingController();

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
        final encryptedPassword = ModelUser.hashPassword(passwordUserEC.text);
        await ModelUser.updateUser(
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

