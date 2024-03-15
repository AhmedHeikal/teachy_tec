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

  // factory AppConfiguration.fromJson(Map<String, dynamic> srcJson) =>
  //     _$AppConfigurationFromJson(srcJson);

  // Map<String, dynamic> toJson() => _$AppConfigurationToJson(this);
  factory AppConfiguration.fromJson(Map<String, dynamic> srcJson) {
    return AppConfiguration(
      closeApp: srcJson['closeApp'].toString() == 'true'.toString(),
      resetCache: srcJson['resetCache'].toString() == 'true'.toString(),
      updateRequired: srcJson['updateRequired'].toString() == 'true'.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'closeApp': closeApp.toString(),
        'resetCache': resetCache.toString(),
        'updateRequired': updateRequired.toString(),
      };
}
