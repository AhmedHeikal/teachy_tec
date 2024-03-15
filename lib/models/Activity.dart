import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:teachy_tec/models/Class.dart';
import 'package:teachy_tec/models/Student.dart';
import 'package:teachy_tec/models/TaskViewModel.dart';
part 'Activity.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 0)
class Activity {
  @HiveField(0)
  String id;
  @HiveField(1)
  List<Student>? students;
  @HiveField(2)
  List<TaskViewModel>? tasks;
  @HiveField(3)
  Class? currentClass;
  @HiveField(4)
  int timestamp;
  @HiveField(5)
  int time;

  Activity({
    required this.id,
    required this.tasks,
    required this.timestamp,
    this.students,
    this.currentClass,
    required this.time,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        tasks: (json['tasks'] as List<dynamic>)
            .map((e) => TaskViewModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        timestamp: DateTime.parse(json['timestamp']).millisecondsSinceEpoch,
        time: json['time'] as int,
        students: (json['students'] as List<dynamic>?)
            ?.map((e) => Student.fromJson(e as Map<String, dynamic>))
            .toList(),
        currentClass: json['class'] == null
            ? null
            : Class.fromJson(json['class'] as Map<String, dynamic>),
        // department: json['department'] as String?,
        // gradeLevel: json['gradeLevel'] as String?,
        id: json['id'] as String,
      );

  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}
