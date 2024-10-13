import 'package:flutter/material.dart';
import 'package:ensena_grupo3/util/auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ensena_grupo3/pages/home.dart';
import 'package:ensena_grupo3/pages/login_page.dart';
import 'package:ensena_grupo3/preferences/pref_usuarios.dart';
import 'package:ensena_grupo3/util/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistroPages extends StatefulWidget {
  static const String routename = 'registro';
  const RegistroPages({super.key});

  @override
  State<RegistroPages> createState() => _RegistroPagesState();
}

class _RegistroPagesState extends State<RegistroPages> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xff54ace6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            child: Container(
              width: double.infinity,
              height: size.height,
              color: const Color(0xff54ace6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png', scale: 4),
                  const Center(
                    child: Text(
                      'Registro!',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      name: 'user',
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue.shade900),
                              borderRadius: BorderRadius.circular(50)),
                          prefixIcon: Icon(
                            Icons.account_circle_outlined,
                            color: Colors.blue.shade900,
                          ),
                          labelText: 'Usuario',
                          labelStyle: const TextStyle(fontSize: 13),
                          hintText: 'Ejemplo@email.com'),
                      keyboardType: TextInputType.emailAddress,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'Ingrese un usuario'),
                        FormBuilderValidators.email(
                            errorText: 'Correo invalido')
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      name: 'pass',
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue.shade900),
                              borderRadius: BorderRadius.circular(50)),
                          prefixIcon: Icon(
                            Icons.account_circle_outlined,
                            color: Colors.blue.shade900,
                          ),
                          labelText: 'Contraseña',
                          labelStyle: const TextStyle(fontSize: 13)),
                      keyboardType: TextInputType.emailAddress,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'Ingrese una contraseña')
                      ]),
                    ),
                  ),
                  butonlogin(context),
                  SizedBox(height: size.height * 0.1),
                  GestureDetector(
                    onTap: () =>
                        Navigator.popAndPushNamed(context, LoginPage.routename),
                    child: Text(
                      '¿Ya tienes una cuenta?',
                      style: TextStyle(color: Colors.blue.shade900),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton butonlogin(BuildContext context) {
    var prefs = PreferenciasUsuario();
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade900,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
        onPressed: () async {
          _formKey.currentState?.save();
          if (_formKey.currentState?.validate() == true) {
            final v = _formKey.currentState?.value;
            var result = await _auth.createAccount(v?['user'], v?['pass']);
            if (result == 1) {
              showSnackBar(
                  context, 'La contraseña es demasiado débil, prueba con otra :)');
            } else if (result == 2) {
              showSnackBar(context, 'OHH, este mail ya está en uso');
            } else if (result != null) {
              prefs.uidUltimo = result;
              FirebaseFirestore.instance
                  .collection('user')
                  .doc(result)
                  .set({
                'email': v?['user'],
                'password': v?['pass']
              });

              Navigator.popAndPushNamed(context, HomePage.routename);
            }
          }
        },
        child: const Text(
          'Registrarme',
          style: TextStyle(color: Colors.white),
        ));
  }
}
