import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ensena_grupo3/pages/login_page.dart';
import 'package:ensena_grupo3/preferences/pref_usuarios.dart';
import 'package:http/http.dart' as http;
import 'package:ensena_grupo3/util/auth.dart';
import 'package:ensena_grupo3/pages/configuracion.dart'; 

class HomePage extends StatelessWidget {
  @override
  static const String routename = 'Home'; 

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('¡Bienvenido de vuelta!'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                // Navegar a la página de configuración
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConfiguracionPage()), // Asegúrate de tener esta clase creada
                );
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/PROFILE1.png'), // imagen del icono de usuario
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.lightBlue[50], // Cambia el fondo a un tono más suave
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección de cursos
              Text(
                'Usuario',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildCourseCard(
                    context,
                    'Inglés 1',
                    'Próximamente',
                    'assets/ingles_lenguaje.png', // Icono con banderas para Inglés
                    Colors.blueAccent, // Color personalizado para la tarjeta
                  ),
                  _buildCourseCard(
                    context,
                    'Lengua de señas Chilena',
                    'Iniciar',
                    'assets/chile_lenguaje.png', // Icono con la bandera chilena
                    Colors.redAccent, // Color personalizado para la tarjeta
                  ),
                ],
              ),
              SizedBox(height: 30),
              // Sección de nuevas funcionalidades
              Text(
                'Nuevas funcionalidades',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 20),
              _buildFeatureCard(
                context,
                'Tu primera frase en lengua de señas',
                'Inteligencia Artificial',
                'assets/sign_language_image.png', // Imagen representativa de señas
              ),
              SizedBox(height: 30),
              _buildComingSoonSection(),
            ],
          ),
        ),
      ),
    );
  }

  // Método para crear tarjetas de cursos con imágenes
  Widget _buildCourseCard(BuildContext context, String title, String subtitle, String imagePath, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: color, // Aplica el color personalizado a cada tarjeta
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 50), // Muestra la imagen personalizada
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 5),
            Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  // Método para crear la tarjeta de funcionalidad
  Widget _buildFeatureCard(BuildContext context, String title, String subtitle, String imagePath) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset(imagePath, height: 80), // Muestra la imagen personalizada para las señas
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Sección de "Próximamente"
  Widget _buildComingSoonSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Próximamente...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
