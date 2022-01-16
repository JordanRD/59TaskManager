import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  String? projectId;
  String? name;
  List<String>? contributors;
  String? createBy;

  ProjectModel({
    this.projectId,
    this.name,
    this.contributors = const [],
    this.createBy,
  });

  // static toMap(String name, List<String> contributors) {
  //   return {'name': name, 'contributors': contributors};
  // }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'create_by': createBy,
      'contributors': [],
    };
  }

  ProjectModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    var project = documentSnapshot.data() as Map;
    projectId = documentSnapshot.id;
    name = project["name"];
    createBy = project['create_by'];
    contributors = List<String>.from(project['contributors'] ?? []);
  }
}
