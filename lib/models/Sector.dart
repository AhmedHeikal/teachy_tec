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
  num realWeight;
  @HiveField(3)
  num percentageWeight;

  Sector({
    required this.id,
    required this.name,
    required this.realWeight,
    required this.percentageWeight,
  });

  factory Sector.fromJson(Map<String, dynamic> srcJson) =>
      _$SectorFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SectorToJson(this);
}
