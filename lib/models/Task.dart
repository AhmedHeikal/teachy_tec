// ignore_for_file: non_constant_identifier_names

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:teachy_tec/models/CustomQuestionOptionModel.dart';
import 'package:teachy_tec/models/TaskViewModel.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
part 'Task.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 5)
class Task extends TaskViewModel {
  @HiveField(5)
  double? grade_value;
  @HiveField(6)
  String? emoji_id;
  @HiveField(7)
  CustomQuestionOptionModel? selectedOption;
  @HiveField(8)
  String? comment;
  @HiveField(9)
  bool? isCorrectAnswerChosen;
  @HiveField(10)
  String? enteredTextForCurrentTask;

  Task({
    required String task,
    required String id,
    String? downloadUrl,
    List<CustomQuestionOptionModel>? options,
    TaskType? taskType,
    String? imagePathLocally,
    this.grade_value,
    this.emoji_id,
    this.selectedOption,
    this.comment,
    this.isCorrectAnswerChosen,
    this.enteredTextForCurrentTask,
  }) : super(
          task: task,
          id: id,
          downloadUrl: downloadUrl,
          options: options,
          taskType: taskType,
          imagePathLocally: imagePathLocally,
        );

  factory Task.fromJson(Map<String, dynamic> srcJson) =>
      _$TaskFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
