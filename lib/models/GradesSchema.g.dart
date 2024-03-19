// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GradesSchema.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GradesSchemaAdapter extends TypeAdapter<GradesSchema> {
  @override
  final int typeId = 12;

  @override
  GradesSchema read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GradesSchema(
      id: fields[0] as String,
      name: fields[1] as String,
      classes: (fields[2] as List).cast<Class>(),
      sections: (fields[3] as List?)?.cast<Section>(),
      superSections: (fields[4] as List?)?.cast<Section>(),
    );
  }

  @override
  void write(BinaryWriter writer, GradesSchema obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.classes)
      ..writeByte(3)
      ..write(obj.sections)
      ..writeByte(4)
      ..write(obj.superSections);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GradesSchemaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GradesSchema _$GradesSchemaFromJson(Map<String, dynamic> json) => GradesSchema(
      id: json['id'] as String,
      name: json['name'] as String,
      classes: (json['classes'] as List<dynamic>)
          .map((e) => Class.fromJson(e as Map<String, dynamic>))
          .toList(),
      sections: (json['sections'] as List<dynamic>?)
          ?.map((e) => Section.fromJson(e as Map<String, dynamic>))
          .toList(),
      superSections: (json['superSections'] as List<dynamic>?)
          ?.map((e) => Section.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GradesSchemaToJson(GradesSchema instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'classes': instance.classes.map((e) => e.toJson()).toList(),
      'sections': instance.sections?.map((e) => e.toJson()).toList(),
      'superSections': instance.superSections?.map((e) => e.toJson()).toList(),
    };
