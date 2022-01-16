
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/controller/add_project_page_controller.dart';
import 'package:limasembilan_todo_app/controller/auth_controller.dart';
import 'package:limasembilan_todo_app/controller/user_controller.dart';
import 'package:limasembilan_todo_app/models/user_model.dart';
import 'package:limasembilan_todo_app/shared/app_theme.dart';

class AddProjectPage extends StatelessWidget {
  const AddProjectPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(AddProjectPageController());
    UserController userC = Get.find<UserController>();
    AuthController authC = Get.find<AuthController>();

    return GetBuilder<AddProjectPageController>(
        builder: (AddProjectPageController controller) {
      final sortedUser = [...userC.users]..sort((a, b) =>
          (a.username ?? 'zzzz').compareTo(b.username ?? a.username ?? 'zzzz'));
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            // color: Colors.cyan,
            width: MediaQuery.of(context).size.width,
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            padding:
                const EdgeInsets.only(left: 30, right: 30, top: 60, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Project',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: TextSize.heading2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 30),
                // const SizedBox(height: 15),
                const Text('Name'),
                TextField(
                  autofocus: true,
                  controller: controller.nameController,
                  decoration: const InputDecoration(
                    hintText: 'name of the project',
                  ),
                ),
                const SizedBox(height: 30),
                const Text('Select Contributors'),
                const SizedBox(height: 15),
                SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      Expanded(
                        child: OverflowBox(
                          maxWidth: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            scrollDirection: Axis.horizontal,
                            itemCount: sortedUser.length,
                            itemBuilder: (context, idx) {
                              UserModel user = sortedUser[idx];
                              bool isSelected = controller.selectedContributors
                                  .contains(user.userId);
                              Color backgroundColor = isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.white;
                              Color fontColor = isSelected
                                  ? Colors.white
                                  : Theme.of(context).primaryColor;
                              debugPrint('ini' +
                                  controller.selectedContributors.toString());
                              return Container(
                                key: ValueKey(user.uniqKey),
                                margin: const EdgeInsets.only(right: 10),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  onTap: () {
                                    if (isSelected) {
                                      controller.selectedContributors
                                          .removeWhere((userId) =>
                                              userId == user.userId &&
                                              userId !=
                                                  authC
                                                      .loggedUser.value.userId);
                                    } else {
                                      controller.selectedContributors
                                          .add(user.userId!);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: backgroundColor,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [AppStyle.defaultShadow],
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 0),
                                    child: Center(
                                        child: Text(
                                      user.username!,
                                      style: TextStyle(color: fontColor),
                                    )),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: controller.addProject,
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    child: const Text(
                      'Create Project',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
