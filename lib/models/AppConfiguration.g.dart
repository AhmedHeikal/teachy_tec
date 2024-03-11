// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppConfiguration.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppConfigurationAdapter extends TypeAdapter<AppConfiguration> {
  @override
  final int typeId = 7;

  @override
  AppConfiguration read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppConfiguration(
      closeApp: fields[0] as bool,
      resetCache: fields[1] as bool,
      updateRequired: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AppConfiguration obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.closeApp)
      ..writeByte(1)
      ..write(obj.resetCache)
      ..writeByte(2)
      ..write(obj.updateRequired);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppConfigurationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfiguration _$AppConfigurationFromJson(Map<String, dynamic> json) =>
    AppConfiguration(
      closeApp: json['closeApp'] as bool,
      resetCache: json['resetCache'] as bool,
      updateRequired: json['updateRequired'] as bool,
    );

Map<String, dynamic> _$AppConfigurationToJson(AppConfiguration instance) =>
    <String, dynamic>{
      'closeApp': instance.closeApp,
      'resetCache': instance.resetCache,
      'updateRequired': instance.updateRequired,
    };
