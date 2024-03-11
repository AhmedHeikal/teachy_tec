import 'package:json_annotation/json_annotation.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
part 'Teacher.g.dart';

@JsonSerializable(explicitToJson: true)
class Teacher {
  String name;
  Gender? gender;
  String email;

  Teacher({required this.name, required this.gender, required this.email});

  factory Teacher.fromJson(Map<String, dynamic> srcJson) =>
      _$TeacherFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TeacherToJson(this);
}
