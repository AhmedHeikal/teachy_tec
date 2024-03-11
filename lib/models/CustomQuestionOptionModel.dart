import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'CustomQuestionOptionModel.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 3)
class CustomQuestionOptionModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String? questionId;
  @HiveField(3)
  bool isCorrect;
  @HiveField(4)
  String? downloadUrl;
  @HiveField(5)
  String? filePathLocally;

  CustomQuestionOptionModel(
    this.id,
    this.name,
    this.questionId,
    this.isCorrect,
    this.downloadUrl,
    this.filePathLocally,
  );

  CustomQuestionOptionModel copyWith() => CustomQuestionOptionModel(
        id,
        name,
        questionId,
        isCorrect,
        downloadUrl,
        filePathLocally,
      );

  factory CustomQuestionOptionModel.fromJson(Map<String, dynamic> srcJson) =>
      _$CustomQuestionOptionModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CustomQuestionOptionModelToJson(this);
}
