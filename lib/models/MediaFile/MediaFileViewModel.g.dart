// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MediaFileViewModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaFileViewModel _$MediaFileViewModelFromJson(Map<String, dynamic> json) =>
    MediaFileViewModel(
      json['id'] as int,
      json['fileName'] as String?,
      json['mimeType'] as String?,
      json['description'] as String?,
      json['thumbnail'] == null
          ? null
          : MediaFileViewModel.fromJson(
              json['thumbnail'] as Map<String, dynamic>),
      json['filePathOnDeviceForUploading'] as String?,
    );

Map<String, dynamic> _$MediaFileViewModelToJson(MediaFileViewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fileName': instance.fileName,
      'mimeType': instance.mimeType,
      'description': instance.description,
      'thumbnail': instance.thumbnail?.toJson(),
      'filePathOnDeviceForUploading': instance.filePathOnDeviceForUploading,
    };
