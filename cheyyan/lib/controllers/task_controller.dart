import 'package:cheyyan/db/db_helper%20copy.dart';
import 'package:cheyyan/db/db_helper.dart';
import 'package:cheyyan/models/abilities.dart';
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
    incrAbilities(id);
    await DBHelper.updateTaskCompletion(id);
    getTasks();
  }

  String mapTaskTypeToAbility(String? taskType) {
    switch (taskType) {
      case 'Active':
        return 'strength';
      case 'Academic':
        return 'intelligence';
      case 'Social':
        return 'charisma';
      case 'Mindful':
        return 'constitution';
      default:
        return ''; // Return an empty string for invalid task types
    }
  }

  void incrAbilities(int id) async {
    String? taskType = await DBHelper.getTaskType(id);

    String ability = mapTaskTypeToAbility(taskType);

    // Increment the corresponding ability using DBHelper2
    if (ability.isNotEmpty) {
      await DBHelper2.incrementAbilities(ability);
    } else {
      print('Invalid task type or ability mapping.');
    }
  }
}
