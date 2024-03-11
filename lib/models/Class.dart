import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Class.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 2)
class Class {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String? department;
  @HiveField(3)
  String? grade_level;

  Class(
      {required this.id,
      required this.name,
      this.grade_level,
      required this.department});

  factory Class.fromJson(Map<String, dynamic> srcJson) =>
      _$ClassFromJson(srcJson);

  factory Class.fromMap(String id, Map<String, dynamic> map) {
    return Class(
      id: id,
      name: map['name'] as String,
      grade_level: map['grade_level'] as String?,
      department: map['department'] as String?,
    );
  }
  Map<String, dynamic> toJson() => _$ClassToJson(this);
}
