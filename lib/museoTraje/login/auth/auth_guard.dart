
import 'package:adminmuseo/museoTraje/login/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:adminmuseo/museoTraje/login/vista/screens/login_screen.dart';
import 'package:provider/provider.dart';



class AuthGuard extends StatelessWidget {
  final Widget child;

  AuthGuard({required this.child});

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = Provider.of<AuthProvider>(context).isAuthenticated;

    if (isAuthenticated) {
      return child;
    } else {
      // Redirigir a la pantalla de inicio de sesión si no está autenticado
      return LoginScreen();
    }
  }
}
