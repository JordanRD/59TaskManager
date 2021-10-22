import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:limasembilan_todo_app/shared/constants.dart';

class TaskModel {
  late String userId;
  String username = '';
  String role = Role.user;

  TaskModel(
    this.userId,
    this.username,
    this.role,
  );

  TaskModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    var task = documentSnapshot.data() as Map;
    userId = documentSnapshot.id;
    username = task["username"];
    role = task["role"];
  }
}
