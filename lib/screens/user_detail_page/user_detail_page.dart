import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/controller/auth_controller.dart';
import 'package:limasembilan_todo_app/controller/user_detail_page_controller.dart';
import 'package:limasembilan_todo_app/models/project_model.dart';
import 'package:limasembilan_todo_app/models/user_model.dart';
import 'package:limasembilan_todo_app/routes/app_route.dart';
import 'package:limasembilan_todo_app/shared/app_theme.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:limasembilan_todo_app/shared/constants.dart';

class UserDetailPage extends StatelessWidget {
  const UserDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UserDetailPageController());
    final authC = Get.find<AuthController>();
    return Scaffold(
      body: GetBuilder<UserDetailPageController>(builder: (controller) {
        final user = controller.currentUser.value;
        final projects = controller.contributedProjects;
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(
              top: 60,
              left: 30,
              right: 30,
              bottom: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: TextSize.heading1,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Visibility(
                      visible: authC.loggedUser.value.role == Role.admin,
                      child: InkWell(
                        child: const Icon(
                          Icons.edit,
                          color: AppColor.textSecondary,
                        ),
                        onTap: () {
                          controller.selectedRole.value =
                              user.role ?? Role.project;
                          controller.usernameController.text =
                              user.username ?? '';
                          controller.update();
                          Get.defaultDialog(
                              title: '',
                              titleStyle: const TextStyle(height: 0),
                              titlePadding: const EdgeInsets.all(0),
                              contentPadding: const EdgeInsets.all(15),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'username',
                                    style: TextStyle(
                                        color: AppColor.textSecondary),
                                  ),
                                  TextField(
                                    controller: controller.usernameController,
                                  ),
                                  const SizedBox(height: 15),
                                  const Text('role',
                                      style: TextStyle(
                                          color: AppColor.textSecondary)),
                                  const SizedBox(height: 15),
                                  Obx(() => Column(
                                        children: [
                                          _buildRoleSelector(
                                              role: Role.admin,
                                              selected: controller
                                                      .selectedRole.value ==
                                                  Role.admin,
                                              onTap: () {
                                                controller.selectedRole.value =
                                                    Role.admin;
                                                controller.update();
                                              }),
                                          const SizedBox(height: 10),
                                          _buildRoleSelector(
                                              role: Role.support,
                                              selected: controller
                                                      .selectedRole.value ==
                                                  Role.support,
                                              onTap: () {
                                                controller.selectedRole.value =
                                                    Role.support;
                                                controller.update();
                                              }),
                                          const SizedBox(height: 10),
                                          _buildRoleSelector(
                                              role: Role.project,
                                              selected: controller
                                                      .selectedRole.value ==
                                                  Role.project,
                                              onTap: () {
                                                controller.selectedRole.value =
                                                    Role.project;
                                                controller.update();
                                              }),
                                        ],
                                      )),
                                  const SizedBox(height: 20),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Get.back(),
                                  child: const Icon(
                                    Icons.chevron_left,
                                    color: AppColor.textSecondary,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    primary: Colors.white,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => controller.deleteUser(),
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: AppColor.textDanger,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    primary: Colors.white,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => controller.updateUser(),
                                  child: const Icon(
                                    Icons.save_outlined,
                                    color: AppColor.primaryColor,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    primary: Colors.white,
                                  ),
                                ),
                              ]);
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                _buildUserCard(user),
                const SizedBox(height: 15),
                const Text(
                  'Contributed Projects',
                  style: TextStyle(
                    fontSize: TextSize.heading4,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 30),
                StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  children: projects
                      .map((project) => _buildProjectCard(project))
                      .toList(),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  InkWell _buildRoleSelector(
      {required String role,
      bool selected = false,
      required void Function() onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? AppColor.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [AppStyle.defaultShadow],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Center(
            child: Text(
          role,
          style: TextStyle(
            color: selected ? Colors.white : AppColor.primaryColor,
            fontSize: TextSize.body2,
          ),
        )),
      ),
    );
  }

  Widget _buildProjectCard(ProjectModel project) {
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
          ],
        ),
      ),
    );
  }

  Container _buildUserCard(UserModel user) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [AppStyle.defaultShadow],
      ),
      padding: const EdgeInsets.all(30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              '${user.username}',
              style: const TextStyle(
                fontSize: TextSize.heading4,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 15),
          Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.verified_user_outlined,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${user.role}',
                    style: const TextStyle(
                      fontSize: TextSize.body2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${user.uniqKey}',
                    style: const TextStyle(
                      fontSize: TextSize.body2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
