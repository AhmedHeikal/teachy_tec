import 'package:hive/hive.dart';

import 'package:json_annotation/json_annotation.dart';
part 'Sector.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 10)
class Sector {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  double totalGrade;
  @HiveField(3)
  double? realWeight;

  Sector(
      {required this.id,
      required this.name,
      required this.totalGrade,
      required this.realWeight});

  factory Sector.fromJson(Map<String, dynamic> srcJson) =>
      _$SectorFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SectorToJson(this);
}
