// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SuperSection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SuperSectionAdapter extends TypeAdapter<SuperSection> {
  @override
  final int typeId = 13;

  @override
  SuperSection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SuperSection(
      id: fields[0] as String,
      name: fields[1] as String,
      colorHex: fields[2] as String?,
      sections: (fields[3] as List).cast<Section>(),
    );
  }

  @override
  void write(BinaryWriter writer, SuperSection obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.colorHex)
      ..writeByte(3)
      ..write(obj.sections);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuperSectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuperSection _$SuperSectionFromJson(Map<String, dynamic> json) => SuperSection(
      id: json['id'] as String,
      name: json['name'] as String,
      colorHex: json['colorHex'] as String?,
      sections: (json['sections'] as List<dynamic>)
          .map((e) => Section.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SuperSectionToJson(SuperSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'colorHex': instance.colorHex,
      'sections': instance.sections.map((e) => e.toJson()).toList(),
    };
