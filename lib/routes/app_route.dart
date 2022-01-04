import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/screens/add_project_page.dart';
import 'package:limasembilan_todo_app/screens/add_user_page.dart';
import 'package:limasembilan_todo_app/screens/home_page/home_page.dart';
import 'package:limasembilan_todo_app/screens/login_page.dart';
import 'package:limasembilan_todo_app/screens/project_detail_page/add_task_page.dart';
import 'package:limasembilan_todo_app/screens/project_detail_page/project_detail_page.dart';
import 'package:limasembilan_todo_app/screens/project_detail_page/task_detail_page.dart';

class RouteNames {
  static const String home = '/home';
  static const String login = '/login';
  static const String addProject = '/add_project';
  static const String projectDetail = '/project_detail';
  static const String notFound = '/not_found';
  static const String addTask = '/add_task';
  static const String taskDetail = '/task_detail';
  static const String addUser = '/add_user';
}

List<GetPage> appRoutes = [
  GetPage(
    name: RouteNames.notFound,
    page: () => Container(),
    transition: Transition.noTransition,
  ),
  GetPage(
    name: RouteNames.login,
    page: () => const LoginPage(),
    transition: Transition.noTransition,
  ),
  GetPage(
    name: RouteNames.home,
    page: () => const HomePage(),
    transition: Transition.noTransition,
  ),
  GetPage(
    name: RouteNames.addProject,
    page: () => const AddProjectPage(),
    transition: Transition.noTransition,
  ),
  GetPage(
    name: RouteNames.addUser,
    page: () => const AddUserPage(),
    transition: Transition.noTransition,
  ),
  GetPage(
    name: RouteNames.projectDetail + '/:projectId',
    page: () => const ProjectDetailPage(),
    transition: Transition.noTransition,
  ),
  GetPage(
    name: RouteNames.addTask,
    page: () => const AddTaskPage(),
    transition: Transition.noTransition,
  ),
  GetPage(
    name: RouteNames.taskDetail + '/:taskId',
    page: () => const TaskDetailPage(),
    transition: Transition.noTransition,
  ),
];
