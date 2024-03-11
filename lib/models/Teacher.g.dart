// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Teacher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Teacher _$TeacherFromJson(Map<String, dynamic> json) => Teacher(
      name: json['name'] as String,
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
      email: json['email'] as String,
    );

Map<String, dynamic> _$TeacherToJson(Teacher instance) => <String, dynamic>{
      'name': instance.name,
      'gender': _$GenderEnumMap[instance.gender],
      'email': instance.email,
    };

const _$GenderEnumMap = {
  Gender.male: 0,
  Gender.female: 1,
};
