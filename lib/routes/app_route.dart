import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/screens/add_project_page.dart';
import 'package:limasembilan_todo_app/screens/home_page/home_page.dart';
import 'package:limasembilan_todo_app/screens/login_page.dart';

class RouteNames {
  static const String home = '/home';
  static const String login = '/login';
  static const String addProject = '/add_project';
  static const String notFound = '/not_found';
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
];
