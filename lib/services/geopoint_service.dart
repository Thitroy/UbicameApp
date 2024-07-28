import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/geopoint_model.dart';

class GeoPointService {
  final CollectionReference geopointsCollection =
      FirebaseFirestore.instance.collection('geopoints');

  Future<void> addGeoPoint(GeoPointModel geopoint) async {
    await geopointsCollection.add(geopoint.toMap());
  }

  Stream<List<GeoPointModel>> getGeoPoints() {
    return geopointsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return GeoPointModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Stream<List<GeoPointModel>> getGeoPointsByName(String name) {
    return geopointsCollection
        .where('name', isEqualTo: name)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return GeoPointModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> updateGeoPoint(GeoPointModel geopoint) async {
    await geopointsCollection.doc(geopoint.id).update(geopoint.toMap());
  }

  Future<void> deleteGeoPoint(String id) async {
    await geopointsCollection.doc(id).delete();
  }
}
