import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Autenticación de Firebase
import 'package:google_sign_in/google_sign_in.dart'; // Google Sign-In
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:ensena_grupo3/pages/login_page.dart';
import 'package:ensena_grupo3/pages/register_page.dart'; // Pantalla de registro (RegistroPages)
import 'home.dart'; // Página principal de la app

class OpcionesSesionPage extends StatefulWidget {
  @override
  _OpcionesSesionPageState createState() => _OpcionesSesionPageState();
}

class _OpcionesSesionPageState extends State<OpcionesSesionPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Función para iniciar sesión con Google
  Future<void> _signInWithGoogle() async {
    try {
      // Cerrar sesión de Google si ya hay una sesión activa
      await _googleSignIn.signOut();

      // Iniciar el flujo de inicio de sesión con Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // El usuario canceló el flujo de inicio de sesión
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Guardar los datos del usuario en Firestore
        await _saveUserData(user);

        // Redirigir al HomePage si el inicio de sesión fue exitoso
        Navigator.pushReplacementNamed(context, HomePage.routename);
      }
    } catch (e) {
      print("Error al iniciar sesión con Google: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión con Google')),
      );
    }
  }

  // Guardar los datos del usuario en Firestore
  Future<void> _saveUserData(User user) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('user').doc(user.uid).get();

      if (!userDoc.exists) {
        await _firestore.collection('user').doc(user.uid).set({
          'email': user.email,
          'username': user.displayName ?? 'Usuario',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print("Error al guardar los datos del usuario en Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo e icono
                Image.asset(
                  'assets/logo.png', // Reemplaza con tu imagen de logo
                  height: 100,
                ),
                SizedBox(height: 20),
                // Título de la aplicación
                Text(
                  'EnSEÑA',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                // Slogan
                Text(
                  '"El lenguaje de las manos, al alcance de todos"',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                // Botón de Iniciar sesión con Google
                ElevatedButton.icon(
                  onPressed: () async {
                    await _signInWithGoogle(); // Ejecuta la lógica de Google Sign-In
                  },
                  icon: Image.asset(
                    'assets/google_icon.png', // Icono de Google (asegúrate de tenerlo)
                    height: 24,
                  ),
                  label: Text(
                    'Iniciar sesión con Google',
                    style: TextStyle(color: Colors.black), // Texto negro
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Botón blanco
                    minimumSize: Size(double.infinity, 50), // Ancho completo y altura fija
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Botón de Iniciar sesión con correo
                ElevatedButton.icon(
                  onPressed: () {
                    // Navegar a la página de inicio de sesión con correo
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  icon: Icon(
                    Icons.email, // Icono de correo a la izquierda
                    color: Colors.white, // Color blanco para el icono
                  ),
                  label: Text(
                    'Iniciar sesión con correo electrónico',
                    style: TextStyle(
                      color: Colors.white, // Cambiar el texto a blanco
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent, // Color del botón rojo
                    minimumSize: Size(double.infinity, 50), // Ancho completo y altura fija
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Texto de registrarse
                GestureDetector(
                  onTap: () {
                    // Navegar a la página de registro
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistroPages()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: '¿No tienes cuenta? ',
                      style: TextStyle(color: Colors.white70),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Regístrate aquí',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
