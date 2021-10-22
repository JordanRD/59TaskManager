import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  String? projectId;
  String? name;

  ProjectModel({
    this.projectId,
    this.name,
  });

  ProjectModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    var task = documentSnapshot.data() as Map;
    // print('ininih ${task.toString()}');
    projectId = documentSnapshot.id;
    name = task["title"];
  }
}
