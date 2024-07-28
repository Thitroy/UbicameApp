import 'package:cloud_firestore/cloud_firestore.dart';

class GeoPointModel {
  String id;
  String name;
  GeoPoint location;

  GeoPointModel({
    required this.id,
    required this.name,
    required this.location,
  });

  factory GeoPointModel.fromMap(Map<String, dynamic> data, String documentId) {
    return GeoPointModel(
      id: documentId,
      name: data['name'],
      location: data['location'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
    };
  }
}
