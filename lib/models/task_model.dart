import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  late String task;

  @HiveField(1)
  late String date;

  @HiveField(2)
  late String priority;
}