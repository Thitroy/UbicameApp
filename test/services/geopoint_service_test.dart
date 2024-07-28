import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ubicameapp/models/geopoint_model.dart';
import 'package:ubicameapp/services/geopoint_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'geopoint_service_test.mocks.dart';
import '../firebase_test_setup.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GeoPointService', () {
    late FirebaseApp app;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference mockCollection;
    late MockDocumentReference mockDocument;
    late MockQuerySnapshot mockQuerySnapshot;
    late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;
    late GeoPointService geopointService;

    setUpAll(() async {
      app = await initializeTestFirebase();
      mockFirestore = MockFirebaseFirestore();
    });

    setUp(() {
      mockCollection = MockCollectionReference();
      mockDocument = MockDocumentReference();
      mockQuerySnapshot = MockQuerySnapshot();
      mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();

      // Asegúrate de que el tipo de any coincida con el tipo esperado.
      when(mockFirestore.collection(any as String)).thenReturn(mockCollection);
      geopointService = GeoPointService();
    });

    tearDownAll(() async {
      await app.delete();
    });

    test('should add a geopoint', () async {
      final geopoint = GeoPointModel(
        id: 'test-id',
        name: 'Test',
        location: GeoPoint(10.0, 20.0),
      );

      // Asegúrate de que el tipo de any coincida con el tipo esperado.
      when(mockCollection.add(any as Map<String, dynamic>))
          .thenAnswer((_) async => mockDocument);

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
      // Asegúrate de que el tipo de any coincida con el tipo esperado.
      when(mockDocument.update(any as Map<String, dynamic>))
          .thenAnswer((_) async => null);

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
