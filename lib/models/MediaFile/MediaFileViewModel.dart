import 'package:json_annotation/json_annotation.dart';

part 'MediaFileViewModel.g.dart';

@JsonSerializable(explicitToJson: true)
class MediaFileViewModel {
  int id;
  String? fileName;
  String? mimeType;
  String? description;
  MediaFileViewModel? thumbnail;
  String? filePathOnDeviceForUploading;

  MediaFileViewModel(
    this.id,
    this.fileName,
    this.mimeType,
    this.description,
    this.thumbnail,
    this.filePathOnDeviceForUploading,
  );

  factory MediaFileViewModel.fromJson(Map<String, dynamic> srcJson) =>
      _$MediaFileViewModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MediaFileViewModelToJson(this);
}
