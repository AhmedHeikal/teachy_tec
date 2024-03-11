// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 5;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      task: fields[0] as String,
      id: fields[7] as String,
      grade_value: fields[1] as double?,
      emoji_id: fields[2] as String?,
      selectedOption: fields[3] as CustomQuestionOptionModel?,
      comment: fields[4] as String?,
      imagePathInFireStore: fields[5] as String?,
      options: (fields[6] as List?)?.cast<CustomQuestionOptionModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.task)
      ..writeByte(1)
      ..write(obj.grade_value)
      ..writeByte(2)
      ..write(obj.emoji_id)
      ..writeByte(3)
      ..write(obj.selectedOption)
      ..writeByte(4)
      ..write(obj.comment)
      ..writeByte(5)
      ..write(obj.imagePathInFireStore)
      ..writeByte(6)
      ..write(obj.options)
      ..writeByte(7)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      task: json['task'] as String,
      id: json['id'] as String,
      grade_value: (json['grade_value'] as num?)?.toDouble(),
      emoji_id: json['emoji_id'] as String?,
      selectedOption: json['selectedOption'] == null
          ? null
          : CustomQuestionOptionModel.fromJson(
              json['selectedOption'] as Map<String, dynamic>),
      comment: json['comment'] as String?,
      imagePathInFireStore: json['imagePathInFireStore'] as String?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) =>
              CustomQuestionOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'task': instance.task,
      'grade_value': instance.grade_value,
      'emoji_id': instance.emoji_id,
      'selectedOption': instance.selectedOption?.toJson(),
      'comment': instance.comment,
      'imagePathInFireStore': instance.imagePathInFireStore,
      'options': instance.options?.map((e) => e.toJson()).toList(),
      'id': instance.id,
    };
