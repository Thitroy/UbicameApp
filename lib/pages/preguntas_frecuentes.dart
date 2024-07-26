import 'package:flutter/material.dart';

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
