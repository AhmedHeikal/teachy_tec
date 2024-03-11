// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      question: json['question'] as String,
      gradeValue: json['gradeValue'] as String,
      gradeType: $enumDecode(_$GradeTypeEnumMap, json['gradeType']),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'question': instance.question,
      'gradeValue': instance.gradeValue,
      'gradeType': _$GradeTypeEnumMap[instance.gradeType]!,
      'comment': instance.comment,
    };

const _$GradeTypeEnumMap = {
  GradeType.emoji: 0,
  GradeType.text: 2,
};
