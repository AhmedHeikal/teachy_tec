// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classSchema.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class classSchemaAdapter extends TypeAdapter<classSchema> {
  @override
  final int typeId = 18;

  @override
  classSchema read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return classSchema(
      id: fields[0] as String?,
      name: fields[1] as String,
      department: fields[2] as String?,
      grade_level: fields[3] as String?,
      isActive: fields[4] as bool,
      schemaId: fields[5] as String,
      lastEditTimestamp: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, classSchema obj) {
    writer
      ..writeByte(7)
      ..writeByte(4)
      ..write(obj.isActive)
      ..writeByte(5)
      ..write(obj.schemaId)
      ..writeByte(6)
      ..write(obj.lastEditTimestamp)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.department)
      ..writeByte(3)
      ..write(obj.grade_level);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is classSchemaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

classSchema _$classSchemaFromJson(Map<String, dynamic> json) => classSchema(
      id: json['id'] as String?,
      name: json['name'] as String,
      department: json['department'] as String?,
      grade_level: json['grade_level'] as String?,
      isActive: json['isActive'] as bool,
      schemaId: json['schemaId'] as String,
      lastEditTimestamp: json['lastEditTimestamp'] as int,
    );

Map<String, dynamic> _$classSchemaToJson(classSchema instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'department': instance.department,
      'grade_level': instance.grade_level,
      'isActive': instance.isActive,
      'schemaId': instance.schemaId,
      'lastEditTimestamp': instance.lastEditTimestamp,
    };
