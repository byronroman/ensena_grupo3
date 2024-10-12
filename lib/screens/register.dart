import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Controladores para manejar los datos de entrada de los campos de texto
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Variables de estado para validar los diferentes requisitos
  bool _isUsernameValid = false;  // Verifica si el campo de nombre de usuario es válido
  bool _isEmailValid = false;     // Verifica si el campo de correo es válido (contiene '@')
  bool _isPasswordVisible = false;  // Controla si la contraseña es visible o no
  bool _isLengthValid = false;      // Verifica si la contraseña tiene al menos 8 caracteres
  bool _hasUppercase = false;       // Verifica si la contraseña tiene al menos una letra mayúscula
  bool _hasLowercase = false;       // Verifica si la contraseña tiene al menos una letra minúscula
  bool _hasDigit = false;           // Verifica si la contraseña tiene al menos un número
  bool _hasSpecialChar = false;     // Verifica si la contraseña tiene al menos un carácter especial

  // Método para comprobar si todos los requisitos de la contraseña se cumplen
  bool get _isPasswordValid =>
      _isLengthValid &&
      _hasUppercase &&
      _hasLowercase &&
      _hasDigit &&
      _hasSpecialChar;

  // Validar si el correo tiene un '@'
  void _validateEmail(String email) {
    setState(() {
      _isEmailValid = email.contains('@');  // True si contiene '@', false si no
    });
  }

  // Validar los requisitos de la contraseña
  void _validatePassword(String password) {
    setState(() {
      _isLengthValid = password.length >= 8;  // Al menos 8 caracteres
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));  // Al menos una letra mayúscula
      _hasLowercase = password.contains(RegExp(r'[a-z]'));  // Al menos una letra minúscula
      _hasDigit = password.contains(RegExp(r'[0-9]'));      // Al menos un número
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));  // Carácter especial
    });
  }

  // Validar si el usuario puede registrarse (todos los campos válidos)
  bool _canRegister() {
    return _isUsernameValid && _isEmailValid && _isPasswordValid;
  }

  // Widget que muestra el estado de cada requisito de la contraseña
  Widget _buildPasswordCriteria(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          // Mostrar un check en verde si el criterio se cumple, y una X en rojo si no
          isValid ? Icons.check_circle : Icons.cancel,
          color: isValid ? Colors.green : Colors.red,
        ),
        SizedBox(width: 10), // Espaciado entre el ícono y el texto
        Text(
          text,  // Texto que indica el requisito (ej. "Al menos una letra mayúscula")
          style: TextStyle(
            color: isValid ? Colors.green : Colors.red,  // Verde si es válido, rojo si no
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Variable para verificar si todos los requisitos de la contraseña son válidos
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
            // Fondo con un degradado de azul a morado
            colors: [Colors.blue, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),  // Margen alrededor del contenido
          child: SingleChildScrollView(
            // Permite que la pantalla se desplace si el contenido es grande
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 40),  // Espaciado superior
                Image.asset('assets/logo.png', height: 100),  // Logo de la aplicación
                SizedBox(height: 20),  // Espaciado entre el logo y el texto
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
                SizedBox(height: 40),  // Espaciado antes de los campos de entrada

                // Campo de nombre de usuario
                TextField(
                  controller: _usernameController,
                  onChanged: (value) {
                    // Verifica si el nombre de usuario no está vacío
                    setState(() {
                      _isUsernameValid = value.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Ingresa tu nombre de usuario',
                    prefixIcon: Icon(Icons.person),  // Ícono de usuario a la izquierda
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),  // Fondo blanco semitransparente
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,  // Mostrar etiqueta flotante
                  ),
                ),
                SizedBox(height: 10),  // Espaciado entre los campos

                // Campo de correo electrónico
                TextField(
                  controller: _emailController,
                  onChanged: _validateEmail,  // Validar correo mientras se escribe
                  decoration: InputDecoration(
                    labelText: 'Ingresa tu mail',
                    prefixIcon: Icon(Icons.email),  // Ícono de correo a la izquierda
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),  // Fondo blanco semitransparente
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,  // Mostrar etiqueta flotante
                  ),
                ),

                // Mostrar mensaje de advertencia si el correo no contiene '@'
                if (!_isEmailValid)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,  // Ancho del 80%
                        padding: EdgeInsets.all(10),  // Padding interno
                        decoration: BoxDecoration(
                          color: Colors.red[50],  // Fondo rojo claro
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red, width: 1.5),  // Borde rojo
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning, color: Colors.red),  // Ícono de advertencia
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'El correo debe contener un @',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,  // Texto en rojo
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                SizedBox(height: 10),  // Espaciado entre los campos

                // Campo de contraseña
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,  // Control de visibilidad de la contraseña
                  onChanged: _validatePassword,  // Validar la contraseña mientras se escribe
                  decoration: InputDecoration(
                    labelText: 'Ingresa tu contraseña',
                    prefixIcon: Icon(Icons.lock),  // Ícono de candado a la izquierda
                    suffixIcon: IconButton(
                      // Ícono de ojo para mostrar/ocultar la contraseña
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;  // Cambiar visibilidad
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),  // Fondo blanco semitransparente
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                ),

                SizedBox(height: 10),  // Espaciado entre los campos

                // Contenedor de requisitos de contraseña (se oculta si todos los requisitos se cumplen)
                if (!allCriteriaValid)
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,  // Ajustar ancho al 85%
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: allCriteriaValid
                            ? Colors.green[50]  // Fondo verde claro si todos los criterios se cumplen
                            : Colors.red[50],  // Fondo rojo claro si no se cumplen todos
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: allCriteriaValid ? Colors.green : Colors.red,  // Borde verde o rojo
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
                              color: allCriteriaValid ? Colors.green : Colors.red,  // Texto verde o rojo
                            ),
                          ),
                          SizedBox(height: 10),
                          // Listado de requisitos de la contraseña
                          _buildPasswordCriteria('Al menos 8 caracteres', _isLengthValid),
                          _buildPasswordCriteria('Al menos una letra mayúscula', _hasUppercase),
                          _buildPasswordCriteria('Al menos una letra minúscula', _hasLowercase),
                          _buildPasswordCriteria('Al menos un número', _hasDigit),
                          _buildPasswordCriteria('Al menos un carácter especial', _hasSpecialChar),
                        ],
                      ),
                    ),
                  ),

                SizedBox(height: 20),  // Espaciado entre los campos

                // Botón de registro (solo habilitado si todos los campos son válidos)
                ElevatedButton(
                  onPressed: _canRegister()
                      ? () {
                          // Aquí puedes implementar la lógica para registrar usuarios
                        }
                      : null,  // Botón deshabilitado si no se cumplen los requisitos
                  child: Text('Registrar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canRegister() ? Colors.purple : Colors.grey,  // Color dinámico
                    foregroundColor: Colors.white,  // Texto blanco
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 40),  // Espaciado inferior
              ],
            ),
          ),
        ),
      ),
    );
  }
}
