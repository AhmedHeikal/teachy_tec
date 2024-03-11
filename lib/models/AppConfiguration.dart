import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'AppConfiguration.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 7)
class AppConfiguration {
  @HiveField(0)
  bool closeApp;
  @HiveField(1)
  bool resetCache;
  @HiveField(2)
  bool updateRequired;

  AppConfiguration({
    required this.closeApp,
    required this.resetCache,
    required this.updateRequired,
  });
  factory AppConfiguration.fromJson(Map<String, dynamic> srcJson) =>
      _$AppConfigurationFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AppConfigurationToJson(this);
}
