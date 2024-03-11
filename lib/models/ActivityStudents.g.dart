// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ActivityStudents.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityStudentsAdapter extends TypeAdapter<ActivityStudents> {
  @override
  final int typeId = 6;

  @override
  ActivityStudents read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityStudents(
      id: fields[0] as String,
      classId: fields[1] as String,
      timestamp: fields[2] as int,
      studentTasks: (fields[3] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List).cast<Task>())),
      lastTimeUploadedToServer: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityStudents obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.classId)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.studentTasks)
      ..writeByte(4)
      ..write(obj.lastTimeUploadedToServer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityStudentsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityStudents _$ActivityStudentsFromJson(Map<String, dynamic> json) =>
    ActivityStudents(
      id: json['id'] as String,
      classId: json['classId'] as String,
      timestamp: json['timestamp'] as int,
      studentTasks: (json['studentTasks'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) => Task.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
      lastTimeUploadedToServer: json['lastTimeUploadedToServer'] as int?,
    );

Map<String, dynamic> _$ActivityStudentsToJson(ActivityStudents instance) =>
    <String, dynamic>{
      'id': instance.id,
      'classId': instance.classId,
      'timestamp': instance.timestamp,
      'studentTasks': instance.studentTasks
          .map((k, e) => MapEntry(k, e.map((e) => e.toJson()).toList())),
      'lastTimeUploadedToServer': instance.lastTimeUploadedToServer,
    };
