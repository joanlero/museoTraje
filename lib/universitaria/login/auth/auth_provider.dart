import 'package:adminmuseo/universitaria/user/controller/userControllerWeb.dart';
import 'package:flutter/material.dart';


class AuthProvider with ChangeNotifier {
  bool _authenticated = false;
  String? _userId; // Para almacenar el ID de usuario autenticado si es necesario

  bool get isAuthenticated => _authenticated;
  String? get userId => _userId;

  Future<bool> login(String email, String password) async {
    try {
      var encryptedPassword = UserControllerWeb.hashPassword(password);
      bool loggedIn = await UserControllerWeb.verifyPassword(email, encryptedPassword);
      if (loggedIn) {
        _authenticated = true;
        // Obtener y guardar el ID del usuario
        _userId = await UserControllerWeb.getUserIdByEmail(email);
      } else {
        _authenticated = false;
        _userId = null; // Limpiar el ID de usuario en caso de fallo de inicio de sesión
      }
    } catch (e) {
      print('Error al iniciar sesión: $e');
      _authenticated = false;
      _userId = null; // Limpiar el ID de usuario en caso de error
    }

    notifyListeners();
    return _authenticated;
  }

  void logout() {
    _authenticated = false;
    _userId = null; // Limpiar el ID de usuario al cerrar sesión
    notifyListeners();
  }
}
