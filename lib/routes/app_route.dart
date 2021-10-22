import 'package:get/get.dart';
import 'package:limasembilan_todo_app/add_project_page.dart';
import 'package:limasembilan_todo_app/add_task_page.dart';
import 'package:limasembilan_todo_app/all_task_page.dart';
import 'package:limasembilan_todo_app/home_page.dart';
import 'package:limasembilan_todo_app/select_project_page.dart';
import 'package:limasembilan_todo_app/task_detail_page.dart';

class RouteNames {
  static const String home = '/home';
  static const String project = '/project';
  static const String addProject = '/add_project';
  static const String addTask = '/add_task';
  static const String taskDetail = '/task_detail';
  static const String allTaskPage = '/all_task';
}

List<GetPage> appRoutes = [
  GetPage(name: RouteNames.home, page: () => HomePage()),
  GetPage(
    name: RouteNames.project,
    page: () => const SelectProjectPage(),
    transition: Transition.noTransition,
  ),
  GetPage(
    name: RouteNames.addProject,
    page: () => const AddProjectPage(),
    transition: Transition.noTransition,
  ),
  GetPage(
    name: RouteNames.addTask,
    page: () => const AddTaskPage(),
    transition: Transition.noTransition,
  ),
  GetPage(
    name: RouteNames.taskDetail,
    page: () => const TaskDetailPage(),
    transition: Transition.noTransition,
  ),
  GetPage(
    name: RouteNames.allTaskPage,
    page: () => const AllTaskPage(),
    transition: Transition.noTransition,
  ),
];
