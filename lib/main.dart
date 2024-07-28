import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart';
import '/pages/chat_screen.dart';
import '/pages/google_map_page.dart';
import '/pages/home_screen.dart';
import '/pages/login_screen.dart';
import '/pages/splash_screen.dart';
import '/pages/preguntas_frecuentes.dart';
import '/pages/ubicaciones_frecuentes.dart';
import '/pages/register_screen.dart';
import '/preferences/pref_users.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PreferencesUsers.init();

  if (await Permission.location.request().isGranted) {
    runApp(const MainApp());
  } else {
    runApp(const PermissionDeniedApp());
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "splash",
      routes: {
        "map": (context) => const GoogleMapPage(),
        "splash": (context) => const SplashScreen(),
        "login": (context) => const LoginScreen(),
        "home": (context) => HomeScreen(
            role:
                PreferencesUsers().role), // Carga el rol desde las preferencias
        "chat": (context) => const ChatScreen(),
        "preguntas": (context) => PreguntasFrecuentes(),
        "ubicaciones": (context) => UbicacionesFrecuentes(),
        "register": (context) =>
            const RegisterScreen(), // Ruta para la pantalla de registro
      },
    );
  }
}

class PermissionDeniedApp extends StatelessWidget {
  const PermissionDeniedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Permiso de Ubicación Denegado'),
        ),
        body: const Center(
          child: Text(
              'Los permisos de ubicación son necesarios para usar esta aplicación.'),
        ),
      ),
    );
  }
}
