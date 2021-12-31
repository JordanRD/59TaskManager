import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  String? projectId;
  String? name;
  List<String>? contributors;

  ProjectModel({
    this.projectId,
    this.name,
    this.contributors = const [],
  });

  // static toMap(String name, List<String> contributors) {
  //   return {'name': name, 'contributors': contributors};
  // }

  ProjectModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    var project = documentSnapshot.data() as Map;
    projectId = documentSnapshot.id;
    name = project["name"];
    contributors = List<String>.from(project['contributors'] ?? []);
  }
}
