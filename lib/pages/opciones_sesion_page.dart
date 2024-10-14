import 'package:flutter/material.dart';
import 'package:ensena_grupo3/pages/login_page.dart';
import 'package:ensena_grupo3/pages/register_page.dart'; // Pantalla de registro (RegistroPages)

class OpcionesSesionPage extends StatelessWidget {
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
                  onPressed: () {
                    // Implementar la lógica de Google Sign-In
                  },
                  icon: Image.asset(
                    'assets/google_icon.png', // Icono de Google (reemplázalo)
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
                // Botón de Iniciar sesión con mail (cambiado a blanco y con ícono a la izquierda)
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
