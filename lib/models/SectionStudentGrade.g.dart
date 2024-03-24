// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SectionStudentGrade.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SectionStudentGradeAdapter extends TypeAdapter<SectionStudentGrade> {
  @override
  final int typeId = 15;

  @override
  SectionStudentGrade read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SectionStudentGrade(
      id: fields[0] as String,
      name: fields[1] as String,
      colorHex: fields[3] as int?,
      totalGrade: fields[2] as num,
      sectorsGrades: (fields[5] as List?)?.cast<SectorStudentGrade>(),
      studentId: fields[6] as String?,
      cumulativeGrade: fields[7] as String?,
    )..sectors = (fields[4] as List?)?.cast<Sector>();
  }

  @override
  void write(BinaryWriter writer, SectionStudentGrade obj) {
    writer
      ..writeByte(8)
      ..writeByte(5)
      ..write(obj.sectorsGrades)
      ..writeByte(6)
      ..write(obj.studentId)
      ..writeByte(7)
      ..write(obj.cumulativeGrade)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.totalGrade)
      ..writeByte(3)
      ..write(obj.colorHex)
      ..writeByte(4)
      ..write(obj.sectors);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SectionStudentGradeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SectionStudentGrade _$SectionStudentGradeFromJson(Map<String, dynamic> json) =>
    SectionStudentGrade(
      id: json['id'] as String,
      name: json['name'] as String,
      colorHex: json['colorHex'] as int?,
      totalGrade: json['totalGrade'] as num,
      sectorsGrades: (json['sectorsGrades'] as List<dynamic>?)
          ?.map((e) => SectorStudentGrade.fromJson(e as Map<String, dynamic>))
          .toList(),
      studentId: json['studentId'] as String?,
      cumulativeGrade: json['cumulativeGrade'] as String?,
    )..sectors = (json['sectors'] as List<dynamic>?)
        ?.map((e) => Sector.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$SectionStudentGradeToJson(
        SectionStudentGrade instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'totalGrade': instance.totalGrade,
      'colorHex': instance.colorHex,
      'sectors': instance.sectors?.map((e) => e.toJson()).toList(),
      'sectorsGrades': instance.sectorsGrades?.map((e) => e.toJson()).toList(),
      'studentId': instance.studentId,
      'cumulativeGrade': instance.cumulativeGrade,
    };
