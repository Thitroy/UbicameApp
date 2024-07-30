import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/preferences/pref_users.dart';
import 'respuesta_screen.dart';

// Clase PreguntasFrecuentes
class PreguntasFrecuentes extends StatefulWidget {
  @override
  _PreguntasFrecuentesState createState() => _PreguntasFrecuentesState();
}

class _PreguntasFrecuentesState extends State<PreguntasFrecuentes> {
  final String role = PreferencesUsers().role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Preguntas Frecuentes",
          style: TextStyle(color: Colors.white), // Título en blanco
        ),
        backgroundColor: Colors.indigo[800], // Azul marino oscuro
        iconTheme: IconThemeData(color: Colors.white), // Flecha en blanco
        actions: role == 'admin'
            ? [
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white), // Icono en blanco
                  onPressed: () => _navigateToAddEditPregunta(context),
                )
              ]
            : null,
      ),
      backgroundColor: Colors.indigo[500], // Azul claro
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('preguntas_frecuentes')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.white)));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text('No hay preguntas frecuentes disponibles',
                    style: TextStyle(color: Colors.white)));
          }
          var preguntas = snapshot.data!.docs;
          return ListView.builder(
            itemCount: preguntas.length,
            itemBuilder: (context, index) {
              var pregunta = preguntas[index];
              return ListTile(
                title: Text(pregunta['pregunta'],
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RespuestaScreen(
                        pregunta: pregunta['pregunta'],
                        respuesta: pregunta['respuestas'],
                      ),
                    ),
                  );
                },
                trailing: role == 'admin'
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () => _navigateToAddEditPregunta(
                                context,
                                pregunta.id,
                                pregunta['pregunta'],
                                List<String>.from(pregunta['respuestas'])),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete,
                                color: const Color.fromARGB(255, 240, 80, 69)),
                            onPressed: () => _deletePregunta(pregunta.id),
                          ),
                        ],
                      )
                    : null,
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToAddEditPregunta(BuildContext context,
      [String? id, String? pregunta, List<String>? respuestas]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditPreguntaScreen(
          id: id,
          pregunta: pregunta,
          respuestas: respuestas,
        ),
      ),
    );
  }

  void _deletePregunta(String id) async {
    await FirebaseFirestore.instance
        .collection('preguntas_frecuentes')
        .doc(id)
        .delete();
  }
}

// Clase AddEditPreguntaScreen
class AddEditPreguntaScreen extends StatefulWidget {
  final String? id;
  final String? pregunta;
  final List<String>? respuestas;

  AddEditPreguntaScreen({this.id, this.pregunta, this.respuestas});

  @override
  _AddEditPreguntaScreenState createState() => _AddEditPreguntaScreenState();
}

class _AddEditPreguntaScreenState extends State<AddEditPreguntaScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _preguntaController = TextEditingController();
  final TextEditingController _respuestaController = TextEditingController();
  List<String> _respuestas = [];

  @override
  void initState() {
    super.initState();
    if (widget.pregunta != null) {
      _preguntaController.text = widget.pregunta!;
    }
    if (widget.respuestas != null) {
      _respuestas = List<String>.from(widget.respuestas!);
    }
  }

  bool _isValidPregunta(String pregunta) {
    return pregunta.isNotEmpty &&
        pregunta.length > 1 &&
        pregunta != '.' &&
        !RegExp(r'^\d+$').hasMatch(pregunta);
  }

  bool _isValidRespuesta(String respuesta) {
    return respuesta.isNotEmpty &&
        respuesta.length > 1 &&
        respuesta != '.' &&
        !RegExp(r'^\d+$').hasMatch(respuesta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id == null ? "Añadir Pregunta" : "Editar Pregunta",
          style: TextStyle(color: Colors.white), // Título en blanco
        ),
        backgroundColor: Colors.indigo[800], // Azul marino oscuro
        iconTheme: IconThemeData(color: Colors.white), // Flecha en blanco
      ),
      backgroundColor: Colors.indigo[500], // Azul claro
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _preguntaController,
                decoration: InputDecoration(
                  labelText: "Pregunta",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (!_isValidPregunta(value!)) {
                    return 'Por favor, ingresa una pregunta válida.';
                  }
                  return null;
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _respuestas.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_respuestas[index],
                          style: TextStyle(color: Colors.white)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              _editRespuesta(context, index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete,
                                color: const Color.fromARGB(255, 240, 80, 69)),
                            onPressed: () {
                              setState(() {
                                _respuestas.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              TextFormField(
                controller: _respuestaController,
                decoration: InputDecoration(
                  labelText: "Respuesta",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      !_isValidRespuesta(value)) {
                    return 'Por favor, ingresa una respuesta válida.';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_respuestaController.text.isNotEmpty &&
                      _formKey.currentState!.validate()) {
                    setState(() {
                      _respuestas.add(_respuestaController.text);
                      _respuestaController.clear();
                    });
                  }
                },
                child: Text("Añadir Respuesta"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePregunta,
                child: Text(widget.id == null ? "Guardar" : "Actualizar"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editRespuesta(BuildContext context, int index) {
    TextEditingController editController =
        TextEditingController(text: _respuestas[index]);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Respuesta'),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(labelText: 'Respuesta'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _respuestas[index] = editController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _savePregunta() async {
    if (_preguntaController.text.isNotEmpty &&
        _isValidPregunta(_preguntaController.text)) {
      var pregunta = _preguntaController.text;
      if (widget.id == null) {
        await _firestore.collection('preguntas_frecuentes').add({
          'pregunta': pregunta,
          'respuestas': _respuestas,
        });
      } else {
        await _firestore
            .collection('preguntas_frecuentes')
            .doc(widget.id)
            .update({
          'pregunta': pregunta,
          'respuestas': _respuestas,
        });
      }
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingresa una pregunta válida.')),
      );
    }
  }
}
