import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para el SystemChrome
import 'package:firebase_auth/firebase_auth.dart';  // Para autenticación en Firebase
import 'home.dart';  // Pantalla de inicio a la que se navega después del login
import 'register_page.dart';  // Pantalla de registro
import 'package:cloud_firestore/cloud_firestore.dart';  // Firestore para obtener datos del usuario
import 'recuperar_contraseña.dart';  // Pantalla de recuperación de contraseña
import 'opciones_sesion_page.dart';  // Página de Opciones de Sesión para navegar atrás

class Login extends StatefulWidget {
  @override
  static const String routename = 'Login'; 
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Lógica para el inicio de sesión con Firebase
  Future<void> _loginUser() async {
    try {
      // Ocultar el teclado
      FocusScope.of(context).unfocus();

      // Realizar el inicio de sesión
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Obtener el documento del usuario desde Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user?.uid)
          .get();

      // Validar si el documento del usuario existe
      if (userDoc.exists) {
        // Verificar si el widget sigue montado antes de navegar
        if (mounted) {
          Navigator.pushReplacementNamed(context, HomePage.routename);
        }
      } else {
        _showErrorSnackbar('Error: El usuario no tiene datos registrados.');
      }
    } on FirebaseAuthException catch (e) {
      // Manejar errores de Firebase Authentication
      if (e.code == 'user-not-found') {
        _showErrorSnackbar('No existe ningún usuario con este correo.');
      } else if (e.code == 'wrong-password') {
        _showErrorSnackbar('Contraseña incorrecta.');
      } else {
        _showErrorSnackbar('Error en el inicio de sesión: ${e.message}');
      }
    }
  }

  // Mostrar un Snackbar con el mensaje de error
  void _showErrorSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message), backgroundColor: Colors.red);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extiende el cuerpo detrás del AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Fondo transparente
        elevation: 0, // Sin sombra
        systemOverlayStyle: SystemUiOverlayStyle.light, // Hace que el texto de la barra de estado sea blanco
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Navegar hacia la página OpcionesSesionPage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OpcionesSesionPage()),
            );
          },
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light, // Establece el estilo de la barra de estado
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purpleAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset('assets/logo.png', height: 100), // Logo de la aplicación
                    const SizedBox(height: 20), 
                    const Text(
                      'EnSEÑA',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      'El lenguaje de las manos, al alcance de todos',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Ingresa tu correo',
                              prefixIcon: Icon(Icons.email),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa tu correo.';
                              } else if (!value.contains('@')) {
                                return 'El correo debe contener un @.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Ingresa tu contraseña',
                              prefixIcon: Icon(Icons.lock),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa tu contraseña.';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          _loginUser(); // Llama a la función de inicio de sesión
                        }
                      },
                      child: const Text('Iniciar sesión'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    
                    // Botón de "¿Olvidaste tu contraseña?"
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RecuperarContrasena()), 
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: '¿Olvidaste tu contraseña? ',
                          style: TextStyle(color: const Color.fromARGB(255, 209, 209, 209)),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Recupérala aquí',
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
        ),
      ),
    );
  }
}
