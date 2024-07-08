import 'package:adminmuseo/login/model/auth_provider.dart';
import 'package:adminmuseo/museo/traje/ui/screens/dashboard/listar_card_museo.dart';
import 'package:adminmuseo/user/ui/widget/eco_button.dart';
import 'package:adminmuseo/user/ui/widget/ecotextfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool formStateLoading = false;

  Future<void> ecoDialogue(String error) async {
    await showDialog(
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
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF7A33),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double horizontalPadding = constraints.maxWidth < 600 ? 10.w : 30.w;
            double cardPadding = constraints.maxWidth < 600 ? 5.w : 5.w;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Card(
                color: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(cardPadding),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/splash/logo.png',
                          width: 30.w,
                          height: 15.h,
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
                        SizedBox(height: 2.h),
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
                        SizedBox(height: 2.h),
                        EcoButtonWeb(
                          title: "Iniciar Sesión",
                          isLoginButton: true,
                          isLoading: formStateLoading,
                          onPress: submit,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
