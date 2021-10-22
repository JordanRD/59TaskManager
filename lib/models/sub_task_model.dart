import 'package:cloud_firestore/cloud_firestore.dart';

class SubTaskModel {
  late String subTaskId;
  late int dueDate;
  late int? createDate;
  String title = '';
  late bool isCompleted;

  SubTaskModel(
    this.subTaskId,
    this.dueDate,
    this.title,
    this.isCompleted,
  );

  SubTaskModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    var task = documentSnapshot.data() as Map;
    subTaskId = documentSnapshot.id;
    title = task["title"];
    isCompleted = task["is_completed"];
    dueDate = task["due_date"];
    createDate = task["create_date"];
  }
}
