import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  static const LatLng UBBGloriosa =
      LatLng(-36.822320815816, -73.01327110291612);
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UBBícame APP'),
        backgroundColor: Colors.indigo[800],
        foregroundColor: Colors.white,
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: UBBGloriosa,
          zoom: 15,
        ),
        onMapCreated: (controller) => _mapController.complete(controller),
        markers: {
          const Marker(
            markerId: MarkerId("Universidad del Bío-Bío"),
            position: LatLng(-36.82235516944244, -73.01327110380315),
            infoWindow: InfoWindow(
              title: "UBB",
              snippet: "En Paro",
            ),
          ),
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GoogleMapPage(),
  ));
}
