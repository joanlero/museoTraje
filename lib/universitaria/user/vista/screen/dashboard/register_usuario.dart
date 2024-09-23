
import 'package:adminmuseo/universitaria/circulares/vista/screens/dashboard/listar_circular.dart';
import 'package:adminmuseo/universitaria/eventos/controller/eventoControllerWeb.dart';
import 'package:adminmuseo/universitaria/eventos/vista/screens/dashboard/listar_evento.dart';
import 'package:adminmuseo/universitaria/posgrado/vista/screens/dashboard/listar_posgrado.dart';
import 'package:adminmuseo/universitaria/pregrado/vista/screens/dashboard/listar_pregrado.dart';
import 'package:adminmuseo/universitaria/tecnicas/vista/screens/dashboard/listar_tecnica.dart';
import 'package:adminmuseo/universitaria/user/controller/userControllerWeb.dart';
import 'package:adminmuseo/universitaria/user/model/museoUsuarioModel.dart';
import 'package:adminmuseo/universitaria/user/vista/screen/dashboard/listar_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

class WebMainRegisterUsuario extends StatefulWidget {
  static const String id = "addusuario";

  @override
  State<WebMainRegisterUsuario> createState() => _WebMainRegisterUsuarioState();
}

class _WebMainRegisterUsuarioState extends State<WebMainRegisterUsuario> {

  final EventoControllerWeb _eventoController = EventoControllerWeb();
  TextEditingController nombreUserC = TextEditingController();
  TextEditingController correoUserC = TextEditingController();
  TextEditingController direccionUserC = TextEditingController();
  TextEditingController passwordUserC = TextEditingController();

  bool isLoading = false;
  var uuid = Uuid();

  final _formKey = GlobalKey<FormState>();

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
        selectedRoute: ListarUsuarioScreen.id, // Asegúrate de ajustar esto según la pantalla activa
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
                        controller: passwordUserC,
                        maxLength: 200,
                        obscureText: true, // Ocultar la contraseña
                        decoration: InputDecoration(
                          hintText: 'Password Usuario',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "Password no puede estar vacío";
                          }
                          // Verificar si la contraseña cumple con los requisitos
                          RegExp regex = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
                          if (!regex.hasMatch(v)) {
                            return "La contraseña debe tener al menos una mayúscula, un número y un carácter especial.";
                          }
                          return null;
                        },
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
        final encryptedPassword = UserControllerWeb.hashPassword(passwordUserC.text);

        // Guardar usuario en Firestore usando el modelo ModelUser
        await UserControllerWeb.addUser(ModelUser(
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
