import 'package:get_storage/get_storage.dart';

class ProjectStorage {
  final _box = GetStorage();

  GetStorage get box => _box;

  setProjectId(String id) {
    _box.write('project_id', id);
  }

  String? getProjectId() {
    return _box.read('project_id');
  }

  deleteProjectId() {
    _box.remove('project_id');
  }
}
