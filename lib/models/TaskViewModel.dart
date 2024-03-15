// ignore_for_file: non_constant_identifier_names

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:teachy_tec/models/CustomQuestionOptionModel.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
part 'TaskViewModel.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 8)
class TaskViewModel {
  @HiveField(0)
  String task;
  @HiveField(1)
  String? downloadUrl;
  @HiveField(2)
  List<CustomQuestionOptionModel>? options;
  @HiveField(3)
  TaskType? taskType;
  @HiveField(4)
  String id;
  // used for the internal Components
  String? imagePathLocally;
  TaskViewModel({
    required this.task,
    required this.id,
    this.downloadUrl,
    this.options,
    this.taskType,
    this.imagePathLocally,
  });

  factory TaskViewModel.fromJson(Map<String, dynamic> srcJson) =>
      _$TaskViewModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TaskViewModelToJson(this);
}
