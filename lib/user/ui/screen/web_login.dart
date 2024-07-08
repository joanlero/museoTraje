import 'package:adminmuseo/museo/traje/ui/screens/dashboard/listar_card_museo.dart';
import 'package:flutter/material.dart';
import 'package:adminmuseo/user/services/firebase_services.dart';
import 'package:adminmuseo/user/ui/widget/eco_button.dart';
import 'package:adminmuseo/user/ui/widget/ecotextfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

class WebLoginScreen extends StatefulWidget {
  const WebLoginScreen({super.key});
  static const String id = "webmain";

  @override
  State<WebLoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<WebLoginScreen> {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  Future<void> ecoDialogue(String error) async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(error),
          actions: [
            EcoButtonWeb(
              title: 'Cerrar',
              onPress: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  submit() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        formStateLoading = true;
      });

      String? accountstatus =
      await FirebaseServicesWeb.signInAccount(emailC.text, passwordC.text);

      if (accountstatus != null) {
        ecoDialogue(accountstatus);
        setState(() {
          formStateLoading = false;
        });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ListarMuseoScreen()),
        );
      }
    }
  }

  final formkey = GlobalKey<FormState>();
  bool formStateLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF7A33),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Card(
            color: Colors.white, // Color de fondo de la tarjeta
            elevation: 5, // Elevación de la tarjeta
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/splash/logo.png',
                      width: 120,
                      height: 107,
                    ),
                    EcoTextFieldWeb(
                      controller: emailC,
                      hintText: "Correo",
                      maxLines: 1,
                      validate: (v) {
                        if (v!.isEmpty) {
                          return "Correo no puede estar vacío";
                        } else if (!v.contains('@')) {
                          return "El formato del correo electrónico es incorrecto";
                        }
                        return null;
                      },
                    ),
                    EcoTextFieldWeb(
                      controller: passwordC,
                      isPassowrd: true,
                      maxLines: 1,
                      hintText: "Contraseña",
                      validate: (v) {
                        if (v!.isEmpty) {
                          return "Contraseña no puede estar vacía";
                        }
                        return null;
                      },
                    ),
                    EcoButtonWeb(
                      title: "Iniciar Sesión",
                      isLoginButton: true,
                      isLoading: formStateLoading,
                      onPress: () {
                        submit();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
