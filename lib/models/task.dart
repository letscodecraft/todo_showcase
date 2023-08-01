import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  late String title;
  @HiveField(1)
  late String notes;

  @HiveField(2)
  late bool isCompleted;

  Task({this.title='',this.notes='',this.isCompleted = false});
}