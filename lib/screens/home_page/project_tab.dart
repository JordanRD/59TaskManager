import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/controller/project_controller.dart';
import 'package:limasembilan_todo_app/controller/user_controller.dart';
import 'package:limasembilan_todo_app/models/project_model.dart';
import 'package:limasembilan_todo_app/routes/app_route.dart';
import 'package:limasembilan_todo_app/shared/app_theme.dart';

class ProjectTab extends StatelessWidget {
  const ProjectTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AuthController authC = Get.find<AuthController>();
    ProjectController projectC = Get.find<ProjectController>();
    return Obx(() {
      // List<ProjectModel> projects = projectC.projects;
      // debugPrint(projects.length.toString());
      return Container(
        padding: const EdgeInsets.only(
          right: 30,
          left: 30,
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 30),
            Text(
              'Projects',
              style: TextStyle(
                fontSize: TextSize.heading1,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 30),
            StaggeredGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: projectC.projects
                  .map((project) => _buildProjectCard(project))
                  .toList(),
            )
          ],
        ),
      );
    });
  }

  Widget _buildProjectCard(ProjectModel project) {
    final users = Get.find<UserController>();
    final contributorsCount = project.contributors!.fold(
        0,
        (int p, ids) =>
            users.users.any((user) => user.userId == ids) ? (p + 1) : p);
    return InkWell(
      onTap: () {
        Get.toNamed(RouteNames.projectDetail + '/${project.projectId}');
      },
      borderRadius: BorderRadius.circular(15),
      child: Ink(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [AppStyle.defaultShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              project.name ?? '',
              style: const TextStyle(
                fontSize: TextSize.heading4,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              '$contributorsCount contributors',
              style: const TextStyle(
                fontSize: TextSize.body2,
                color: AppColor.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
