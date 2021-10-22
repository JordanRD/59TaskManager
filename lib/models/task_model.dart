import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  late String taskId;
  late int dueDate;
  late int? createDate;
  String title = '';
  String description = '';
  late bool isCompleted;

  TaskModel(
    this.taskId,
    this.dueDate,
    this.title,
    this.description,
    this.isCompleted,
  );

  TaskModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    var task = documentSnapshot.data() as Map;
    taskId = documentSnapshot.id;
    title = task["title"];
    description = task["description"];
    isCompleted = task["is_completed"];
    dueDate = task["due_date"];
    createDate = task["create_date"];
  }
}
