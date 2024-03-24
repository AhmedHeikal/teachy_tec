import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:teachy_tec/models/Class.dart';
import 'package:teachy_tec/models/Section.dart';
import 'package:teachy_tec/models/Sector.dart';
import 'package:teachy_tec/models/SectorStudentGrade.dart';
part 'classSchema.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 18)
class classSchema extends Class {
  @HiveField(4)
  bool isActive;
  @HiveField(5)
  String schemaId;
  @HiveField(6)
  int lastEditTimestamp;

  classSchema({
    required super.id,
    required super.name,
    super.department,
    super.grade_level,
    required this.isActive,
    required this.schemaId,
    required this.lastEditTimestamp,
  });

  factory classSchema.fromJson(Map<String, dynamic> srcJson) =>
      _$classSchemaFromJson(srcJson);

  Map<String, dynamic> toJson() => _$classSchemaToJson(this);
}
