import 'package:adminmuseo/museo/eventos/model/museoEventoModel.dart';
import 'package:adminmuseo/museo/eventos/ui/screens/dashboard/listar_evento_museo.dart';
import 'package:adminmuseo/museo/traje/ui/screens/dashboard/listar_card_museo.dart';
import 'package:adminmuseo/user/ui/screen/dashboard/listar_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

import 'package:adminmuseo/user/model/museoUsuarioModel.dart';

class WebMainRegisterUsuario extends StatefulWidget {
  static const String id = "addusuario";

  @override
  State<WebMainRegisterUsuario> createState() => _WebMainRegisterUsuarioState();
}

class _WebMainRegisterUsuarioState extends State<WebMainRegisterUsuario> {
  TextEditingController nombreUserC = TextEditingController();
  TextEditingController correoUserC = TextEditingController();
  TextEditingController direccionUserC = TextEditingController();
  TextEditingController passwordUserC = TextEditingController();

  bool isLoading = false;
  var uuid = Uuid();

  final _formKey = GlobalKey<FormState>();

  void chooseScreens(item) {
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
            route: ListarUsuarioScreen.id,
          ),
        ],
        selectedRoute: ListarUsuarioScreen.id, // Asegúrate de ajustar esto según la pantalla activa
        onSelected: (item) {
          chooseScreens(item.route);
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xFFF55A07),
          child: const Center(
            child: Text(
              'USUARIOS',
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
                        "FORMULARIO DE REGISTRO USUARIOS",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "Usuario no puede estar vacío";
                          }
                          return null;
                        },
                        controller: nombreUserC,
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
                      SizedBox(height: 10),
                      TextFormField(
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "Correo no puede estar vacío";
                          }
                          return null;
                        },
                        controller: correoUserC,
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
                      SizedBox(height: 10),
                      TextFormField(
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "Password no puede estar vacío";
                          }
                          return null;
                        },
                        controller: passwordUserC,
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
                        obscureText: true, // Ocultar la contraseña
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "Dirección no puede estar vacío";
                          }
                          return null;
                        },
                        controller: direccionUserC,
                        maxLength: 2000,
                        decoration: InputDecoration(
                          hintText: 'Dirección del Usuario',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF003F5D),
                          ),
                          child: isLoading
                              ? CircularProgressIndicator()
                              : Text(
                            'ENVIAR',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
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
      nombreUserC.clear();
      correoUserC.clear();
      direccionUserC.clear();
      passwordUserC.clear();
    });
  }

  Future<void> save() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        // Encriptar la contraseña
        final encryptedPassword = ModelUser.hashPassword(passwordUserC.text);

        // Guardar usuario en Firestore usando el modelo ModelUser
        await ModelUser.addUser(ModelUser(
          idUser: uuid.v4(),
          nombreUser: nombreUserC.text,
          correoUser: correoUserC.text,
          direccionUser: direccionUserC.text,
          passwordUser: encryptedPassword,
        ));

        // Limpiar campos y mostrar mensaje de éxito
        clearFields();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registro Exitoso")),
        );

        Navigator.pushReplacementNamed(context, ListarUsuarioScreen.id);

      } catch (error) {
        // Mostrar mensaje de error en caso de fallo en Firestore
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al registrar: $error")),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
