// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CustomQuestionOptionModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomQuestionOptionModelAdapter
    extends TypeAdapter<CustomQuestionOptionModel> {
  @override
  final int typeId = 3;

  @override
  CustomQuestionOptionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomQuestionOptionModel(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String?,
      fields[3] as bool,
      fields[4] as String?,
      fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomQuestionOptionModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.questionId)
      ..writeByte(3)
      ..write(obj.isCorrect)
      ..writeByte(4)
      ..write(obj.downloadUrl)
      ..writeByte(5)
      ..write(obj.filePathLocally);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomQuestionOptionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomQuestionOptionModel _$CustomQuestionOptionModelFromJson(
        Map<String, dynamic> json) =>
    CustomQuestionOptionModel(
      json['id'] as String,
      json['name'] as String,
      json['questionId'] as String?,
      json['isCorrect'] as bool,
      json['downloadUrl'] as String?,
      json['filePathLocally'] as String?,
    );

Map<String, dynamic> _$CustomQuestionOptionModelToJson(
        CustomQuestionOptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'questionId': instance.questionId,
      'isCorrect': instance.isCorrect,
      'downloadUrl': instance.downloadUrl,
      'filePathLocally': instance.filePathLocally,
    };
