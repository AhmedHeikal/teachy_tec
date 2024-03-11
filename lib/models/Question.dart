import 'package:json_annotation/json_annotation.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
part 'Question.g.dart';

@JsonSerializable(explicitToJson: true)
class Question {
  String question;
  String gradeValue;
  GradeType gradeType;
  String? comment;

  Question(
      {required this.question,
      required this.gradeValue,
      required this.gradeType,
      this.comment});

  factory Question.fromJson(Map<String, dynamic> srcJson) =>
      _$QuestionFromJson(srcJson);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}
