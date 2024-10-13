import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Para autenticación en Firebase
import 'home.dart';  // Pantalla de inicio a la que se navega después del login
import 'register_page.dart';  // Pantalla de registro
import 'package:cloud_firestore/cloud_firestore.dart';  // Firestore para obtener datos del usuario
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ensena_grupo3/pages/home.dart';
import 'package:ensena_grupo3/pages/register_page.dart';
import 'package:ensena_grupo3/util/snackbar.dart';
import 'package:ensena_grupo3/util/auth.dart';

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
        // Navegar a la pantalla de inicio
        Navigator.pushReplacementNamed(context, HomePage.routename);
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/logo.png', height: 100), // Logo de la aplicación
                  const SizedBox(height: 20), // Espaciado entre el logo y el título
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

                  // Formulario de inicio de sesión
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Campo de correo electrónico
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

                        // Campo de contraseña
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

                  // Botón de inicio de sesión
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        _loginUser();
                      }
                    },
                    child: const Text('Iniciar sesión'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Botón para ir a la pantalla de registro
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegistroPages()), // Pantalla de registro
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: '¿No tienes cuenta? ',
                        style: TextStyle(color: const Color.fromARGB(255, 209, 209, 209)),
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
      ),
    );
  }
}
