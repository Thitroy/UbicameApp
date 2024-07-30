import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '/pages/chat_screen.dart';
import '/pages/google_map_page.dart';
import '/pages/preguntas_frecuentes.dart';
import '/pages/ubicaciones_frecuentes.dart';
import 'dart:ui';
import 'register_screen.dart';

class HomeScreen extends StatefulWidget {
  final String role;

  const HomeScreen({super.key, required this.role});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video.mp4')
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, "chat");
        break;
      case 1:
        Navigator.pushNamed(context, "preguntas");
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UbicacionesFrecuentes()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: _controller.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : Container(color: Colors.black),
          ),
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  color: Colors.blueGrey.withOpacity(0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/logo.png',
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Ubícame UBB',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.map, color: Colors.white),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              '¿Quieres conocer la ruta para llegar a un punto de interés en la universidad?',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.school, color: Colors.white),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              '¿No sabes qué necesitas para realizar un trámite en la universidad?',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.chat, color: Colors.white),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              '¡Pregunta a nuestro Chatbot Ubícame UBB y él podrá resolver tus dudas!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: widget.role == 'admin'
            ? const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.help),
                  label: 'Preguntas',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.location_city),
                  label: 'Ubicaciones',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_add),
                  label: 'Crear Usuario',
                ),
              ]
            : const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.help),
                  label: 'Preguntas',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.location_city),
                  label: 'Ubicaciones',
                ),
              ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.indigo[800], // Azul oscuro
        onTap: _onItemTapped,
      ),
    );
  }
}
