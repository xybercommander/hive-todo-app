import 'package:hive/hive.dart';
import 'package:hive_todo_app/models/task_model.dart';

class Boxes {
  static Box<Task> getTasks() => Hive.box('tasks-box');
}