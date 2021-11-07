import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  late String taskId;
  late int? createDate;
  String? title;
  String? description;
  String? dueDate;

  TaskModel(
    this.taskId,
    this.title,
    this.description,
    this.dueDate,
  );

  TaskModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    var task = documentSnapshot.data() as Map;
    taskId = documentSnapshot.id;
    title = task["title"];
    description = task["description"];
    createDate = task["create_date"];
  }
}
