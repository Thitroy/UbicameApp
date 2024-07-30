/*import 'package:flutter/material.dart';

class PreguntasFrecuentes extends StatelessWidget {
  // Convertimos la lista a const
  static const List<Map<String, dynamic>> preguntas = [
    {
      "pregunta": "¿Solicitudes que se realizan en DARCA?",
      "respuestas": [
        {
          "solicitud": "Antecedentes Personales",
          "encargado": "Procedimiento Completo se realiza en DARCA"
        },
        {
          "solicitud": "Convalidación Asignaturas",
          "encargado":
              "Solicitud en Darca y luego el Jefe Carrera cierra el proceso"
        },
        {
          "solicitud": "Conocimientos Relevantes",
          "encargado":
              "Solicitud en Darca y luego el Jefe Carrera cierra el proceso"
        },
        {
          "solicitud": "Cambio Interno/Sede",
          "encargado":
              "Solicitud en DARCA, al ser aceptada, es derivada al Departamento de Pregrado"
        },
        {
          "solicitud": "Continuación De Estudios",
          "encargado":
              "Solicitud en DARCA, al ser aceptada, es derivada con el Decano"
        },
        {
          "solicitud": "Renuncia Definitiva",
          "encargado": "Procedimiento Completo se realiza en DARCA"
        },
      ],
    },
    {
      "pregunta": "¿Certificados que se sacan en DARCA?",
      "respuesta":
          "Tener en cuenta que algunos certificados tienen un valor monetario y tienen un formulario correspondiente requerido",
      "certificados": [
        "De Alumno Regular: Solo se saca por intranet",
        "De Concentración De Notas",
        "De Programas De Asignaturas",
        "De Plan De Estudios"
      ]
    },
    {
      "pregunta": "¿Soporte Claves Intranet y Correo?",
      "respuestas": [
        {
          "solicitud": "Facultad de Ciencias",
          "encargado": "- Víctor Valderrama victorvm@ubiobio.cl"
        },
        {
          "solicitud": "Facultad de Arquitectura",
          "encargado":
              "- Mario Bravo mbravo@ubiobio.cl \n- Jaime Ortega jjorteg@ubiobio.cl \n- Sergio Osorio sosorio@ubiobio.cl"
        },
        {
          "solicitud":
              "Facultad de Ingeniería: Ingeniería Civil Química, Ingeniería Civil en Industrias de la Madera",
          "encargado":
              "- Luis Vera lvera@ubiobio.cl \n- Luis Machuca lmachuca@ubiobio.cl"
        },
        {
          "solicitud": "Facultad de Ingeniería: Ingeniería Civil",
          "encargado": "- Víctor Véjar vvejar@ubiobio.cl"
        },
        {
          "solicitud":
              "Facultad de Ingeniería: Ingeniería Civil Eléctrica, Automatización, Ejecución en Electrónica y Ejecución en Electricidad",
          "encargado":
              "- Karen Yévenes kyevenes@ubiobio.cl \n- Gonzalo Díaz gdiazla@ubiobio.cl"
        },
        {
          "solicitud": "Facultad de Ingeniería: Ingeniería Civil Industrial",
          "encargado": "- Paulo Fuentes pafuentes@ubiobio.cl"
        },
        {
          "solicitud":
              "Facultad de Ingeniería: Ingeniería Civil u Ejecución Mecánica",
          "encargado": "- Daniel Zepeda dzepeda@ubiobio.cl"
        },
        {
          "solicitud": "Facultad de Ciencias Empresariales",
          "encargado":
              "- Véronica Venegas vvenegas@ubiobio.cl \n- Héctor Salazar hsalazar@ubiobio.cl \n- Joseph Orellana jorellana@ubiobio.cl \n- Mario Urra maurra@ubiobio.cl \n- Marco Iturra miturra@ubiobio.cl \n- Karen Kiefer mkiefer@ubiobio.cl \n- Rodrigo Oliva roliva@ubiobio.cl"
        },
      ]
    },
  ];

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
      ),
      backgroundColor: Colors.indigo[500], // Azul claro
      body: ListView.builder(
        itemCount: preguntas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              preguntas[index]["pregunta"]!,
              style: TextStyle(color: Colors.white), // Texto blanco
            ),
            onTap: () {
              // Navegar a la pantalla de respuesta
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RespuestaScreen(
                    pregunta: preguntas[index]["pregunta"]!,
                    respuesta: preguntas[index]["respuestas"] ??
                        [preguntas[index]["respuesta"]],
                    certificados: preguntas[index]["certificados"],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RespuestaScreen extends StatelessWidget {
  final String pregunta;
  final dynamic respuesta;
  final List<dynamic>? certificados;

  const RespuestaScreen(
      {Key? key,
      required this.pregunta,
      required this.respuesta,
      this.certificados})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pregunta,
          style: TextStyle(color: Colors.white), // Título en blanco
        ),
        backgroundColor: Colors.indigo[800], // Azul marino oscuro
        iconTheme: IconThemeData(color: Colors.white), // Flecha en blanco
      ),
      backgroundColor: Colors.indigo[500], // Azul claro
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (respuesta is String)
              Text(
                respuesta,
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
            if (respuesta is List)
              ...respuesta.map((resp) {
                if (resp is String) {
                  return Text(
                    resp,
                    style: TextStyle(color: Colors.white), // Texto blanco
                  );
                } else if (resp is Map) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resp['solicitud'] ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Texto blanco
                        ),
                      ),
                      Text(
                        resp['encargado'] ?? '',
                        style: TextStyle(color: Colors.white), // Texto blanco
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                } else {
                  return SizedBox.shrink();
                }
              }).toList(),
            if (certificados != null) ...[
              SizedBox(height: 16),
              Text(
                "Certificados:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Texto blanco
                ),
              ),
              ...certificados!
                  .map((cert) => Text(
                        cert,
                        style: TextStyle(color: Colors.white), // Texto blanco
                      ))
                  .toList(),
            ],
          ],
        ),
      ),
    );
  }
}
*/
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
                        // certificados: pregunta['certificados'],
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
                                pregunta['respuestas']),
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
      [String? id, String? pregunta, List<dynamic>? respuestas]) {
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
  final List<dynamic>? respuestas;

  AddEditPreguntaScreen({this.id, this.pregunta, this.respuestas});

  @override
  _AddEditPreguntaScreenState createState() => _AddEditPreguntaScreenState();
}

class _AddEditPreguntaScreenState extends State<AddEditPreguntaScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
        child: Column(
          children: [
            TextField(
              controller: _preguntaController,
              decoration: InputDecoration(
                labelText: "Pregunta",
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _respuestas.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_respuestas[index],
                        style: TextStyle(color: Colors.white)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _respuestas.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            TextField(
              controller: _respuestaController,
              decoration: InputDecoration(
                labelText: "Respuesta",
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _respuestas.add(_respuestaController.text);
                  _respuestaController.clear();
                });
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
    );
  }

  void _savePregunta() async {
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
    Navigator.pop(context);
  }
}