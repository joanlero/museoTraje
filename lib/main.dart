import 'package:adminmuseo/firebase_options.dart';
import 'package:adminmuseo/layout_screen.dart';
import 'package:adminmuseo/login/model/auth_guard.dart';
import 'package:adminmuseo/login/model/auth_provider.dart';
import 'package:adminmuseo/login/ui/screens/login_screen.dart';
import 'package:adminmuseo/museo/eventos/ui/screens/dashboard/listar_evento_museo.dart';
import 'package:adminmuseo/user/ui/screen/dashboard/listar_usuario.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'museo/traje/ui/screens/dashboard/listar_card_museo.dart';
import 'museo/traje/ui/screens/dashboard/update_card_museo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
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
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(background: Colors.white),
        ),
        home: LayoutScreen(),
        routes: {
          // Utiliza AuthGuard para proteger la ruta
          ListarMuseoScreen.id: (context) => AuthGuard(child: ListarMuseoScreen()),
          WebMainUpdateCardMuseo.idRoute: (context) => AuthGuard(child: WebMainUpdateCardMuseo()),
          ListarEventoScreen.id: (context) => AuthGuard (child: ListarEventoScreen()),
          ListarUsuarioScreen.id: (context) =>AuthGuard (child: ListarUsuarioScreen(),),
          LoginScreen.id: (context) => LoginScreen(),
          // Otras rutas de la aplicación...
        },
      ),
    );
  }
}
