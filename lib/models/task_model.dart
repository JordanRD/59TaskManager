import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:limasembilan_todo_app/models/sub_task_model.dart';

class TaskModel {
  late String taskId;
  late int? createDate;
  String? title;
  String? description;
  int? dueDate;
  List<SubTaskModel> subTask = <SubTaskModel>[];

  TaskModel(
    this.taskId,
    this.title,
    this.description,
    this.dueDate,
    this.subTask,
  );

  TaskModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    var task = documentSnapshot.data() as Map;
    taskId = documentSnapshot.id;
    title = task["title"];
    description = task["description"];
    createDate = task["create_date"];
    dueDate = task['due_date'];
    subTask = List<Map>.from(task['sub_task'] ?? [])
        .map<SubTaskModel>((e) => SubTaskModel.fromMap(e))
        .toList();
  }
}
