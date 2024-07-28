import 'package:mockito/mockito.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockFirebaseApp extends Mock implements FirebaseApp {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference<T> extends Mock implements CollectionReference<T> {}

class MockDocumentReference<T> extends Mock implements DocumentReference<T> {}

class MockQuerySnapshot<T> extends Mock implements QuerySnapshot<T> {}

class MockQueryDocumentSnapshot<T> extends Mock implements QueryDocumentSnapshot<T> {}
