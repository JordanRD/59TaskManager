import 'package:cloud_firestore/cloud_firestore.dart';

class SubTaskModel {
  late String subTaskId;
  String completedBy = '';
  String title = '';
  late bool isCompleted;

  SubTaskModel(
    this.subTaskId,
    this.title,
    this.isCompleted,
    this.completedBy,
  );

  SubTaskModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    var task = documentSnapshot.data() as Map;
    subTaskId = documentSnapshot.id;
    title = task["title"];
    isCompleted = task["is_completed"];
    completedBy = task['completed_by'];
  }

  SubTaskModel.fromMap(Map task) {
    subTaskId = task['id'];
    title = task["title"];
    isCompleted = task["is_completed"];
    completedBy = task['completed_by'];
  }
  Map toMap() {
    return {
      'id': subTaskId,
      'title': title,
      'is_completed': isCompleted,
      'completed_by': completedBy,
    };
  }
}
