import 'package:flutter/material.dart';
import 'register.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
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
                Image.asset('assets/logo.png', height: 100), // Logo
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
                ElevatedButton.icon(
                  onPressed: () {}, // Aquí irá la función de Google Sign-in
                  icon: const Icon(Icons.email),
                  label: const Text('Iniciar sesión con Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {}, // Aquí irá la función para iniciar sesión con mail
                  child: const Text('Iniciar sesión con mail'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Register()),
                    );
                  },
                  child: const Text(
                    '¿No tienes cuenta? Regístrate aquí',
                    style: TextStyle(color: Colors.white),
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
