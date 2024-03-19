import 'package:hive/hive.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:teachy_tec/models/Class.dart';
import 'package:teachy_tec/models/Section.dart';
part 'GradesSchema.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 12)
class GradesSchema {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  List<Class> classes;
  @HiveField(3)
  List<Section>? sections;
  @HiveField(4)
  List<Section>? superSections;

  GradesSchema({
    required this.id,
    required this.name,
    required this.classes,
    required this.sections,
    required this.superSections,
  });

  factory GradesSchema.fromJson(Map<String, dynamic> srcJson) =>
      _$GradesSchemaFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GradesSchemaToJson(this);
}
