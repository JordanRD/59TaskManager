import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/dialog_confirm.dart';
import 'package:limasembilan_todo_app/storages.dart';

import 'app_theme.dart';
import 'controller/project_controller.dart';
import 'routes/app_route.dart';

class SelectProjectPage extends GetView<ProjectController> {
  const SelectProjectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        width: screenWidth,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 45),
            child: StreamBuilder(
              stream: controller.getAllProject(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                var projects = snapshot.data?.docs;
                if (snapshot.connectionState == ConnectionState.active &&
                    projects != null) {
                  return Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 5,
                    children: [
                      _buildChip(
                        'Baru',
                        context: context,
                        onTap: () {
                          Get.toNamed(RouteNames.addProject);
                        },
                        avatar: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ...projects.map((project) {
                        return _buildChip(
                          project['name'],
                          context: context,
                          onTap: () {
                            ProjectStorage().setProjectId(project.id);
                            Get.toNamed(RouteNames.home);
                          },
                          onLongPress: () async {
                            DialogConfirm.show('Hapus ${project['name']}',
                                onConfirm: () {
                              if (project.id ==
                                  ProjectStorage().getProjectId()) {
                                ProjectStorage().deleteProjectId();
                                controller.deleteProject(project.id);
                                Get.offAllNamed(RouteNames.project);
                              } else {
                                controller.deleteProject(project.id);
                                Get.back();
                              }
                            }, context: context);
                          },
                        );
                      })
                    ],
                  );
                }
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 90,
                  child: Center(
                    child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String? title,
      {required BuildContext context,
      void Function()? onTap,
      void Function()? onLongPress,
      Widget? avatar}) {
    return InkWell(
      highlightColor: Colors.white.withOpacity(0.8),
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(15),
      child: Chip(
        labelPadding: const EdgeInsets.all(5.0),
        avatar: avatar,
        label: Text(
          title ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: TextSize.body2,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 2.0,
        shadowColor: AppColor.darkPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
    );
  }
}
