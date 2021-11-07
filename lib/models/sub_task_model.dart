import 'package:cloud_firestore/cloud_firestore.dart';

class SubTaskModel {
  late String subTaskId;
  late int? createDate;
  String title = '';
  late bool isCompleted;

  SubTaskModel(
    this.subTaskId,
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
    createDate = task["create_date"];
  }
}
