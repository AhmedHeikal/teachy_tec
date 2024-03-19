import 'package:hive/hive.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:teachy_tec/models/Section.dart';
part 'SuperSection.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 13)
class SuperSection {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String? colorHex;
  @HiveField(3)
  List<Section> sections;

  SuperSection({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.sections,
  });

  factory SuperSection.fromJson(Map<String, dynamic> srcJson) =>
      _$SuperSectionFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SuperSectionToJson(this);
}
