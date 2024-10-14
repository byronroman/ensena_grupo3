import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Para autenticación en Firebase
import 'home.dart';  // Pantalla de inicio a la que se navega después del login
import 'register_page.dart';  // Pantalla de registro
import 'package:cloud_firestore/cloud_firestore.dart';  // Firestore para obtener datos del usuario
import 'recuperar_contraseña.dart';  // Pantalla de recuperación de contraseña

class Login extends StatefulWidget {
  @override
  static const String routename = 'Login'; 
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  int _failedAttempts = 0; // Contador de intentos fallidos
  bool _isLocked = false; // Bloqueo temporal
  Duration _lockDuration = Duration(seconds: 30); // Duración del bloqueo
  DateTime? _lockEndTime; // Hora en la que se desbloquea

  // Lógica para el inicio de sesión con Firebase
  Future<void> _loginUser() async {
    if (_isLocked) {
      _showCustomDialog(
        context,
        'Demasiados intentos fallidos. Intenta nuevamente en ${_lockEndTime?.difference(DateTime.now()).inSeconds} segundos.',
      );
      return;
    }

    try {
      FocusScope.of(context).unfocus(); // Ocultar el teclado

      // Validar el formulario antes de intentar iniciar sesión
      if (!_formKey.currentState!.validate()) {
        return;
      }

      // Realizar el inicio de sesión
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Reiniciar el contador de intentos fallidos en caso de éxito
      _failedAttempts = 0;

      // Obtener el documento del usuario desde Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user?.uid)
          .get();

      if (userDoc.exists) {
        Navigator.pushReplacementNamed(context, HomePage.routename);
      } else {
        _showCustomDialog(context, 'Error: El usuario no tiene datos registrados.');
      }
    } on FirebaseAuthException catch (e) {
      _handleLoginError(e);
    }
  }

  // Manejo de errores de inicio de sesión
  void _handleLoginError(FirebaseAuthException e) {
    String? errorMessage;

    switch (e.code) {
      case 'user-not-found':
        errorMessage = 'No existe ningún usuario con este correo.';
        break;
      case 'wrong-password':
        _failedAttempts++;
        if (_failedAttempts >= 3) {
          _lockAccount();
          return;
        } else {
          errorMessage = 'Contraseña incorrecta. Intento $_failedAttempts de 3.';
        }
        break;
      case 'invalid-credential':
        errorMessage = 'Las credenciales proporcionadas no son válidas.';
        break;
      case 'invalid-email':
        errorMessage = 'El formato del correo electrónico no es válido.';
        break;
      case 'user-disabled':
        errorMessage = 'La cuenta de este usuario ha sido deshabilitada.';
        break;
      case 'too-many-requests':
        errorMessage = 'Demasiados intentos fallidos. Intenta más tarde.';
        break;
      case 'operation-not-allowed':
        errorMessage = 'El inicio de sesión con correo y contraseña no está habilitado.';
        break;
    }
    
    if (errorMessage != null) {
      _showCustomDialog(context, errorMessage);
    }
  }

  void _lockAccount() {
    _isLocked = true;
    _lockEndTime = DateTime.now().add(_lockDuration);

    _showCustomDialog(
      context,
      'Demasiados intentos fallidos. Cuenta bloqueada por ${_lockDuration.inSeconds} segundos.',
    );

    Future.delayed(_lockDuration, () {
      setState(() {
        _isLocked = false;
        _failedAttempts = 0; // Reiniciar el contador de intentos
      });
    });
  }

  // Diálogo personalizado para mostrar errores
  void _showCustomDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Algo salió mal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.purpleAccent,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                errorMessage,
                style: TextStyle(fontSize: 16, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Aceptar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
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

                  const SizedBox(height: 1),

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

                  // Línea separadora
                  const SizedBox(height: 20), // Espacio antes de la línea
                  Divider(
                    color: Colors.white54, // Color de la línea (puedes ajustarlo)
                    thickness: 1, // Grosor de la línea
                    indent: 50, // Espacio desde la izquierda
                    endIndent: 50, // Espacio desde la derecha
                  ),


                  const SizedBox(height: 2),
                  
                  // Botón de "¿No tienes una cuenta? Regístrate aquí"
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegistroPages()), 
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: '¿No tienes una cuenta? ',
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
