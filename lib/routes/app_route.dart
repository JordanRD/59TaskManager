import 'package:get/get.dart';
import 'package:limasembilan_todo_app/screens/home_page.dart';
import 'package:limasembilan_todo_app/screens/login_page.dart';

class RouteNames {
  static const String home = '/home';
  static const String login = '/login';
}

List<GetPage> appRoutes = [
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
];
