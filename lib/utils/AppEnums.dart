import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'AppEnums.g.dart';

enum SupportedLocales {
  @JsonValue(1)
  en(jsonValue: 'eng 🇺🇸'),
  @JsonValue(2)
  ar(jsonValue: '🇵🇸 عربي');

  final String jsonValue;
  const SupportedLocales({required this.jsonValue});
}

@HiveType(typeId: 4)
enum Gender {
  @HiveField(0)
  @JsonValue(0)
  male(jsonValue: 0),
  @HiveField(1)
  @JsonValue(1)
  female(jsonValue: 1);

  final int jsonValue;
  const Gender({required this.jsonValue});
}

@HiveType(typeId: 9)
enum TaskType {
  @HiveField(0)
  @JsonValue(0)
  multipleOptions(jsonValue: 0),
  @HiveField(1)
  @JsonValue(1)
  trueFalse(jsonValue: 1);

  final int jsonValue;
  const TaskType({required this.jsonValue});
}

enum GradeType {
  @JsonValue(0)
  emoji(jsonValue: 0),
  @JsonValue(2)
  text(jsonValue: 1);

  final int jsonValue;
  const GradeType({required this.jsonValue});
}

enum InputFieldTypeEnum {
  email,
  Password,
  USState,
  URL,
  Custom,
}
