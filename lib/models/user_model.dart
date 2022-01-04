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
    var user = documentSnapshot.data() as Map;
    userId = documentSnapshot.id;
    username = user["username"];
    role = user["role"];
    uniqKey = user["uniq_key"];
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'role': role,
      'uniq_key': uniqKey,
    };
  }
}
