import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:teachy_tec/models/Class.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
part 'Student.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 1)
class Student {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String name;
  @HiveField(2)
  Gender? gender;
  @HiveField(3)
  @JsonKey(name: 'class')
  Class? studentClass;

  Student({
    required this.id,
    required this.name,
    this.gender,
    this.studentClass,
  });

  factory Student.fromJson(Map<String, dynamic> srcJson) =>
      _$StudentFromJson(srcJson);

  Map<String, dynamic> toJson() => _$StudentToJson(this);
}
