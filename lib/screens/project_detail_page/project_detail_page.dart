import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:limasembilan_todo_app/controller/project_detail_page_controller.dart';
import 'package:limasembilan_todo_app/controller/user_controller.dart';
import 'package:limasembilan_todo_app/models/user_model.dart';
import 'package:limasembilan_todo_app/routes/app_route.dart';
import 'package:limasembilan_todo_app/shared/app_theme.dart';

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(ProjectDetailController());
    final userC = Get.find<UserController>();
    return GetBuilder<ProjectDetailController>(builder: (controller) {
      controller.filteredTask
          .sort((a, b) => (a.dueDate ?? 0) - (b.dueDate ?? 0));

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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () => Get.back(),
                              child: const Icon(
                                Icons.chevron_left,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width - 150,
                              ),
                              child: Text(
                                controller.currentProject.value.name ?? '',
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: const TextStyle(
                                  fontSize: TextSize.heading2,
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Get.defaultDialog(
                                title: 'Contributors',
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                                content: Obx(() {
                                  final userIds = controller
                                          .currentProject.value.contributors ??
                                      [];
                                  final userInCurrentProject = <UserModel>[];
                                  final userNotInCurrentProject = <UserModel>[];
                                  for (var user in userC.users) {
                                    if (userIds.contains(user.userId)) {
                                      userInCurrentProject.add(user);
                                    } else {
                                      userNotInCurrentProject.add(user);
                                    }
                                  }
                                  return Container(
                                    constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.75),
                                    child: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      child: Column(
                                        children: [
                                          ...userInCurrentProject
                                              .map((e) => Container(
                                                    key: Key(e.userId ?? ''),
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            e.username!,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            controller
                                                                .removeContributor(
                                                                    e.userId!);
                                                          },
                                                          child: const Icon(
                                                            Icons
                                                                .remove_circle_outline,
                                                            color: Colors.red,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ))
                                              .toList(),
                                          const SizedBox(height: 15),
                                          const Text(
                                            'Assign User',
                                            style: TextStyle(
                                              fontSize: TextSize.body1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          ...userNotInCurrentProject
                                              .map((e) => Container(
                                                    key: Key(e.userId ?? ''),
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            e.username!,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            if (e.userId !=
                                                                null) {
                                                              controller
                                                                  .addContributor(
                                                                      e.userId!);
                                                            }
                                                          },
                                                          child: const Icon(
                                                            Icons
                                                                .add_circle_outline,
                                                            color: AppColor
                                                                .primaryColor,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ))
                                              .toList(),
                                        ],
                                      ),
                                    ),
                                  );
                                }));
                          },
                          child: Row(
                            children: [
                              Text(
                                '${controller.currentProject.value.contributors?.length ?? 0}',
                                style: const TextStyle(
                                    color: AppColor.textSecondary,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.people_alt_outlined,
                                color: AppColor.textSecondary,
                              ),
                            ],
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
                        task.isCompleted,
                        onTap: () {
                          Get.toNamed(
                              RouteNames.taskDetail + '/${task.taskId}');
                        },
                        doneCount: task.subTask.fold(0,
                            (prev, task) => prev + (task.isCompleted ? 1 : 0)),
                        totalSubTask: task.subTask.length,
                      );
                    }),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCard(
      String title, String description, int dueDate, bool isCompleted,
      {int doneCount = 0,
      void Function()? onTap,
      int totalSubTask = 0,
      String heroTag = ''}) {
    final dateNow = DateTime.now();
    final parsedDueDate = DateTime.fromMillisecondsSinceEpoch(dueDate);
    final dateNow2 = DateTime(dateNow.year, dateNow.month, dateNow.day);
    final parsedDueDate2 =
        DateTime(parsedDueDate.year, parsedDueDate.month, parsedDueDate.day);

    final isToday = dateNow2 == parsedDueDate2;
    final isLate = !isCompleted && dateNow2.isAfter(parsedDueDate2);
    final dateColor = isToday
        ? AppColor.primaryColor
        : isLate
            ? AppColor.textDanger
            : AppColor.text;
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
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
                Icon(
                  Icons.date_range_outlined,
                  color: dateColor,
                ),
                const SizedBox(width: 5),
                Text(
                  isToday ? 'Today' : DateFormat.yMMMMd().format(parsedDueDate),
                  // style: TextStyle(color: dateColor),
                ),
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
