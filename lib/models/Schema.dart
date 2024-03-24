import 'package:hive/hive.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:teachy_tec/models/Class.dart';
import 'package:teachy_tec/models/Section.dart';
import 'package:teachy_tec/models/SuperSection.dart';
import 'package:teachy_tec/models/classSchema.dart';
part 'Schema.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 14)
class Schema {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  List<classSchema> classes;
  @HiveField(3)
  List<Section>? sections;
  @HiveField(4)
  List<SuperSection>? superSections;
  @HiveField(5)
  int timestamp;

  Schema({
    required this.id,
    required this.name,
    required this.classes,
    required this.sections,
    required this.superSections,
    required this.timestamp,
  });

  factory Schema.fromJson(Map<String, dynamic> srcJson) =>
      _$SchemaFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SchemaToJson(this);
}
