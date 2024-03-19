// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Sector.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SectorAdapter extends TypeAdapter<Sector> {
  @override
  final int typeId = 10;

  @override
  Sector read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sector(
      id: fields[0] as String,
      name: fields[1] as String,
      totalGrade: fields[2] as double,
      realWeight: fields[3] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, Sector obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.totalGrade)
      ..writeByte(3)
      ..write(obj.realWeight);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SectorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sector _$SectorFromJson(Map<String, dynamic> json) => Sector(
      id: json['id'] as String,
      name: json['name'] as String,
      totalGrade: (json['totalGrade'] as num).toDouble(),
      realWeight: (json['realWeight'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SectorToJson(Sector instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'totalGrade': instance.totalGrade,
      'realWeight': instance.realWeight,
    };
