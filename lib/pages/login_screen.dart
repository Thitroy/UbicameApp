import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';
import 'reset_password_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ubicameapp/preferences/pref_users.dart';
import '/util/snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool _isUsernameEmpty = false;
  bool _isPasswordEmpty = false;

  Future<void> _login() async {
    setState(() {
      _isUsernameEmpty = _username.isEmpty;
      _isPasswordEmpty = _password.isEmpty;
    });

    if (_isUsernameEmpty && _isPasswordEmpty) {
      showSnackBar(context, "Por favor, ingrese su usuario y contraseña");
    } else if (_isUsernameEmpty) {
      showSnackBar(context, "Por favor, ingrese su usuario");
    } else if (_isPasswordEmpty) {
      showSnackBar(context, "Por favor, ingrese su contraseña");
    } else {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _username,
          password: _password,
        );
        if (userCredential.user != null) {
          var userDoc = await FirebaseFirestore.instance
              .collection('user')
              .doc(userCredential.user!.uid)
              .get();
          if (userDoc.exists) {
            PreferencesUsers prefs = PreferencesUsers();
            prefs.lastuid = userCredential.user!.uid;
            prefs.role = userDoc['rol']; // Asegúrate de que el campo sea 'rol'

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(
                      role: userDoc[
                          'rol'])), // Asegúrate de que el campo sea 'rol'
            );
          } else {
            showSnackBar(context, "Ocurrió un error. Inténtalo de nuevo.");
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showSnackBar(
              context, "No existe un usuario con ese correo electrónico.");
        } else if (e.code == 'wrong-password') {
          showSnackBar(context, "Contraseña incorrecta.");
        } else {
          showSnackBar(context, "Ocurrió un error. Inténtalo de nuevo.");
        }
      } catch (e) {
        showSnackBar(context, "Ocurrió un error. Inténtalo de nuevo.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inicio de Sesión',
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
                      ElevatedButton(
                        onPressed: _login,
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
                        child: const Text('Iniciar Sesión'),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ResetPasswordScreen()),
                          );
                        },
                        child: const Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
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
