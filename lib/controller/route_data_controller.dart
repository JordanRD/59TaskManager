import 'package:get/get.dart';
import 'package:limasembilan_todo_app/helpers.dart';

class RouteDataController extends GetxController {
  Rx<Detail> currentAllTaskParam = Detail.done.obs;
  updateParam(Detail param) {
    currentAllTaskParam.value = param;
    update();
  }
}
