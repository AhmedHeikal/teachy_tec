// ignore_for_file: non_constant_identifier_names

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:teachy_tec/models/CustomQuestionOptionModel.dart';
import 'package:teachy_tec/models/Sector.dart';
import 'package:teachy_tec/models/TaskViewModel.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
part 'SectorStudentGrade.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 16)
class SectorStudentGrade extends Sector {
  @HiveField(4)
  String? studentId;
  @HiveField(5)
  num? gradeScored;

  SectorStudentGrade({
    required this.studentId,
    required this.gradeScored,
    required super.id,
    required super.name,
    required super.realWeight,
    required super.percentageWeight,
  });

  factory SectorStudentGrade.fromJson(Map<String, dynamic> srcJson) =>
      _$SectorStudentGradeFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SectorStudentGradeToJson(this);
}
