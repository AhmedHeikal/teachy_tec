import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:teachy_tec/models/SectionStudentGrade.dart';
import 'package:teachy_tec/models/SuperSection.dart';
import 'package:teachy_tec/models/Section.dart';
part 'SuperSectionStudentGrade.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 17)
class SuperSectionStudentGrade extends SuperSection {
  @HiveField(4)
  String? studentId;
  @HiveField(5)
  String? cumulativeGrade;
  @HiveField(6)
  List<SectionStudentGrade> sectionsGrades;

  SuperSectionStudentGrade({
    required super.id,
    required super.name,
    super.colorHex,
    this.studentId,
    this.cumulativeGrade,
    required this.sectionsGrades,
  }) : super(
          sections: sectionsGrades,
        );

  factory SuperSectionStudentGrade.fromJson(Map<String, dynamic> srcJson) =>
      _$SuperSectionStudentGradeFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SuperSectionStudentGradeToJson(this);
}
