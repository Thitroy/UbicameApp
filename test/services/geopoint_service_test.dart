// test/services/geopoint_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ubicameapp/models/geopoint_model.dart';
import 'package:ubicameapp/services/geopoint_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'geopoint_service_test.mocks.dart';

void main() {
  group('GeoPointService', () {
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockCollection;
    late MockDocumentReference<Map<String, dynamic>> mockDocument;
    late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
    late MockQueryDocumentSnapshot<Map<String, dynamic>> mockQueryDocumentSnapshot;
    late GeoPointService geopointService;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollection = MockCollectionReference<Map<String, dynamic>>();
      mockDocument = MockDocumentReference<Map<String, dynamic>>();
      mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
      mockQueryDocumentSnapshot = MockQueryDocumentSnapshot<Map<String, dynamic>>();

      when(mockFirestore.collection(any)).thenReturn(mockCollection);
      geopointService = GeoPointService();
    });

    test('should add a geopoint', () async {
      final geopoint = GeoPointModel(
        id: 'test-id',
        name: 'Test',
        location: GeoPoint(10.0, 20.0),
      );

      when(mockCollection.add(any)).thenAnswer((_) async => mockDocument);

      await geopointService.addGeoPoint(geopoint);

      verify(mockCollection.add(geopoint.toMap())).called(1);
    });

    test('should update a geopoint', () async {
      final geopoint = GeoPointModel(
        id: 'test-id',
        name: 'Test',
        location: GeoPoint(10.0, 20.0),
      );

      when(mockCollection.doc(geopoint.id)).thenReturn(mockDocument);
      when(mockDocument.update(any)).thenAnswer((_) async => null);

      await geopointService.updateGeoPoint(geopoint);

      verify(mockDocument.update(geopoint.toMap())).called(1);
    });

    test('should delete a geopoint', () async {
      final geopointId = 'test-id';

      when(mockCollection.doc(geopointId)).thenReturn(mockDocument);
      when(mockDocument.delete()).thenAnswer((_) async => null);

      await geopointService.deleteGeoPoint(geopointId);

      verify(mockDocument.delete()).called(1);
    });

    test('should get all geopoints', () async {
      final geopointData = {
        'name': 'Test',
        'location': GeoPoint(10.0, 20.0),
      };

      when(mockCollection.snapshots()).thenAnswer(
        (_) => Stream.value(mockQuerySnapshot),
      );

      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
      when(mockQueryDocumentSnapshot.data()).thenReturn(geopointData);
      when(mockQueryDocumentSnapshot.id).thenReturn('test-id');

      final stream = geopointService.getGeoPoints();

      expectLater(
        stream,
        emits([
          GeoPointModel.fromMap(geopointData, 'test-id'),
        ]),
      );
    });
  });
}
