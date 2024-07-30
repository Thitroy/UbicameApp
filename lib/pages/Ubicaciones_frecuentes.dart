import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add_edit_ubicacion_screen.dart';
import '/preferences/pref_users.dart';

class UbicacionesFrecuentes extends StatefulWidget {
  @override
  _UbicacionesFrecuentesState createState() => _UbicacionesFrecuentesState();
}

class _UbicacionesFrecuentesState extends State<UbicacionesFrecuentes> {
  late GoogleMapController _mapController;
  final LatLng _initialPosition = LatLng(-36.8212801, -73.0141550);
  final String role = PreferencesUsers().role;
  LatLng? _selectedLocation;
  Set<Marker> _markers = Set();
  Set<Polyline> _polylines = Set();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _updateMarkersAndRoute(LatLng location) async {
    Set<Marker> newMarkers = {
      Marker(
        markerId: MarkerId('selectedLocation'),
        position: location,
        infoWindow: InfoWindow(
          title: 'Visitar',
        ),
      ),
    };

    setState(() {
      _markers = newMarkers;
      _polylines.clear(); // Clear previous polylines
    });

    if (_initialPosition != null) {
      await _getDirections(_initialPosition, location);
    }
  }

  Future<void> _getDirections(LatLng origin, LatLng destination) async {
    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=AIzaSyC_DKpvMsOUkyeAT8snr7-0du61pEYq5Mc',
      ),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final points = data['routes'][0]['overview_polyline']['points'];
        final List<PointLatLng> result = decodePolyline(points);
        setState(() {
          _polylines = {
            Polyline(
              polylineId: PolylineId('route'),
              points:
                  result.map((e) => LatLng(e.latitude, e.longitude)).toList(),
              color: Colors.blue,
              width: 5,
            ),
          };
        });
      } else {
        throw Exception('Failed to load directions: ${data['status']}');
      }
    } else {
      throw Exception('Failed to load directions: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ubicaciones Frecuentes"),
        backgroundColor: Colors.indigo[800],
        foregroundColor: Colors.white,
        actions: role == 'admin'
            ? [
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () => _navigateToAddEditUbicacion(context),
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 14,
              ),
              markers: _markers,
              polylines: _polylines,
              onMapCreated: (controller) {
                _mapController = controller;
                _goToLocation(_initialPosition);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('ubicaciones_frecuentes')
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
                      child: Text('No hay ubicaciones disponibles',
                          style: TextStyle(color: Colors.white)));
                }
                var ubicaciones = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: ubicaciones.length,
                  itemBuilder: (context, index) {
                    var ubicacion = ubicaciones[index];
                    final latLng = ubicacion['direccion']
                        .split(',')
                        .map((str) => double.parse(str))
                        .toList();
                    final location = LatLng(latLng[0], latLng[1]);
                    return ListTile(
                      title: Text(
                        ubicacion['nombre'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        ubicacion['direccion'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[300],
                        ),
                      ),
                      tileColor: Colors.indigo[600],
                      onTap: () {
                        _updateMarkersAndRoute(location);
                        _goToLocation(location);
                      },
                      trailing: role == 'admin'
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.white),
                                  onPressed: () => _navigateToAddEditUbicacion(
                                    context,
                                    id: ubicacion.id,
                                    nombre: ubicacion['nombre'],
                                    direccion: ubicacion['direccion'],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color: const Color.fromARGB(
                                          255, 240, 80, 69)),
                                  onPressed: () =>
                                      _deleteUbicacion(ubicacion.id),
                                ),
                              ],
                            )
                          : null,
                    );
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

  Future<void> _goToLocation(LatLng position) async {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: position, zoom: 15),
    ));
  }

  void _navigateToAddEditUbicacion(BuildContext context,
      {String? id, String? nombre, String? direccion}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditUbicacionScreen(
          id: id,
          nombre: nombre,
          direccion: direccion,
        ),
      ),
    );
  }

  void _deleteUbicacion(String id) async {
    await FirebaseFirestore.instance
        .collection('ubicaciones_frecuentes')
        .doc(id)
        .delete();
  }
}

// Helper function to decode polyline
List<PointLatLng> decodePolyline(String encoded) {
  List<PointLatLng> poly = [];
  int index = 0, len = encoded.length;
  int lat = 0, lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;

    poly.add(PointLatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
  }
  return poly;
}

class PointLatLng {
  final double latitude;
  final double longitude;

  PointLatLng(this.latitude, this.longitude);
}
