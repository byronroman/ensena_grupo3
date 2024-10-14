
import 'package:flutter/material.dart';
import 'package:ensena_grupo3/util/auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ensena_grupo3/pages/home.dart';
import 'package:ensena_grupo3/pages/login_page.dart';
import 'package:ensena_grupo3/preferences/pref_usuarios.dart';
import 'package:ensena_grupo3/util/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

class RegistroPages extends StatefulWidget {
  @override
  static const String routename = 'RegistroPages'; 
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegistroPages> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isUsernameValid = false;
  bool _isEmailValid = false;
  bool _isPasswordVisible = false;
  bool _isLengthValid = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasDigit = false;
  bool _hasSpecialChar = false;
  bool _hasEmailStarted = false;
  bool _hasPasswordStarted = false;

  // Validación de la contraseña
  bool get _isPasswordValid =>
      _isLengthValid &&
      _hasUppercase &&
      _hasLowercase &&
      _hasDigit &&
      _hasSpecialChar;

  // Validar el email
  void _validateEmail(String email) {
    setState(() {
      _isEmailValid = email.contains('@');
    });
  }

  // Validar la contraseña
  void _validatePassword(String password) {
    setState(() {
      _isLengthValid = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasDigit = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  // Comprobar si se puede registrar
  bool _canRegister() {
    return _isUsernameValid && _isEmailValid && _isPasswordValid;
  }

  // Método que genera el criterio de contraseña
  Widget _buildPasswordCriteria(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          color: isValid ? Colors.green : Colors.red,
        ),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            color: isValid ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  // Lógica para registrar el usuario en Firebase y navegar a Home
  Future<void> _registerUser() async {
    try {
      // Ocultar el teclado al hacer clic en registrar
      FocusScope.of(context).unfocus();

      // Crear cuenta en Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Guardar información adicional en Firestore
      await FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user?.uid)
          .set({
        'username': _usernameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      });

      // Navegar a la pantalla de inicio después del registro
      Navigator.pushReplacementNamed(context, HomePage.routename);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showErrorSnackbar('La contraseña es demasiado débil.');
      } else if (e.code == 'email-already-in-use') {
        _showErrorSnackbar('Este correo ya está en uso.');
      } else {
        _showErrorSnackbar('Error en el registro: ${e.message}');
      }
    }
  }

  // Mostrar un Snackbar de error
  void _showErrorSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message), backgroundColor: Colors.red);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    bool allCriteriaValid = _isLengthValid &&
        _hasUppercase &&
        _hasLowercase &&
        _hasDigit &&
        _hasSpecialChar;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              // Centra el contenido
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente el contenido
                    crossAxisAlignment: CrossAxisAlignment.center, // Centrar horizontalmente el contenido
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 40),
                      Image.asset('assets/logo.png', height: 100), // Logo de la aplicación
                      SizedBox(height: 20),
                      Text(
                        'EnSEÑA',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'El lenguaje de las manos, al alcance de todos',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 40),

                      // Campo de nombre de usuario
                      TextField(
                        controller: _usernameController,
                        onChanged: (value) {
                          setState(() {
                            _isUsernameValid = value.isNotEmpty;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Ingresa tu nombre de usuario',
                          prefixIcon: Icon(Icons.person),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                      ),
                      SizedBox(height: 10),

                      // Campo de correo electrónico
                      TextField(
                        controller: _emailController,
                        onChanged: (value) {
                          if (!_hasEmailStarted) {
                            setState(() {
                              _hasEmailStarted = true;
                            });
                          }
                          _validateEmail(value);
                        },
                        decoration: InputDecoration(
                          labelText: 'Ingresa tu mail',
                          prefixIcon: Icon(Icons.email),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),


                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                      ),

                      // Advertencia de correo
                      if (_hasEmailStarted && !_isEmailValid)
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
                      SizedBox(height: 10),

                      // Campo de contraseña
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        onChanged: (value) {
                          if (!_hasPasswordStarted) {
                            setState(() {
                              _hasPasswordStarted = true;
                            });
                          }
                          _validatePassword(value);
                        },
                        decoration: InputDecoration(
                          labelText: 'Ingresa tu contraseña',
                          prefixIcon: Icon(Icons.lock),
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
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                      ),

                      // Requisitos de la contraseña
                      if (_hasPasswordStarted && !allCriteriaValid)
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: allCriteriaValid ? Colors.green[50] : Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: allCriteriaValid ? Colors.green : Colors.red,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'La contraseña debe tener:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: allCriteriaValid ? Colors.green : Colors.red,
                                  ),
                                ),
                                SizedBox(height: 10),
                                _buildPasswordCriteria('Al menos 8 caracteres', _isLengthValid),
                                _buildPasswordCriteria('Al menos una letra mayúscula', _hasUppercase),
                                _buildPasswordCriteria('Al menos una letra minúscula', _hasLowercase),
                                _buildPasswordCriteria('Al menos un número', _hasDigit),
                                _buildPasswordCriteria('Al menos un carácter especial', _hasSpecialChar),
                              ],
                            ),
                          ),

                        ),

                      SizedBox(height: 20),

                      // Botón de registro
                      ElevatedButton(
                        onPressed: _canRegister() ? _registerUser : null,
                        child: Text('Registrar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canRegister() ? Colors.purple : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // Ícono de retroceso en la parte superior izquierda con padding ajustado
              Positioned(
                top: 40, // Mueve el ícono hacia abajo
                left: 0, // Deja un margen a la izquierda
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);  // Vuelve a la pantalla de login
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
