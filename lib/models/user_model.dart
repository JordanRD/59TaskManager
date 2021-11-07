import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    this.userId,
    this.username = '',
    this.role,
    this.uniqKey,
  });

  String? userId;
  String? username;
  String? uniqKey;
  String? role;

  UserModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    var task = documentSnapshot.data() as Map;
    userId = documentSnapshot.id;
    username = task["username"];
    role = task["role"];
    uniqKey = task["uniq_key"];
  }
}
