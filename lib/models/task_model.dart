import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:limasembilan_todo_app/models/sub_task_model.dart';

class TaskModel {
  late String taskId;
  late int? createDate;
  String? title;
  String? description;
  bool isCompleted = false;
  int? dueDate;
  List<SubTaskModel> subTask = <SubTaskModel>[];

  TaskModel([
    this.taskId = '',
    this.title = '',
    this.description = '',
    this.dueDate = 0,
    this.subTask = const [],
    this.createDate = 0,
    this.isCompleted = false,
  ]);

  TaskModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    var task = documentSnapshot.data() as Map;
    taskId = documentSnapshot.id;
    title = task["title"];
    description = task["description"];
    createDate = task["create_date"];
    isCompleted = task["is_completed"] ?? false;
    dueDate = task['due_date'];
    subTask = List<Map>.from(task['sub_task'] ?? [])
        .map<SubTaskModel>((e) => SubTaskModel.fromMap(e))
        .toList();
  }

  Map<String, dynamic> toMap() {
    int now = DateTime.now().millisecondsSinceEpoch;

    return {
      'create_date': createDate ?? now,
      'due_date': dueDate,
      'title': title,
      'description': description,
      'is_completed': isCompleted,
      'sub_task': subTask.map((e) => e.toMap()).toList(),
    };
  }
}
