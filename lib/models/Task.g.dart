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
      id: fields[4] as String,
      downloadUrl: fields[1] as String?,
      options: (fields[2] as List?)?.cast<CustomQuestionOptionModel>(),
      taskType: fields[3] as TaskType?,
      grade_value: fields[5] as double?,
      emoji_id: fields[6] as String?,
      selectedOption: fields[7] as CustomQuestionOptionModel?,
      comment: fields[8] as String?,
      isCorrectAnswerChosen: fields[9] as bool?,
      enteredTextForCurrentTask: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(11)
      ..writeByte(5)
      ..write(obj.grade_value)
      ..writeByte(6)
      ..write(obj.emoji_id)
      ..writeByte(7)
      ..write(obj.selectedOption)
      ..writeByte(8)
      ..write(obj.comment)
      ..writeByte(9)
      ..write(obj.isCorrectAnswerChosen)
      ..writeByte(10)
      ..write(obj.enteredTextForCurrentTask)
      ..writeByte(0)
      ..write(obj.task)
      ..writeByte(1)
      ..write(obj.downloadUrl)
      ..writeByte(2)
      ..write(obj.options)
      ..writeByte(3)
      ..write(obj.taskType)
      ..writeByte(4)
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
      downloadUrl: json['downloadUrl'] as String?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) =>
              CustomQuestionOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      taskType: $enumDecodeNullable(_$TaskTypeEnumMap, json['taskType']),
      imagePathLocally: json['imagePathLocally'] as String?,
      grade_value: (json['grade_value'] as num?)?.toDouble(),
      emoji_id: json['emoji_id'] as String?,
      selectedOption: json['selectedOption'] == null
          ? null
          : CustomQuestionOptionModel.fromJson(
              json['selectedOption'] as Map<String, dynamic>),
      comment: json['comment'] as String?,
      isCorrectAnswerChosen: json['isCorrectAnswerChosen'] as bool?,
      enteredTextForCurrentTask: json['enteredTextForCurrentTask'] as String?,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'task': instance.task,
      'downloadUrl': instance.downloadUrl,
      'options': instance.options?.map((e) => e.toJson()).toList(),
      'taskType': _$TaskTypeEnumMap[instance.taskType],
      'id': instance.id,
      'imagePathLocally': instance.imagePathLocally,
      'grade_value': instance.grade_value,
      'emoji_id': instance.emoji_id,
      'selectedOption': instance.selectedOption?.toJson(),
      'comment': instance.comment,
      'isCorrectAnswerChosen': instance.isCorrectAnswerChosen,
      'enteredTextForCurrentTask': instance.enteredTextForCurrentTask,
    };

const _$TaskTypeEnumMap = {
  TaskType.multipleOptions: 0,
  TaskType.trueFalse: 1,
  TaskType.textOnly: 2,
};
