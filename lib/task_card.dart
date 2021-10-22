import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:limasembilan_todo_app/controller/task_controller.dart';
import 'package:limasembilan_todo_app/dialog_confirm.dart';
import 'package:limasembilan_todo_app/helpers.dart';
import 'package:limasembilan_todo_app/models/task_model.dart';
import 'package:limasembilan_todo_app/routes/app_route.dart';

import 'app_theme.dart';

class TaskCard extends StatelessWidget {
  TaskCard(
      {Key? key, required this.context, required this.task, required this.tag})
      : super(key: key);
  final DateTime _dateNow = DateTime.now();
  final BuildContext context;
  final TaskModel task;
  final String tag;

  @override
  Widget build(BuildContext context) {
    var taskC = Get.find<TaskController>();
    DateTime dueDate = DateTime.fromMillisecondsSinceEpoch(task.dueDate);
    StatusDate status = StatusDate.unknown;

    if (task.isCompleted) {
      status = StatusDate.completed;
    } else if (dateTimeToyyyyMMdd(dueDate) == dateTimeToyyyyMMdd(_dateNow)) {
      status = StatusDate.today;
    } else if (dateTimeToyyyyMMdd(dueDate)
            .compareTo(dateTimeToyyyyMMdd(_dateNow)) ==
        -1) {
      status = StatusDate.late;
    } else {
      status = StatusDate.unknown;
    }

    return InkWell(
      highlightColor: Colors.white.withOpacity(0.8),
      onTap: () {
        Get.toNamed(RouteNames.taskDetail, arguments: task);
      },
      onLongPress: () {
        DialogConfirm.show(
          'Hapus ${task.title} ?',
          context: context,
          onConfirm: () {
            taskC.deleteTask(task.taskId);
            Get.back();
          },
        );
      },
      child: Ink(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          boxShadow: [AppStyle.defaultShadow],
          borderRadius: BorderRadius.circular(15),
          color: task.isCompleted
              ? Theme.of(context).scaffoldBackgroundColor
              : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: TextSize.body1,
                fontWeight: FontWeight.bold,
                color: status == StatusDate.completed
                    ? AppColor.textSecondary
                    : Colors.black,
                decoration: status == StatusDate.completed
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Text(
                task.description,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                style: const TextStyle(
                  fontSize: TextSize.body2,
                  color: AppColor.textSecondary,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today_outlined,
                    color: status == StatusDate.late
                        ? AppColor.textDanger
                        : status == StatusDate.today
                            ? Theme.of(context).primaryColor
                            : status == StatusDate.completed
                                ? AppColor.textSecondary
                                : Colors.black),
                const SizedBox(width: 10),
                Text(
                  DateFormat.yMMMMd('id_ID').format(dueDate),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                  style: TextStyle(
                    color: status == StatusDate.completed
                        ? AppColor.textSecondary
                        : Colors.black,
                    fontSize: TextSize.body3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
