import 'package:flutter/material.dart';
import 'package:ubicameapp/preferences/pref_users.dart';
import '/util/snackbar.dart'; // Asegúrate de importar correctamente el archivo snackbar.dart
import '/provider/auth.dart'; // Asegúrate de importar correctamente el paquete provider.dart
import 'package:cloud_firestore/cloud_firestore.dart'; // Asegúrate de importar correctamente el paquete cloud_firestore.dart

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var prefs = PreferencesUsers();
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isUsernameEmpty = false;
  bool _isPasswordEmpty = false;
  bool _isConfirmPasswordEmpty = false;
  bool _isPasswordMismatch = false;

  final AuthService _authService = AuthService();

  Future<void> _register() async {
    setState(() {
      _isUsernameEmpty = _username.isEmpty;
      _isPasswordEmpty = _password.isEmpty;
      _isConfirmPasswordEmpty = _confirmPassword.isEmpty;
      _isPasswordMismatch = _password != _confirmPassword;
    });

    if (_isUsernameEmpty && _isPasswordEmpty && _isConfirmPasswordEmpty) {
      showSnackBar(context, "Por favor, ingrese todos los datos");
    } else if (_isUsernameEmpty) {
      showSnackBar(context, "Por favor, ingrese su usuario");
    } else if (_isPasswordEmpty) {
      showSnackBar(context, "Por favor, ingrese su contraseña");
    } else if (_isConfirmPasswordEmpty) {
      showSnackBar(context, "Por favor, confirme su contraseña");
    } else if (_isPasswordMismatch) {
      showSnackBar(context, "Las contraseñas no coinciden");
    } else {
      // Verificar si el correo ya está registrado en Firestore
      var existingUser = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: _username)
          .get();

      if (existingUser.docs.isNotEmpty) {
        showSnackBar(context, "El correo electrónico ya está en uso.");
      } else {
        var result = await _authService.createAccount(_username, _password);

        if (result == 1) {
          showSnackBar(context, "La contraseña es demasiado débil.");
        } else if (result == 2) {
          showSnackBar(context, "El correo electrónico ya está en uso.");
        } else if (result == null) {
          showSnackBar(context, "Ocurrió un error. Inténtalo de nuevo.");
        } else {
          // Almacenar los datos del usuario en Firestore
          prefs.lastuid = result;
          await FirebaseFirestore.instance.collection('user').doc(result).set({
            'email': _username,
            'password': _password,
            'rol': 'estudiante', // Agregar rol de estudiante por defecto
          });

          // Mostrar un mensaje de éxito y permanecer en la pantalla
          showSnackBar(context, "Usuario registrado exitosamente.");

          // Limpiar los campos de texto
          setState(() {
            _username = '';
            _password = '';
            _confirmPassword = '';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF002B5C),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF002B5C), Color(0xFF003F7F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Opacity(
                  opacity: 0.7, // Opacidad del 70%
                  child: Image(
                    image: AssetImage('assets/logo.png'),
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Usuario',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: _isUsernameEmpty
                                  ? Colors.red
                                  : Colors.transparent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: _isUsernameEmpty
                                  ? Colors.red
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _username = value;
                            _isUsernameEmpty = _username.isEmpty;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: _isPasswordEmpty
                                  ? Colors.red
                                  : Colors.transparent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: _isPasswordEmpty
                                  ? Colors.red
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                            _isPasswordEmpty = _password.isEmpty;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Confirmar Contraseña',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color:
                                  _isConfirmPasswordEmpty || _isPasswordMismatch
                                      ? Colors.red
                                      : Colors.transparent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color:
                                  _isConfirmPasswordEmpty || _isPasswordMismatch
                                      ? Colors.red
                                      : Colors.transparent,
                            ),
                          ),
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            _confirmPassword = value;
                            _isConfirmPasswordEmpty = _confirmPassword.isEmpty;
                            _isPasswordMismatch = _password != _confirmPassword;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          foregroundColor: const Color(0xFF002B5C),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Registrarse'),
                      ),
                    ],
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
