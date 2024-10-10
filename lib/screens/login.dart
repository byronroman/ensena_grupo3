import 'package:flutter/material.dart';
import 'register.dart';

class Login extends StatelessWidget {
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 100), // Logo
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
              ElevatedButton.icon(
                onPressed: () {}, // Aquí irá la función de Google Sign-in
                icon: Icon(Icons.email),
                label: Text('Iniciar sesión con Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,  // Usa backgroundColor en lugar de primary
                  foregroundColor: Colors.black,  // Usa foregroundColor en lugar de onPrimary
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {}, // Aquí irá la función para iniciar sesión con mail
                child: Text('Iniciar sesión con mail'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,  // Usa backgroundColor en lugar de primary
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Navega a la pantalla de registro
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
                child: Text(
                  '¿No tienes cuenta? Regístrate aquí',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
