// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TaskViewModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskViewModelAdapter extends TypeAdapter<TaskViewModel> {
  @override
  final int typeId = 8;

  @override
  TaskViewModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskViewModel(
      task: fields[0] as String,
      id: fields[4] as String,
      downloadUrl: fields[1] as String?,
      options: (fields[2] as List?)?.cast<CustomQuestionOptionModel>(),
      taskType: fields[3] as TaskType?,
    );
  }

  @override
  void write(BinaryWriter writer, TaskViewModel obj) {
    writer
      ..writeByte(5)
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
      other is TaskViewModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskViewModel _$TaskViewModelFromJson(Map<String, dynamic> json) =>
    TaskViewModel(
      task: json['task'] as String,
      id: json['id'] as String,
      downloadUrl: json['downloadUrl'] as String?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) =>
              CustomQuestionOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      taskType: $enumDecodeNullable(_$TaskTypeEnumMap, json['taskType']),
      imagePathLocally: json['imagePathLocally'] as String?,
    );

Map<String, dynamic> _$TaskViewModelToJson(TaskViewModel instance) =>
    <String, dynamic>{
      'task': instance.task,
      'downloadUrl': instance.downloadUrl,
      'options': instance.options?.map((e) => e.toJson()).toList(),
      'taskType': _$TaskTypeEnumMap[instance.taskType],
      'imagePathLocally': instance.imagePathLocally,
      'id': instance.id,
    };

const _$TaskTypeEnumMap = {
  TaskType.multipleOptions: 0,
  TaskType.trueFalse: 1,
};
