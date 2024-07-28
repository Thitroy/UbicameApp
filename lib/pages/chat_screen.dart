import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'login_screen.dart';

class Message {
  final String text;
  final bool isUserMessage;
  final bool isAdminMessage;

  Message(this.text, {this.isUserMessage = true, this.isAdminMessage = false});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _showWelcomeMessage = true;
  DialogFlowtter? dialogFlowtter;

  @override
  void initState() {
    super.initState();
    _initializeDialogFlowtter();
  }

  Future<void> _initializeDialogFlowtter() async {
    try {
      DialogAuthCredentials credentials =
          await DialogAuthCredentials.fromFile('assets/');
      dialogFlowtter = DialogFlowtter(credentials: credentials);
      print('DialogFlowtter initialized successfully.');
      setState(() {});
    } catch (e) {
      print('Error loading DialogFlowtter: $e');
      _receiveMessage("Error cargando DialogFlowtter: $e");
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(Message(_controller.text, isUserMessage: true));
        if (_showWelcomeMessage) {
          _showWelcomeMessage = false;
        }
      });

      String userMessage = _controller.text.toLowerCase().trim();
      _controller.clear();

      if (userMessage == 'usuario administrador') {
        _receiveAdminMessage();
      } else {
        _handleDialogflowRequest(userMessage);
      }
    }
  }

  void _handleDialogflowRequest(String query) async {
    try {
      if (dialogFlowtter == null) {
        _receiveMessage("DialogFlowtter no está inicializado.");
        return;
      }

      DetectIntentResponse response = await dialogFlowtter!.detectIntent(
        queryInput: QueryInput(text: TextInput(text: query)),
      );

      print(
          'Detect Intent Response: ${response.toJson()}'); // Imprime la respuesta completa

      String responseMessage = 'No se recibió respuesta.';

      if (response.queryResult != null) {
        responseMessage = _getResponseMessage(response.queryResult!);
      }

      _receiveMessage(responseMessage);
    } catch (e) {
      print("Error en Dialogflow: $e");
      _receiveMessage(
          "Lo siento, no puedo procesar tu solicitud en este momento.");
    }
  }

  String _getResponseMessage(QueryResult queryResult) {
    print(
        'Query Result: ${queryResult.toJson()}'); // Imprime todos los detalles del QueryResult
    if (queryResult.fulfillmentMessages != null &&
        queryResult.fulfillmentMessages!.isNotEmpty) {
      return queryResult.fulfillmentMessages!
          .map((msg) => msg.text?.text)
          .where((msg) => msg != null && msg.isNotEmpty)
          .map((msg) => msg!.first)
          .join('\n');
    }
    return 'No se recibió respuesta.';
  }

  void _receiveMessage(String message) {
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(Message(message, isUserMessage: false));
      });
    });
  }

  void _receiveAdminMessage() {
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(Message('Haz clic en el botón para ir al login.',
            isUserMessage: false, isAdminMessage: true));
      });
    });
  }

  Widget _buildMessage(Message message) {
    if (message.isAdminMessage) {
      return _buildAdminMessage();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
      decoration: BoxDecoration(
        color: message.isUserMessage ? Colors.blue[200] : Colors.grey[300],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Text(
        message.text,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 20.0,
        ),
      ),
    );
  }

  Widget _buildAdminMessage() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Haz clic en el botón para ir al login:',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('Ir a Login'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 10),
            const Text(
              'Chatbot',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF002B5C),
      ),
      body: GestureDetector(
        onTap: () {
          if (_showWelcomeMessage) {
            setState(() {
              _showWelcomeMessage = false;
            });
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF002B5C), Color(0xFF003F7F)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Opacity(
                            opacity: 0.3,
                            child: Image.asset(
                              'assets/chatbot_logo.png',
                              width: 200,
                              height: 200,
                            ),
                          ),
                          if (_showWelcomeMessage)
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Center(
                                child: AnimatedTextKit(
                                  animatedTexts: [
                                    TypewriterAnimatedText(
                                      'Bienvenido al Chatbot UbícameUBB!',
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      speed: const Duration(milliseconds: 100),
                                    ),
                                  ],
                                  totalRepeatCount: 1,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return Align(
                          alignment: message.isUserMessage
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: _buildMessage(message),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onTap: () {
                          if (_showWelcomeMessage) {
                            setState(() {
                              _showWelcomeMessage = false;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Escribe un mensaje...',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
