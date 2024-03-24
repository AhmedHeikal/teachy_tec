// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Schema.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SchemaAdapter extends TypeAdapter<Schema> {
  @override
  final int typeId = 14;

  @override
  Schema read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Schema(
      id: fields[0] as String,
      name: fields[1] as String,
      classes: (fields[2] as List).cast<classSchema>(),
      sections: (fields[3] as List?)?.cast<Section>(),
      superSections: (fields[4] as List?)?.cast<SuperSection>(),
      timestamp: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Schema obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.classes)
      ..writeByte(3)
      ..write(obj.sections)
      ..writeByte(4)
      ..write(obj.superSections)
      ..writeByte(5)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchemaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schema _$SchemaFromJson(Map<String, dynamic> json) => Schema(
      id: json['id'] as String,
      name: json['name'] as String,
      classes: (json['classes'] as List<dynamic>)
          .map((e) => classSchema.fromJson(e as Map<String, dynamic>))
          .toList(),
      sections: (json['sections'] as List<dynamic>?)
          ?.map((e) => Section.fromJson(e as Map<String, dynamic>))
          .toList(),
      superSections: (json['superSections'] as List<dynamic>?)
          ?.map((e) => SuperSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      timestamp: json['timestamp'] as int,
    );

Map<String, dynamic> _$SchemaToJson(Schema instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'classes': instance.classes.map((e) => e.toJson()).toList(),
      'sections': instance.sections?.map((e) => e.toJson()).toList(),
      'superSections': instance.superSections?.map((e) => e.toJson()).toList(),
      'timestamp': instance.timestamp,
    };
