import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/util/snackbar.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailEmpty = false;

  Future<void> _resetPassword() async {
    setState(() {
      _isEmailEmpty = _emailController.text.isEmpty;
    });

    if (_isEmailEmpty) {
      showSnackBar(context, "Por favor, ingrese su correo electrónico");
    } else {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim(),
        );
        showSnackBar(context, "Correo de recuperación enviado.");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showSnackBar(
              context, "No existe un usuario con ese correo electrónico.");
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
          'Restablecer Contraseña',
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
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: _isEmailEmpty ? Colors.red : Colors.transparent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: _isEmailEmpty ? Colors.red : Colors.transparent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _resetPassword,
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
                  child: const Text('Enviar Correo de Recuperación'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
