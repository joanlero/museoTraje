import 'package:adminmuseo/firebase_options.dart';
import 'package:adminmuseo/layout_screen.dart';
import 'package:adminmuseo/universitaria/login/auth/auth_guard.dart';
import 'package:adminmuseo/universitaria/login/auth/auth_provider.dart';
import 'package:adminmuseo/universitaria/tecnicas/vista/screens/dashboard/listar_tecnica.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'universitaria/circulares/vista/screens/dashboard/listar_circular.dart';
import 'universitaria/circulares/vista/screens/dashboard/update_circular.dart';
import 'universitaria/eventos/vista/screens/dashboard/listar_evento.dart';
import 'universitaria/login/vista/screens/login_screen.dart';
import 'universitaria/posgrado/vista/screens/dashboard/listar_posgrado.dart';
import 'universitaria/pregrado/vista/screens/dashboard/listar_pregrado.dart';
import 'universitaria/user/vista/screen/dashboard/listar_usuario.dart';


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
          ListarCircularScreen.id: (context) =>
              AuthGuard(child: ListarCircularScreen()),
          WebMainUpdateCircular.idRoute: (context) =>
              AuthGuard(child: WebMainUpdateCircular()),
          ListarEventoScreen.id: (context) =>
              AuthGuard(child: ListarEventoScreen()),
          ListarPosgradoScreen.id: (context) =>
              AuthGuard(child: ListarPosgradoScreen()),
          ListarPregradoScreen.id: (context) =>
              AuthGuard(child: ListarPregradoScreen()),
          ListarTecnicaScreen.id: (context) =>
              AuthGuard(child: ListarTecnicaScreen()),
          ListarUsuarioScreen.id: (context) =>
              AuthGuard(child: ListarUsuarioScreen()),
          LoginScreen.id: (context) => LoginScreen(),
          // Otras rutas de la aplicación...
        },
      ),
    );
  }
}
