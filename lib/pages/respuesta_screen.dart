import 'package:flutter/material.dart';
//import 'package:ubicameapp/preferences/pref_users.dart';

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
          style: TextStyle(color: Colors.white), // TÃ­tulo en blanco
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
