import 'package:flutter/material.dart';
import 'register.dart';  // Importa la pantalla de registro

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    // La estructura principal de la pantalla
    body: Container(
      // Contenedor principal que envuelve toda la pantalla
      decoration: BoxDecoration(
        // Fondo degradado de la pantalla (de azul a morado)
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purpleAccent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        // Permite que la pantalla se desplace si el contenido es grande
        child: ConstrainedBox(
          // Asegura que el contenido ocupe al menos el alto total de la pantalla
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Padding(
            padding: const EdgeInsets.all(16.0),  // Margen alrededor del contenido
            child: Column(
              // Alineación de los elementos en el centro
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,  // Asegura que los botones ocupen todo el ancho
              children: [
                // Logo de la aplicación
                Image.asset('assets/logo.png', height: 100),
                const SizedBox(height: 20),  // Espaciado entre el logo y el título
                const Text(
                  'EnSEÑA',
                  style: TextStyle(
                    fontSize: 40,  // Tamaño de fuente grande para el título
                    fontWeight: FontWeight.bold,  // Título en negrita
                    color: Colors.white,  // Color blanco para el texto
                  ),
                  textAlign: TextAlign.center,  // Centrar el texto
                ),
                const Text(
                  'El lenguaje de las manos, al alcance de todos',
                  style: TextStyle(color: Colors.white),  // Texto descriptivo en blanco
                  textAlign: TextAlign.center,  // Centrar el texto
                ),
                const SizedBox(height: 40),  // Espaciado antes de los botones

                // Botón para iniciar sesión con Google
                ElevatedButton.icon(
                  onPressed: () {
                    // Aquí se debe implementar la lógica de inicio de sesión con Google
                  },
                  icon: Image.asset('assets/google_icon.png', height: 24),  // Icono de Google
                  label: const Text('Iniciar sesión con Google'),  // Texto del botón
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,  // Fondo blanco
                    foregroundColor: Colors.black,  // Texto en negro
                  ),
                ),
                const SizedBox(height: 10),  // Espaciado entre los botones

                // Botón para iniciar sesión con correo electrónico
                ElevatedButton.icon(
                  onPressed: () {
                    // Aquí se debe implementar la lógica de inicio de sesión con email
                  },
                  icon: const Icon(Icons.email),  // Icono de correo electrónico
                  label: const Text('Iniciar sesión con correo electrónico'),  // Texto del botón
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 248, 57, 57),  // Fondo rojo
                    foregroundColor: Colors.white,  // Texto en blanco
                  ),
                ),
                const SizedBox(height: 10),  // Espaciado entre los botones

                // Botón para ir a la pantalla de registro
                TextButton(
                  onPressed: () {
                    // Navegar a la pantalla de registro cuando se presiona
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Register()),  // Redirige a la pantalla de registro
                    );
                  },
                  child: RichText(
                    // Texto enriquecido que permite diferentes estilos dentro de una misma línea de texto
                    text: TextSpan(
                      text: '¿No tienes cuenta? ',  // Texto normal en gris
                      style: TextStyle(color: const Color.fromARGB(255, 209, 209, 209)),
                      children: <TextSpan>[
                        // Parte del texto que se destaca (registrarse)
                        TextSpan(
                          text: 'Regístrate aquí',  // Texto destacado
                          style: TextStyle(
                            color: Colors.white,  // Texto en blanco
                            fontWeight: FontWeight.bold,  // Negrita
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
