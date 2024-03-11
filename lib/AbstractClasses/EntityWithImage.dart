import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:teachy_tec/models/MediaFile/MediaFileViewModel.dart';
import 'package:teachy_tec/utils/AppUtility.dart';

abstract class EntityWithImage with ChangeNotifier {
  PlatformFile? imageFile;
  bool isLoadedBefore = false;
  int? loadedHeight;
  int? loadedWidth;
  Future loadImage({int? height, int? width});

  Future loadMediaWithHigherQuality(
      {int? height, int? width, Function(bool)? isLoadingCallback});

  void notifyListenersOverriden() {
    super.notifyListeners();
  }
}

// Now implementing only the images ==> But next Step is to have all media
abstract class EntityWithMultipleImages with ChangeNotifier {
  bool isLoadedBefore = false;
  int? loadedHeight;
  int? loadedWidth;
  Map<String, Map<int, int>> loadedMediaFilesWithHeightAndWidthAttributes = {};

  List<PlatformFile>? mediaEntityList;
  Future loadMedia({int? height, int? width});

  void notifyListenersOverriden() {
    super.notifyListeners();
  }

  Future loadMediaWithHigherQuality(
      {int? height,
      int? width,
      required ValueNotifier<MapEntry<String, bool>> currentMediaFileString,
      Function(bool)? isLoadingCallback});
}

abstract class EntityWithMedia with ChangeNotifier {
  bool isLoadedBefore = false;
  int? loadedHeight;
  int? loadedWidth;
  Map<String, Map<int, int>> loadedMediaFilesWithHeightAndWidthAttributes = {};
  // List<PlatformFile>? mediaEntityList;
  Map<PlatformFile, String?>? mediaEntityList;
  // Map<VideoPlayerController, String?>? videoControllers;

  void notifyListenersOverriden() {
    super.notifyListeners();
  }

  Future loadMedia(
      {int? height, int? width, Function(bool)? isLoadingCallback});
  Future loadMediaWithHigherQuality(
      {int? height,
      int? width,
      required ValueNotifier<MapEntry<String, bool>> currentMediaFileString,
      Function(bool)? isLoadingCallback});
}

// abstract class EntityWithMultipleImages extends ChangeNotifier {
//   List<Image>? imageEntityList;
//   Future loadImages();
// }

class ArbitaryClassToLoadEntityWithMediaFiles extends EntityWithMedia {
  MediaFileViewModel? mediaFile;
  ArbitaryClassToLoadEntityWithMediaFiles({required this.mediaFile});
  @override
  Future loadMedia(
      {int? height, int? width, Function(bool)? isLoadingCallback}) async {
    AppUtility.loadNormalMediaOfEntityWithMedia(
      height: height,
      width: width,
      model: this,
      mediaFiles: mediaFile != null ? [mediaFile!] : [],
    );

    // if (mediaFile != null &&
    //     (loadedHeight == null || ((height ?? 580) > (loadedHeight!)))) {
    //   this.loadedHeight = height ?? 580;
    //   this.loadedWidth = width ?? 375;
    //   isLoadedBefore = true;
    //   // if (mediaFile != null)
    //   try {
    //     if (!mediaFile!.mimeType!.contains("video")) {
    //       var result = await serviceLocator<TomatoNetworkProvider>().GetImage(
    //           imageId: mediaFile!.fileName,
    //           height: loadedHeight!,
    //           width: loadedWidth!);
    //       if (result != null) {
    //         if (mediaEntityList == null) {
    //           mediaEntityList = {};
    //         }
    //         mediaEntityList
    //             ?.removeWhere((key, value) => key.name == mediaFile!.fileName);

    //         mediaEntityList!.addAll({
    //           PlatformFile(
    //             name: mediaFile!.fileName ?? '',
    //             size: result.elementSizeInBytes,
    //             bytes: result,
    //           ): null
    //         });

    //         notifyListeners();
    //       }
    //     } else {
    //       var result = await serviceLocator<TomatoNetworkProvider>().GetImage(
    //           imageId: mediaFile!.thumbnail!.fileName,
    //           height: loadedHeight!,
    //           width: loadedWidth!);
    //       if (result != null) {
    //         if (mediaEntityList == null) {
    //           mediaEntityList = {};
    //         }

    //         mediaEntityList
    //             ?.removeWhere((key, value) => key.name == mediaFile!.fileName);

    //         mediaEntityList!.addAll({
    //           PlatformFile(
    //             name: mediaFile!.fileName ?? '',
    //             size: result.elementSizeInBytes,
    //             bytes: result,
    //           ): mediaFile!.fileName
    //         });
    //         notifyListeners();
    //       }
    //     }
    //   } catch (error) {}
    // }
  }

  @override
  Future loadMediaWithHigherQuality(
      {int? height,
      int? width,
      required ValueNotifier<MapEntry<String, bool>> currentMediaFileString,
      Function(bool isLoading)? isLoadingCallback}) async {
    await AppUtility.loadHigherQualityMediaOfEntityWithMedia(
        height: height,
        width: width,
        model: this,
        mediaFiles: mediaFile == null ? [] : [mediaFile!],
        currentMediaFileString: currentMediaFileString);
  }

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<PlatformFile, String?>? mediaEntityList;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  int? loadedHeight;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  int? loadedWidth;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isLoadedBefore = false;
}
