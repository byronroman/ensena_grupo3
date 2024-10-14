import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConfiguracionPage extends StatelessWidget {
  static const String routename = 'configuracion'; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuraciones'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // Cerrar sesión
              Navigator.of(context).pushReplacementNamed('/login'); // Redirigir a la página de inicio de sesión
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text('Cambiar contraseña'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Aquí puedes implementar la lógica para cambiar la contraseña
              },
            ),
            Divider(),
            ListTile(
              title: Text('Notificaciones'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Aquí puedes implementar la lógica para gestionar notificaciones
              },
            ),
            Divider(),
            ListTile(
              title: Text('Ayuda'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Aquí puedes implementar la lógica para acceder a ayuda
              },
            ),
            Divider(),
            // Agrega más opciones de configuración según lo necesites
          ],
        ),
      ),
    );
  }
}
