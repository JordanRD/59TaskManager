import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:limasembilan_todo_app/controller/add_project_page_controller.dart';
import 'package:limasembilan_todo_app/controller/add_task_page_controller.dart';
import 'package:limasembilan_todo_app/shared/app_theme.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AddTaskController());
    return Scaffold(body: SingleChildScrollView(
      child: GetBuilder<AddTaskController>(
        builder: (AddTaskController controller) {
          return Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Row(
                  children: const [
                    Text(
                      'New Task',
                      style: TextStyle(
                        color: AppColor.primaryColor,
                        fontSize: TextSize.heading2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text('Name'),
                TextField(
                  controller: controller.titleController,
                  decoration: const InputDecoration(
                    hintText: 'task name',
                  ),
                ),
                const SizedBox(height: 30),
                const Text('Description'),
                TextField(
                  controller: controller.descriptionController,
                  minLines: 5,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'task description',
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Due Date'),
                    Text(DateFormat.yMMMMd().format(controller.dueDate.value)),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 50,
                  child: ToggleButtons(
                    // constraints:
                    //     const BoxConstraints(maxHeight: 50, minHeight: 50),
                    isSelected: controller.selectedDate,
                    onPressed: (int idx) async {
                      DateTime now = DateTime.now();
                      if (idx == 0) {
                        controller.dueDate.value = now;
                        controller.selectedDate.value = [true, false, false];
                      }
                      if (idx == 1) {
                        controller.dueDate.value =
                            now.add(const Duration(days: 1));
                        controller.selectedDate.value = [false, true, false];
                      }
                      if (idx == 2) {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: controller.dueDate.value,
                          firstDate: now,
                          lastDate: now.add(const Duration(days: 365 * 2)),
                        );

                        if (selectedDate != null) {
                          controller.dueDate.value = selectedDate;
                          controller.selectedDate.value = [false, false, true];
                        }
                      }
                      controller.update();
                    },
                    borderRadius: BorderRadius.circular(15),
                    borderColor: AppColor.textSecondary,
                    selectedColor: Theme.of(context).primaryColor,
                    selectedBorderColor: Theme.of(context).primaryColor,
                    fillColor: Colors.white,
                    color: AppColor.textSecondary,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text('Today'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text('Tomorrow'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text('Custom'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Sub Task',
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontSize: TextSize.heading3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
                ...controller.subTasks.map<Widget>((elm) => Container(
                      key: Key(elm.subTaskId),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        boxShadow: [AppStyle.defaultShadow],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              elm.title,
                              softWrap: true,
                            ),
                          ),
                          const SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              controller.removeSubTask(elm.subTaskId);
                            },
                            child: Icon(
                              Icons.remove_circle_outline,
                              color: AppColor.textDanger,
                            ),
                          ),
                        ],
                      ),
                    )),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: TextField(
                        onEditingComplete: () => controller.onClickAddSubTask(),
                        controller: controller.subTaskController,
                        decoration: const InputDecoration(
                          hintText: 'add sub task',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: controller.onClickAddSubTask,
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        primary: AppColor.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: controller.createTask,
                  child: const Text(
                    'Create Task',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    primary: AppColor.primaryColor,
                    padding: const EdgeInsets.all(15),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ));
  }
}
