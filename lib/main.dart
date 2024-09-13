import 'package:adminmuseo/firebase_options.dart';
import 'package:adminmuseo/layout_screen.dart';
import 'package:adminmuseo/museoTraje/eventos/vista/screens/dashboard/listar_evento_museo.dart';
import 'package:adminmuseo/museoTraje/login/auth/auth_guard.dart';
import 'package:adminmuseo/museoTraje/login/auth/auth_provider.dart';
import 'package:adminmuseo/museoTraje/login/vista/screens/login_screen.dart';
import 'package:adminmuseo/museoTraje/traje/vista/screens/dashboard/listar_traje_museo.dart';
import 'package:adminmuseo/museoTraje/traje/vista/screens/dashboard/update_traje_museo.dart';
import 'package:adminmuseo/museoTraje/user/vista/screen/dashboard/listar_usuario.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => MaterialApp(
        title: 'Admin Museo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme:
          ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
            background: Colors.white,
          ),
        ),
        home: LayoutScreen(),
        routes: {
          // Utiliza AuthGuard para proteger la ruta
          ListarMuseoScreen.id: (context) =>
              AuthGuard(child: ListarMuseoScreen()),
          WebMainUpdateCardMuseo.idRoute: (context) =>
              AuthGuard(child: WebMainUpdateCardMuseo()),
          ListarEventoScreen.id: (context) =>
              AuthGuard(child: ListarEventoScreen()),
          ListarUsuarioScreen.id: (context) =>
              AuthGuard(child: ListarUsuarioScreen()),
          LoginScreen.id: (context) => LoginScreen(),
          // Otras rutas de la aplicación...
        },
      ),
    );
  }
}
