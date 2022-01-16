import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:limasembilan_todo_app/controller/auth_controller.dart';
import 'package:limasembilan_todo_app/controller/task_detail_controller.dart';
import 'package:limasembilan_todo_app/models/sub_task_model.dart';
import 'package:limasembilan_todo_app/shared/app_theme.dart';
import 'package:limasembilan_todo_app/shared/constants.dart';

class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(TaskDetailController());
    final authC = Get.find<AuthController>();
    return Scaffold(
      body: GetBuilder<TaskDetailController>(
          builder: (TaskDetailController controller) {
        final task = controller.selectedTask.value;
        final dateNow = DateTime.now();
        final completedDate = task.completedDate;
        String formatedCompletedDate = '-';
        if (completedDate.runtimeType == int) {
          final dateObj = DateTime.fromMillisecondsSinceEpoch(completedDate!);
          formatedCompletedDate = DateFormat.yMMMMd().format(dateObj);
        }
        final parsedDueDate = DateTime.fromMillisecondsSinceEpoch(
            task.dueDate ?? dateNow.millisecondsSinceEpoch);
        final dateNow2 = DateTime(dateNow.year, dateNow.month, dateNow.day);
        final parsedDueDate2 = DateTime(
            parsedDueDate.year, parsedDueDate.month, parsedDueDate.day);

        final isToday = dateNow2 == parsedDueDate2;
        final isLate = !task.isCompleted && dateNow2.isAfter(parsedDueDate2);
        final dateColor = isToday
            ? AppColor.primaryColor
            : isLate
                ? AppColor.textDanger
                : AppColor.text;
        final formattedDueDate =
            isToday ? 'Today' : DateFormat.yMMMMd().format(parsedDueDate);

        int totalCompletedTask = task.subTask.fold(
            0, (prev, subTask) => subTask.isCompleted ? (prev + 1) : prev);
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Row(
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.chevron_left,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Task Detail',
                      style: TextStyle(
                        fontSize: TextSize.heading4,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [AppStyle.defaultShadow],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title ?? '',
                        style: TextStyle(
                          fontSize: TextSize.heading3,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        task.description ?? '',
                        style: const TextStyle(
                          fontSize: TextSize.body1,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Visibility(
                        visible: !task.isCompleted,
                        maintainSize: true,
                        maintainState: true,
                        maintainAnimation: true,
                        child: Row(
                          children: [
                            Icon(
                              Icons.date_range_outlined,
                              size: 15,
                              color: dateColor,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              formattedDueDate,
                              style: const TextStyle(fontSize: TextSize.body2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: !task.isCompleted,
                            replacement: Text.rich(
                              TextSpan(
                                style:
                                    const TextStyle(fontSize: TextSize.body3),
                                text:
                                    'Completed on\n$formatedCompletedDate\nby ',
                                children: [
                                  TextSpan(
                                    text: task.completedBy.isEmpty
                                        ? 'unknown'
                                        : task.completedBy,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                controller.onCompleteTaskButtonClick();
                              },
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                primary: AppColor.primaryColor,
                                padding: const EdgeInsets.all(5),
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                          const SizedBox(width: 10),
                          Visibility(
                            visible: task.isCompleted,
                            child: ElevatedButton(
                              onPressed: () {
                                controller.onCompleteTaskButtonClick();
                              },
                              child: const Icon(
                                Icons.undo_outlined,
                                color: AppColor.primaryColor,
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: const CircleBorder(),
                                primary: Colors.white,
                                padding: const EdgeInsets.all(5),
                              ),
                            ),
                          ),
                          Visibility(
                            visible:
                                authC.loggedUser.value.role == Role.admin ||
                                    authC.loggedUser.value.role == Role.support,
                            child: GestureDetector(
                              onTap: () {
                                controller.newDesc.text =
                                    task.description ?? '';
                                controller.newDueDate.value = task.dueDate ??
                                    DateTime.now().millisecondsSinceEpoch;
                                controller.newTitle.text = task.title ?? '';
                                // controller.onClickDeleteTask();
                                Get.defaultDialog(
                                  title: '',
                                  titlePadding: const EdgeInsets.all(0),
                                  contentPadding: const EdgeInsets.all(15),
                                  content: Obx(() {
                                    final dueDateObj =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            controller.newDueDate.value);
                                    final formattedDueDate =
                                        DateFormat.yMMMMd().format(dueDateObj);
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'name',
                                          style: TextStyle(
                                            fontSize: TextSize.body2,
                                            color: AppColor.textSecondary,
                                          ),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                            hintText: 'task name',
                                          ),
                                          controller: controller.newTitle,
                                        ),
                                        const SizedBox(height: 15),
                                        const Text(
                                          'description',
                                          style: TextStyle(
                                            fontSize: TextSize.body2,
                                            color: AppColor.textSecondary,
                                          ),
                                        ),
                                        TextField(
                                          controller: controller.newDesc,
                                          maxLines: 5,
                                          decoration: const InputDecoration(
                                            hintText: 'task description',
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        const Text(
                                          'due date',
                                          style: TextStyle(
                                            fontSize: TextSize.body2,
                                            color: AppColor.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              formattedDueDate,
                                              style: const TextStyle(
                                                fontSize: TextSize.body1,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                final date =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: dueDateObj,
                                                  firstDate:
                                                      parsedDueDate.isAfter(
                                                              DateTime.now())
                                                          ? DateTime.now()
                                                          : parsedDueDate,
                                                  lastDate: DateTime.now().add(
                                                      const Duration(
                                                          days: 365 * 2)),
                                                );
                                                if (date != null) {
                                                  controller.newDueDate.value =
                                                      date.millisecondsSinceEpoch;
                                                }
                                              },
                                              child: const Icon(
                                                Icons.calendar_today_outlined,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    );
                                  }),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        controller.updateTask();
                                      },
                                      child: const Icon(
                                        Icons.save_outlined,
                                        color: Colors.white,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        primary: AppColor.primaryColor,
                                        padding: const EdgeInsets.all(5),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        controller.onClickDeleteTask();
                                      },
                                      child: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.white,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        primary: AppColor.textDanger,
                                        padding: const EdgeInsets.all(5),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              child: const Icon(
                                Icons.edit,
                                color: AppColor.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Todos',
                      style: TextStyle(
                        fontSize: TextSize.heading4,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Row(
                      children: [
                        Text(
                          '$totalCompletedTask / ${task.subTask.length}',
                          style: const TextStyle(
                            fontSize: TextSize.body2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 15),
                        InkWell(
                          onTap: () {
                            controller.isDeleteSubTask.toggle();
                            controller.update();
                          },
                          child: Icon(
                            controller.isDeleteSubTask.value
                                ? Icons.checklist_outlined
                                : Icons.delete_sweep_outlined,
                            color: AppColor.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ...task.subTask
                    .map<Widget>(
                      (subTask) => _buildCheckRow(
                        isDeleting: controller.isDeleteSubTask.value,
                        subTask: subTask,
                        onClickDelete: () {
                          controller.deleteSubTask(subTask);
                        },
                        onChanged: (isChecked) {
                          controller.toggleCompleteSubTask(subTask);
                        },
                      ),
                    )
                    .toList(),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.defaultDialog(
                            title: 'New Todo',
                            titleStyle: const TextStyle(
                              fontSize: TextSize.heading4,
                              color: AppColor.primaryColor,
                            ),
                            content: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextField(
                                controller: controller.subTaskController,
                                autofocus: true,
                                decoration: const InputDecoration(
                                  hintText: '...',
                                ),
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  controller.onClickAddSubTask();
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  primary: AppColor.primaryColor,
                                  padding: const EdgeInsets.all(5),
                                ),
                              ),
                            ]);
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        primary: AppColor.primaryColor,
                        padding: const EdgeInsets.all(5),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCheckRow(
      {required SubTaskModel subTask,
      void Function(bool?)? onChanged,
      void Function()? onClickDelete,
      required bool isDeleting}) {
    return Container(
      constraints: const BoxConstraints(minHeight: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24,
            width: 36,
            child: (isDeleting
                ? InkWell(
                    onTap: onClickDelete,
                    child: Icon(Icons.remove_circle_outline,
                        color: AppColor.textDanger))
                : Checkbox(
                    value: subTask.isCompleted,
                    onChanged: onChanged,
                    fillColor: MaterialStateProperty.all(AppColor.primaryColor),
                  )),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: GestureDetector(
              onTap: () {
                onChanged!(!subTask.isCompleted);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subTask.title,
                    style: TextStyle(
                      fontSize: TextSize.body1,
                      decoration: subTask.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (subTask.isCompleted)
                    Text.rich(
                      TextSpan(
                        style: const TextStyle(fontSize: TextSize.body3),
                        text: 'Completed by ',
                        children: [
                          TextSpan(
                            text: subTask.completedBy,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
