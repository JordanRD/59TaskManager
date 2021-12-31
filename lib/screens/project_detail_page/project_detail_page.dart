import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:limasembilan_todo_app/controller/project_detail_page_controller.dart';
import 'package:limasembilan_todo_app/routes/app_route.dart';
import 'package:limasembilan_todo_app/shared/app_theme.dart';

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ProjectDetailController());
    return GetBuilder<ProjectDetailController>(builder: (controller) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(RouteNames.addTask);
          },
          backgroundColor: AppColor.primaryColor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Get.back(),
                          child: const Icon(Icons.arrow_back),
                        ),
                        const SizedBox(width: 15),
                        Flexible(
                          flex: 1,
                          child: Text(
                            controller.currentProject.value.name ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: TextSize.heading2,
                              color: AppColor.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        _buildStatusButton(
                          'On Progress',
                          onPressed: () {
                            controller.filterBy.value =
                                ProjectDetailFilter.onProgress;
                            controller.update();
                          },
                          selected: controller.filterBy.value ==
                              ProjectDetailFilter.onProgress,
                        ),
                        const SizedBox(width: 10),
                        _buildStatusButton(
                          'Done',
                          onPressed: () {
                            controller.filterBy.value =
                                ProjectDetailFilter.done;
                            controller.update();
                          },
                          selected: controller.filterBy.value ==
                              ProjectDetailFilter.done,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: ListView.builder(
                    itemCount: controller.filteredTask.length,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 30,
                    ),
                    itemBuilder: (context, idx) {
                      final task = controller.filteredTask[idx];
                      return _buildCard(
                        task.title ?? '-',
                        task.description ?? '-',
                        task.dueDate ?? 0,
                        doneCount: task.subTask.fold(0,
                            (prev, task) => prev + (task.isCompleted ? 1 : 0)),
                        totalSubTask: 7,
                      );
                    }),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCard(String title, String description, int dueDate,
      {int doneCount = 0, int totalSubTask = 0}) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          boxShadow: [AppStyle.defaultShadow],
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: TextSize.heading4,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColor.textSecondary,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.date_range_outlined),
                const SizedBox(width: 5),
                Text(DateFormat.yMMMMd()
                    .format(DateTime.fromMillisecondsSinceEpoch(dueDate))),
                Expanded(child: Container()),
                Text('$doneCount / $totalSubTask'),
                const SizedBox(width: 5),
                const Icon(
                  Icons.done,
                  size: TextSize.body1,
                  color: AppColor.primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton _buildStatusButton(String title,
      {required void Function() onPressed, bool selected = false}) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : AppColor.primaryColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          primary: selected ? AppColor.primaryColor : Colors.white,
        ));
  }
}
