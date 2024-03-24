import 'package:hive/hive.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:teachy_tec/models/Sector.dart';
part 'Section.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 11)
class Section {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  num totalGrade;
  @HiveField(3)
  int? colorHex;
  @HiveField(4)
  List<Sector>? sectors;

  Section({
    required this.id,
    required this.name,
    required this.totalGrade,
    required this.colorHex,
    this.sectors,
  });

  factory Section.fromJson(Map<String, dynamic> srcJson) =>
      _$SectionFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SectionToJson(this);
}
