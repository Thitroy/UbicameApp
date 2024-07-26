import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UbicacionesFrecuentes extends StatefulWidget {
  @override
  _UbicacionesFrecuentesState createState() => _UbicacionesFrecuentesState();
}

class _UbicacionesFrecuentesState extends State<UbicacionesFrecuentes> {
  static const List<Map<String, String>> ubicaciones = [
    {"nombre": "DARCA", "direccion": "-36.8212801,-73.0141550"},
    {
      "nombre": "PACE (Edificio Pregrado, primer piso)",
      "direccion": "-36.8214204,-73.0144068"
    },
    {"nombre": "Sala 103AA", "direccion": "-36.8221684,-73.0119627"},
  ];

  late GoogleMapController _mapController;
  final LatLng _initialPosition = LatLng(-36.8212801, -73.0141550);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ubicaciones Frecuentes"),
        backgroundColor: Colors.indigo[800],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom:
                    14, // Ajusta el zoom para que el mapa se muestre correctamente
              ),
              markers: _createMarkers(),
              onMapCreated: (controller) {
                _mapController = controller;
                _goToLocation(
                    _initialPosition); // Centrar el mapa en la ubicación inicial
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: ubicaciones.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    ubicaciones[index]["nombre"]!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    ubicaciones[index]["direccion"]!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[300],
                    ),
                  ),
                  tileColor: Colors.indigo[600],
                  onTap: () {
                    final latLng = ubicaciones[index]["direccion"]!
                        .split(',')
                        .map((str) => double.parse(str))
                        .toList();
                    _goToLocation(LatLng(latLng[0], latLng[1]));
                  },
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.indigo[500],
    );
  }

  Set<Marker> _createMarkers() {
    return ubicaciones.map((ubicacion) {
      final latLng = ubicacion["direccion"]!
          .split(',')
          .map((str) => double.parse(str))
          .toList();
      return Marker(
        markerId: MarkerId(ubicacion["nombre"]!),
        position: LatLng(latLng[0], latLng[1]),
        infoWindow: InfoWindow(
          title: ubicacion["nombre"],
        ),
      );
    }).toSet();
  }

  Future<void> _goToLocation(LatLng position) async {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: position, zoom: 15),
    ));
  }
}
