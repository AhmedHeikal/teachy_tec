import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:teachy_tec/models/Section.dart';
import 'package:teachy_tec/models/Sector.dart';
import 'package:teachy_tec/models/SectorStudentGrade.dart';
part 'SectionStudentGrade.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 15)
class SectionStudentGrade extends Section {
  @HiveField(5)
  List<SectorStudentGrade>? sectorsGrades;
  @HiveField(6)
  String? studentId;
  @HiveField(7)
  String? cumulativeGrade;

  SectionStudentGrade({
    required super.id,
    required super.name,
    super.colorHex,
    required super.totalGrade,
    this.sectorsGrades,
    this.studentId,
    this.cumulativeGrade,
  }) : super(
          sectors: sectorsGrades,
        );

  factory SectionStudentGrade.fromJson(Map<String, dynamic> srcJson) =>
      _$SectionStudentGradeFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SectionStudentGradeToJson(this);
}
