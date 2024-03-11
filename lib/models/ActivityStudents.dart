import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:teachy_tec/models/Task.dart';
part 'ActivityStudents.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 6)
class ActivityStudents {
  @HiveField(0)
  String id;
  @HiveField(1)
  String classId;
  @HiveField(2)
  int timestamp;
  @HiveField(3)
  Map<String, List<Task>> studentTasks;
  @HiveField(4)
  int? lastTimeUploadedToServer;

  ActivityStudents({
    required this.id,
    required this.classId,
    required this.timestamp,
    required this.studentTasks,
    this.lastTimeUploadedToServer,
  });

  Map<String, dynamic> toJson() => _$ActivityStudentsToJson(this);
}
