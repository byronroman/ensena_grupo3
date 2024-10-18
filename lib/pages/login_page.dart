import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para el SystemChrome
import 'package:firebase_auth/firebase_auth.dart';  // Para autenticación en Firebase
import 'home.dart';  // Pantalla de inicio a la que se navega después del login
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

  bool _emailError = false;
  bool _passwordError = false;
  bool _hasEmailStarted = false;
  bool _hasPasswordStarted = false;
  bool _isPasswordVisible = false; // Controla la visibilidad de la contraseña

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
        _showErrorDialog('Error: El usuario no tiene datos registrados.');
      }
    } on FirebaseAuthException catch (e) {
      // Manejar errores de Firebase Authentication
      if (e.code == 'user-not-found') {
        _showErrorDialog('No existe ningún usuario con este correo.');
      } else if (e.code == 'wrong-password') {
        _showErrorDialog('Contraseña incorrecta.');
      } else if (e.code == 'invalid-email') {
        _showErrorDialog('El correo electrónico está mal formateado.');
      } else {
        _showErrorDialog('Error en el inicio de sesión: ${e.message}');
      }
    }
  }

  // Mostrar un cuadro de diálogo personalizado con el mensaje de error
    void _showErrorDialog(String message) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ), // Bordes redondeados
            title: Text(
              'Credenciales Incorrectas',
              style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold, // Texto en negrita para el error
                  ),
                  textAlign: TextAlign.center, // Centramos el mensaje de error principal
                ),
                const SizedBox(height: 24), // Espacio más amplio entre los textos
                Text(
                  'Por favor, verifica tu correo y contraseña.',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center, // Centramos el texto de sugerencia
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                },
                child: Text('Aceptar', style: TextStyle(color: Colors.white)),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.purple, // Color de fondo del botón
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ), // Bordes del botón
                ),
              ),
            ],
          );
        },
      );
    }



  // Validar correo
  bool _validateEmail() {
    String email = _emailController.text;
    if (email.isEmpty || !email.contains('@')) {
      setState(() {
        _emailError = true;
        _hasEmailStarted = true;
      });
      return false;
    }
    setState(() {
      _emailError = false;
    });
    return true;
  }

  // Validar contraseña
  bool _validatePassword() {
    String password = _passwordController.text;
    if (password.isEmpty) {
      setState(() {
        _passwordError = true;
        _hasPasswordStarted = true;
      });
      return false;
    }
    setState(() {
      _passwordError = false;
    });
    return true;
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
                          // Campo de correo electrónico
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Ingresa tu correo',  // Cambiamos a hintText para que desaparezca al escribir
                              prefixIcon: Icon(Icons.email),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16), // Ajusta el relleno interno
                              hintStyle: TextStyle(fontSize: 14), // Tamaño del texto de la pista
                            ),
                            onChanged: (_) => _validateEmail(), // Llamada a la función de validación
                          ),

                          if (_hasEmailStarted && _emailError)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.red, width: 1.5),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.warning, color: Colors.red),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          'El correo debe contener un @',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 10),

                          // Campo de contraseña con visibilidad controlada
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible, // Mostrar u ocultar contraseña
                            decoration: InputDecoration(
                              hintText: 'Ingresa tu contraseña',
                              prefixIcon: Icon(Icons.lock),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            onChanged: (_) => _validatePassword(),
                          ),

                          if (_hasPasswordStarted && _passwordError)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.red, width: 1.5),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.warning, color: Colors.red),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          'Por favor, ingresa tu contraseña',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Botón de inicio de sesión
                    ElevatedButton(
                      onPressed: () {
                        if (_validateEmail() && _validatePassword()) {
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
