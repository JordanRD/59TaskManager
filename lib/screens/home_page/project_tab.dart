import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:limasembilan_todo_app/controller/auth_controller.dart';
import 'package:limasembilan_todo_app/controller/project_controller.dart';
import 'package:limasembilan_todo_app/models/project_model.dart';
import 'package:limasembilan_todo_app/shared/app_theme.dart';

class ProjectTab extends StatelessWidget {
  const ProjectTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AuthController authC = Get.find<AuthController>();
    ProjectController projectC = Get.find<ProjectController>();
    return Obx(() {
      List<ProjectModel> projects = projectC.projects;
      debugPrint(projects.length.toString());
      return Container(
        padding: const EdgeInsets.only(right: 30, left: 30, top: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Projects',
              style: TextStyle(
                fontSize: TextSize.heading1,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: GridView.builder(
                  itemCount: projects.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemBuilder: (context, idx) {
                    var project = projects[idx];
                    return Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [AppStyle.defaultShadow],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.name ?? '',
                            style:const TextStyle(
                              fontSize: TextSize.heading3,
                            ),
                          ),
                          Text('${project.contributors!.length} contributors'),
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      );
    });
  }
}
