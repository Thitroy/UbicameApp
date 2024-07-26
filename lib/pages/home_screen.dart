import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '/pages/chat_screen.dart';
import '/pages/google_map_page.dart';
import '/pages/preguntas_frecuentes.dart';
import '/pages/ubicaciones_frecuentes.dart';
import 'dart:ui';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _controller;

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

  void _onNumberTap(BuildContext context, int number) {
    if (number == 1) {
      Navigator.pushNamed(context, "map");
    } else if (number == 2) {
      Navigator.pushNamed(context, "chat");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Número $number tocado')),
      );
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
          Positioned(
            left: 100,
            top: 200,
            child: GestureDetector(
              onTap: () => _onNumberTap(context, 1),
              child: Container(
                width: 50,
                height: 50,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            left: 200,
            top: 300,
            child: GestureDetector(
              onTap: () => _onNumberTap(context, 2),
              child: Container(
                width: 50,
                height: 50,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    _controller.pause();
                    Navigator.pushNamed(context, "chat").then((_) {
                      _controller.play();
                    });
                  },
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.chat, color: Colors.white),
                  heroTag: 'chatbot',
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: () {
                    _controller.pause();
                    Navigator.pushNamed(context, "map").then((_) {
                      _controller.play();
                    });
                  },
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.location_on, color: Colors.white),
                  heroTag: 'location',
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: () {
                    _controller.pause();
                    Navigator.pushNamed(context, "preguntas").then((_) {
                      _controller.play();
                    });
                  },
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.help, color: Colors.white),
                  heroTag: 'preguntas',
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: () {
                    _controller.pause();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UbicacionesFrecuentes(),
                      ),
                    ).then((_) {
                      _controller.play();
                    });
                  },
                  backgroundColor: Colors.orange,
                  child: const Icon(Icons.location_city, color: Colors.white),
                  heroTag: 'ubicaciones',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
