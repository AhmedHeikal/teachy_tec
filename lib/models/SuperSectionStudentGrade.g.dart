// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SuperSectionStudentGrade.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SuperSectionStudentGradeAdapter
    extends TypeAdapter<SuperSectionStudentGrade> {
  @override
  final int typeId = 17;

  @override
  SuperSectionStudentGrade read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SuperSectionStudentGrade(
      id: fields[0] as String,
      name: fields[1] as String,
      colorHex: fields[2] as int?,
      studentId: fields[4] as String?,
      cumulativeGrade: fields[5] as String?,
      sectionsGrades: (fields[6] as List).cast<SectionStudentGrade>(),
    )..sections = (fields[3] as List).cast<Section>();
  }

  @override
  void write(BinaryWriter writer, SuperSectionStudentGrade obj) {
    writer
      ..writeByte(7)
      ..writeByte(4)
      ..write(obj.studentId)
      ..writeByte(5)
      ..write(obj.cumulativeGrade)
      ..writeByte(6)
      ..write(obj.sectionsGrades)
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
      other is SuperSectionStudentGradeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuperSectionStudentGrade _$SuperSectionStudentGradeFromJson(
        Map<String, dynamic> json) =>
    SuperSectionStudentGrade(
      id: json['id'] as String,
      name: json['name'] as String,
      colorHex: json['colorHex'] as int?,
      studentId: json['studentId'] as String?,
      cumulativeGrade: json['cumulativeGrade'] as String?,
      sectionsGrades: (json['sectionsGrades'] as List<dynamic>)
          .map((e) => SectionStudentGrade.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..sections = (json['sections'] as List<dynamic>)
        .map((e) => Section.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$SuperSectionStudentGradeToJson(
        SuperSectionStudentGrade instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'colorHex': instance.colorHex,
      'sections': instance.sections.map((e) => e.toJson()).toList(),
      'studentId': instance.studentId,
      'cumulativeGrade': instance.cumulativeGrade,
      'sectionsGrades': instance.sectionsGrades.map((e) => e.toJson()).toList(),
    };
