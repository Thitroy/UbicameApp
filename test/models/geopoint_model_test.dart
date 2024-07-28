// test/models/geopoint_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:ubicameapp/models/geopoint_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('GeoPointModel', () {
    test('fromMap creates a GeoPointModel from a map', () {
      final data = {
        'name': 'Test',
        'location': GeoPoint(10.0, 20.0),
      };

      final geopoint = GeoPointModel.fromMap(data, 'test-id');

      expect(geopoint.id, 'test-id');
      expect(geopoint.name, 'Test');
      expect(geopoint.location.latitude, 10.0);
      expect(geopoint.location.longitude, 20.0);
    });

    test('toMap converts a GeoPointModel to a map', () {
      final geopoint = GeoPointModel(
        id: 'test-id',
        name: 'Test',
        location: GeoPoint(10.0, 20.0),
      );

      final map = geopoint.toMap();

      expect(map['name'], 'Test');
      expect(map['location'], GeoPoint(10.0, 20.0));
    });
  });
}