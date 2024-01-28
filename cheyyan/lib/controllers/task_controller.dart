import 'package:cheyyan/db/db_helper.dart';
import 'package:cheyyan/models/task.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insertTask(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.queryTasks();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void delete(Task task) {
    DBHelper.deleteTask(task);
    getTasks();
  }

  void markTaskCompleted(int id) async {
    await DBHelper.updateTaskCompletion(id);
    getTasks();
  }
}
