// ignore_for_file: non_constant_identifier_names

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:teachy_tec/models/CustomQuestionOptionModel.dart';
part 'Task.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 5)
class Task {
  @HiveField(0)
  String task;
  @HiveField(1)
  double? grade_value;
  @HiveField(2)
  String? emoji_id;
  @HiveField(3)
  CustomQuestionOptionModel? selectedOption;
  @HiveField(4)
  String? comment;
  @HiveField(5)
  String? imagePathInFireStore;
  @HiveField(6)
  List<CustomQuestionOptionModel>? options;
  @HiveField(7)
  String id;

  Task({
    required this.task,
    required this.id,
    this.grade_value,
    this.emoji_id,
    this.selectedOption,
    this.comment,
    this.imagePathInFireStore,
    this.options,
  });

  factory Task.fromJson(Map<String, dynamic> srcJson) =>
      _$TaskFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
