import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ensena_grupo3/pages/login_page.dart';
import 'package:ensena_grupo3/preferences/pref_usuarios.dart';
import 'package:http/http.dart' as http;
import 'package:ensena_grupo3/util/auth.dart';
import 'package:ensena_grupo3/pages/login_page.dart';

class HomePage extends StatefulWidget {
  static const String routename = 'home';
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _auth = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    var prefs = PreferenciasUsuario();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido Usuario :)'),
        actions: [
          IconButton(onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.popAndPushNamed(context, Login.routename);
          }, icon: const Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection('Usuarios').doc(prefs.uidUltimo).get(),        
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(!snapshot.hasData){
              return const Center(child: CircularProgressIndicator());
            }else{
              final _data = snapshot.data.data();
              if(_data!.isNotEmpty){
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(_data['email']),
                      SizedBox(height: 200,),
                      
                      ElevatedButton(onPressed: (){
                          try {
                              http.post(
                                Uri.parse('API URL BACKEND'),
                                headers: {
                                  "Content-type":"application/json"
                                },
                                body: jsonEncode({
                                  "token":["YOU TOKEN PHONE"],
                                  "data":{
                                    "title":"NOTI",
                                    "body":"Mensaje desde el dispositivo"
                                  }
                                })
                              );
                          } catch (e) {
                            
                          }
                      }, 
                      child: const Text('Enviar Push'))
                    ],
                  ),
                );
              }else{
                return Container();
              }
            }
          },
        ),
      ),
    );

  }
}