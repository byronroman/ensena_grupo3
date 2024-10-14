import 'package:ensena_grupo3/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home.dart';
import 'pages/configuracion.dart';
import 'package:ensena_grupo3/preferences/pref_usuarios.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenciasUsuario.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(EnsenaApp());
}

class EnsenaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Login.routename,
      routes: {
        Login.routename  : (context) =>   Login(),
        HomePage.routename: (context) =>  HomePage(),
        RegistroPages.routename: (context) =>  RegistroPages(),
        ConfiguracionPage.routename: (context) =>  ConfiguracionPage()



      },
    );
  }
}
