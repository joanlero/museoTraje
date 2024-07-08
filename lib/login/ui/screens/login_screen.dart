import 'package:adminmuseo/login/model/auth_provider.dart';
import 'package:adminmuseo/museo/traje/ui/screens/dashboard/listar_card_museo.dart';
import 'package:adminmuseo/user/ui/widget/eco_button.dart';
import 'package:adminmuseo/user/ui/widget/ecotextfield.dart';
import 'package:flutter/material.dart';
import 'package:adminmuseo/user/model/museoUsuarioModel.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart'; // Importar Provider para usar ChangeNotifierProvider

class LoginScreen extends StatefulWidget {
  static const String id = "login";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool formStateLoading = false;

  Future<void> ecoDialogue(String error) async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(error),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        formStateLoading = true;
      });

      try {
        // Iniciar sesión usando AuthProvider
        bool loggedIn = await Provider.of<AuthProvider>(context, listen: false)
            .login(emailController.text, passwordController.text);

        if (loggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ListarMuseoScreen()),
          );
        } else {
          ecoDialogue('Correo o contraseña incorrectos');
        }
      } catch (e) {
        print('Error al iniciar sesión: $e');
        ecoDialogue('Error al iniciar sesión');
      } finally {
        setState(() {
          formStateLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF7A33),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Card(
            color: Colors.white,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/splash/logo.png',
                        width: 120,
                        height: 107,
                      ),
                      EcoTextFieldWeb(
                        controller: emailController,
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
                      SizedBox(height: 20.0),
                      EcoTextFieldWeb(
                        controller: passwordController,
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
                      SizedBox(height: 20.0),
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
      ),
    );
  }
}
