import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore instance = FirebaseFirestore.instance;

class FirebaseInstance {
  CollectionReference users = instance.collection('users');
  CollectionReference projects = instance.collection('projects');
}
