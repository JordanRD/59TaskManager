import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/app_theme.dart';
import 'package:limasembilan_todo_app/controller/project_controller.dart';
import 'package:limasembilan_todo_app/routes/app_route.dart';
import 'package:limasembilan_todo_app/storages.dart';

class AddProjectPage extends GetView<ProjectController> {
  const AddProjectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding:
              const EdgeInsets.only(left: 30, top: 60, right: 30, bottom: 30),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Title',
                style: TextStyle(
                  fontSize: TextSize.heading1,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              TextField(
                controller: titleController,
                autofocus: true,
                style: const TextStyle(fontSize: TextSize.body2),
                cursorColor: AppColor.textSecondary,
                maxLength: 30,
                decoration: const InputDecoration(
                  hintText: 'Project01...',
                  contentPadding: EdgeInsets.all(0),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColor.textSecondary, width: 2.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColor.textSecondary, width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () async {
                      if (titleController.text.isNotEmpty) {
                        String? id =
                            await controller.addProject(titleController.text);
                        if (id != null) {
                          titleController.text = '';
                          ProjectStorage().setProjectId(id);
                          Get.offAllNamed(RouteNames.home);
                        } else {
                          Get.back();
                        }
                      }
                    },
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text('Buat Project'),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                      padding: const EdgeInsets.all(15),
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        boxShadow: [AppStyle.defaultShadow],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
