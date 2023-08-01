import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/task.dart';

class TaskController extends ChangeNotifier {
  final Box<Task> _taskBox;

  TaskController(this._taskBox);

  List<Task> get tasks => _taskBox.values.toList();

  Future<void> addTask(Task task) async {
    final value = await _taskBox.add(task);
    notifyListeners();
  }

  deleteAll() async {
    await _taskBox.clear();

    notifyListeners();
  }

  delete(int id) async {
    await _taskBox.deleteAt(id);
    notifyListeners();
  }

  toggleComplete(int id, Task task) async {
    task.isCompleted = !task.isCompleted;
    await _taskBox.putAt(id, task);
    notifyListeners();
  }
}
