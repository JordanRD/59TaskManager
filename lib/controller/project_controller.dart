import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/controller/auth_controller.dart';
import 'package:limasembilan_todo_app/models/project_model.dart';
import 'package:limasembilan_todo_app/models/user_model.dart';
import 'package:limasembilan_todo_app/services/firebase_instances.dart';
import 'package:limasembilan_todo_app/shared/constants.dart';

class ProjectController extends GetxController {
  CollectionReference projectInstance = FirebaseInstance().projects;
  RxList<ProjectModel> projects = <ProjectModel>[].obs;
  AuthController authC = Get.find<AuthController>();

  _getUsersProject(UserModel user) {
    if (user.role == Role.admin) {
      projectInstance.snapshots().listen((QuerySnapshot querySnapshot) {
        projects.value = querySnapshot.docs
            .map((e) => ProjectModel.fromDocumentSnapshot(e))
            .toList();
      });
    } else {
      projectInstance
          .where('contributors', arrayContains: user.userId)
          .snapshots()
          .listen((QuerySnapshot querySnapshot) {
        projects.value = querySnapshot.docs
            .map((e) => ProjectModel.fromDocumentSnapshot(e))
            .toList();
      });
    }
  }

  @override
  void onInit() {
    _getUsersProject(authC.loggedUser.value);
    ever(authC.loggedUser, (UserModel user) {
      _getUsersProject(authC.loggedUser.value);
    });
    super.onInit();
  }
}
