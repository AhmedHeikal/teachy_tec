// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SectorStudentGrade.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SectorStudentGradeAdapter extends TypeAdapter<SectorStudentGrade> {
  @override
  final int typeId = 16;

  @override
  SectorStudentGrade read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SectorStudentGrade(
      studentId: fields[4] as String?,
      gradeScored: fields[5] as num?,
      id: fields[0] as String,
      name: fields[1] as String,
      realWeight: fields[2] as num,
      percentageWeight: fields[3] as num,
    );
  }

  @override
  void write(BinaryWriter writer, SectorStudentGrade obj) {
    writer
      ..writeByte(6)
      ..writeByte(4)
      ..write(obj.studentId)
      ..writeByte(5)
      ..write(obj.gradeScored)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.realWeight)
      ..writeByte(3)
      ..write(obj.percentageWeight);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SectorStudentGradeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SectorStudentGrade _$SectorStudentGradeFromJson(Map<String, dynamic> json) =>
    SectorStudentGrade(
      studentId: json['studentId'] as String?,
      gradeScored: json['gradeScored'] as num?,
      id: json['id'] as String,
      name: json['name'] as String,
      realWeight: json['realWeight'] as num,
      percentageWeight: json['percentageWeight'] as num,
    );

Map<String, dynamic> _$SectorStudentGradeToJson(SectorStudentGrade instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'realWeight': instance.realWeight,
      'percentageWeight': instance.percentageWeight,
      'studentId': instance.studentId,
      'gradeScored': instance.gradeScored,
    };
