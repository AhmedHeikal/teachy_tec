import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:teachy_tec/AbstractClasses/EntityWithImage.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/widgets/AppVideoPlayerScreen.dart';
import 'package:video_player/video_player.dart';
import 'package:collection/collection.dart';

class MediaPageCarousel extends StatefulWidget {
  const MediaPageCarousel(
      {required this.mediaFiles,
      required this.startingIndex,
      this.videoControllers,
      this.startVideoWithPlaying = false,
      Key? key})
      : super(key: key);
  final int startingIndex;
  final Map<PlatformFile, String?> mediaFiles;
  final Map<VideoPlayerController, String?>? videoControllers;
  final bool startVideoWithPlaying;

  @override
  State<MediaPageCarousel> createState() => _MediaPageCarouselState();
}

class _MediaPageCarouselState extends State<MediaPageCarousel> {
  late bool startVideoWithPlaying;
  @override
  void initState() {
    super.initState();
    startVideoWithPlaying = widget.startVideoWithPlaying;
  }

  @override
  void didUpdateWidget(covariant MediaPageCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (oldWidget.initialList?.length == 0 && widget.initialList?.length != 0) {

    setState(
      () {
        // widget.mediaFiles
        // isLoading.value = false;
        // selectedMedia = [...widget.initialList!];

        // selectedMedia.forEach((element) {
        //   videoControllers.addAll({
        //     VideoPlayerController.network(
        //         TomatoEndpoints.Uploads + element.name,
        //         // 'https://mrtomato-qa2.dev.trustsourcing.com/uploads/${element.name}',
        //         httpHeaders: {
        //           "cookie": serviceLocator<LocalStorage>().authCookie
        //         }): element.name
        //   });
        // });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(
        initialPage: widget.startingIndex, viewportFraction: 1.1);

    ChipIndicator chip = ChipIndicator(
        currentPage: widget.startingIndex,
        totalPages: widget.mediaFiles.length);
    return Scaffold(
      backgroundColor: AppColors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 150,
        leading: InkWell(
          onTap: () {
            UIRouter.popScreen(context: context);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 16),
              Center(
                child: SvgPicture.asset(
                  AppUtility.getArrowAssetLocalized(rightArrowInLTR: false),
                  // "assets/vectors/ArrowLeft.svg",
                  height: 12,
                  width: 9,
                  color: AppColors.white,
                  // fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocale.back.getString(context).capitalizeFirstLetter(),
                style: TextStyles.InterWhiteS16W400,
              ),
            ],
          ),
        ),
        actions: const [
          // Center(
          //   child: SizedBox(
          //     height: 15,
          //     width: 15,
          //     child: CircularProgressIndicator(
          //       color: TomatoColors.Green700,
          //       strokeWidth: 2,
          //     ),
          //   ),
          // ),
          // SizedBox(width: kHelpingPadding),
        ],
      ),
      body: Container(
        child: Center(
          child: SizedBox(
            child:
                // Stack(
                //   children: [
                // NotCommented Originalyy
                PhotoViewGallery.builder(
              pageController: controller,
              backgroundDecoration: const BoxDecoration(color: AppColors.black),
              // physics: NeverScrollableScrollPhysics(),
              itemCount: widget.mediaFiles.length,
              // physics: FixedExtentScrollPhysics(),
              allowImplicitScrolling: true,
              // controller: controller,
              onPageChanged: (index) {
                widget.videoControllers?.keys.forEach((element) {
                  element.pause();
                });
                chip.onPageChanged(index);
                if (startVideoWithPlaying) {
                  if (mounted) {
                    setState(() {
                      startVideoWithPlaying = false;
                    });
                  }
                }
              },

              builder: (context, index) {
                if (widget.mediaFiles.values.elementAt(index) != null &&
                    widget.videoControllers != null) {
                  return PhotoViewGalleryPageOptions.customChild(
                    initialScale: PhotoViewComputedScale.contained,
                    child: AppVideoPlayerScreen(
                      model: AppVideoPlayerScreenVM(
                        controller: widget.videoControllers!.entries
                            .firstWhere(
                              (element) =>
                                  element.value ==
                                  widget.mediaFiles.values.elementAt(index),
                            )
                            .key,
                        startVideoWithPlaying: startVideoWithPlaying
                            ? index == widget.startingIndex
                            : false,
                        file:
                            widget.mediaFiles.keys.elementAt(index).name.isVideo
                                ? null
                                : widget.mediaFiles.keys.elementAt(index),
                      ),
                    ),
                    heroAttributes: PhotoViewHeroAttributes(
                        tag: widget.mediaFiles.keys.elementAt(index).name),
                  );
                }
                if (widget.mediaFiles.keys.elementAt(index).bytes != null) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: MemoryImage(
                      widget.mediaFiles.keys.elementAt(index).bytes!,
                    ),
                    initialScale: PhotoViewComputedScale.contained,
                  );
                }

                if (widget.mediaFiles.keys.elementAt(index).path != null) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: FileImage(
                      File(widget.mediaFiles.keys.elementAt(index).path!),
                    ),
                    initialScale: PhotoViewComputedScale.contained,
                  );
                }
                return PhotoViewGalleryPageOptions.customChild(
                    initialScale: PhotoViewComputedScale.contained,
                    child: const SizedBox());
              },
            ),
          ),
        ),
      ),
    );
  }
}

class MediaPageForMediaModels extends StatefulWidget {
  const MediaPageForMediaModels({
    super.key,
    required this.model,
    required this.startingIndex,
    this.videoControllers,
    this.startVideoWithPlaying = false,
  });

  final int startingIndex;
  final dynamic model;
  final Map<VideoPlayerController, String?>? videoControllers;
  final bool startVideoWithPlaying;

  @override
  State<MediaPageForMediaModels> createState() =>
      _MediaPageForMediaModelsState();
}

class _MediaPageForMediaModelsState extends State<MediaPageForMediaModels> {
  ValueNotifier<bool> isLoading = ValueNotifier(true);
  late ValueNotifier<MapEntry<String, bool>> currentMediaFile;
  late bool startVideoWithPlaying;
  bool isAllMediaFilesLoadedWithHigerQuality = false;
  Map<PlatformFile, String?> mediaFiles = {};
  loadMedia() async {
    if (widget.model is EntityWithImage) {
      // isLoading.value = true;
      currentMediaFile = ValueNotifier(
          MapEntry((widget.model as EntityWithImage).imageFile!.name, false));
      mediaFiles = {(widget.model as EntityWithImage).imageFile!: null};

      // mediaFiles = {(widget.model as EntityWithImage).imageFile!: null};
      await (widget.model as EntityWithImage)
          .loadMediaWithHigherQuality()
          .then((value) {
        isLoading.value = false;
        mediaFiles = {(widget.model as EntityWithImage).imageFile!: null};
        isAllMediaFilesLoadedWithHigerQuality = true;
        currentMediaFile = ValueNotifier(MapEntry(
            (widget.model as EntityWithImage).imageFile?.name ?? '', true));
        // currentMediaFile.notifyListeners();

        setState(() {});
      });
    } else if (widget.model is EntityWithMultipleImages) {
      currentMediaFile = ValueNotifier(MapEntry(
          (widget.model as EntityWithMultipleImages)
              .mediaEntityList![widget.startingIndex]
              .name,
          false));
      // mediaFiles = {};
      (widget.model as EntityWithMultipleImages)
          .mediaEntityList!
          .forEach((element) {
        mediaFiles.addAll({element: null});
      });

      await (widget.model as EntityWithMultipleImages)
          .loadMediaWithHigherQuality(
        currentMediaFileString: currentMediaFile,
        // isLoadingCallback: widget.isLoadingCallback,
      )
          .then((value) {
        isLoading.value = false;

        mediaFiles = {};
        (widget.model as EntityWithMultipleImages)
            .mediaEntityList!
            .forEach((element) {
          mediaFiles.addAll({element: null});
        });
        isAllMediaFilesLoadedWithHigerQuality = true;
        // setState(() {});
      });
    } else if (widget.model is EntityWithMedia) {
      // isLoading.value = true;
      currentMediaFile = ValueNotifier(MapEntry(
          (widget.model as EntityWithMedia)
              .mediaEntityList!
              .keys
              .toList()[widget.startingIndex]
              .name,
          false));

      // currentMediaFile = ValueNotifier((widget.model as EntityWithMedia)
      //     .mediaEntityList!
      //     .keys
      //     .toList()[widget.startingIndex]
      //     .name);

      mediaFiles = (widget.model as EntityWithMedia).mediaEntityList ?? {};
      await (widget.model as EntityWithMedia)
          .loadMediaWithHigherQuality(
        currentMediaFileString: currentMediaFile,
        // isLoadingCallback: widget.isLoadingCallback,
      )
          .then((value) {
        isLoading.value = false;
        mediaFiles = (widget.model as EntityWithMedia).mediaEntityList ?? {};
        isAllMediaFilesLoadedWithHigerQuality = true;
        // setState(() {});
      });
    }
  }

  void updateMediaFile() {
    if (widget.model is EntityWithImage) {
      mediaFiles = {(widget.model as EntityWithImage).imageFile!: null};
    } else if (widget.model is EntityWithMultipleImages) {
      mediaFiles = {};
      (widget.model as EntityWithMultipleImages)
          .mediaEntityList!
          .forEach((element) {
        mediaFiles.addAll({element: null});
      });
    } else if (widget.model is EntityWithMedia) {
      mediaFiles = (widget.model as EntityWithMedia).mediaEntityList != null
          ? {...(widget.model as EntityWithMedia).mediaEntityList!}
          : {};
    }
  }

  bool mediaWasAlreadyLoadedBefore() {
    if (widget.model is EntityWithImage) {
      return currentMediaFile.value.value;
    } else if (widget.model is EntityWithMultipleImages) {
      return (widget.model as EntityWithMultipleImages)
              .loadedMediaFilesWithHeightAndWidthAttributes[
                  currentMediaFile.value.key]
              ?.entries
              .first
              .key ==
          2000;
    } else if (widget.model is EntityWithMedia) {
      return (widget.model as EntityWithMedia)
                  .loadedMediaFilesWithHeightAndWidthAttributes[
                      currentMediaFile.value.key]
                  ?.entries
                  .first
                  .key ==
              2000 ||
          (widget.model as EntityWithMedia)
                  .mediaEntityList!
                  .entries
                  .firstWhereOrNull((element) =>
                      element.value == currentMediaFile.value.key) !=
              null;
      // mediaFiles = (widget.model as EntityWithMedia).mediaEntityList ?? {};
    }
    return true;
  }

  @override
  void initState() {
    super.initState();

    loadMedia();
    startVideoWithPlaying = widget.startVideoWithPlaying;
  }

  @override
  void didUpdateWidget(covariant MediaPageForMediaModels oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (oldWidget.initialList?.length == 0 && widget.initialList?.length != 0) {

    // setState(
    //   () {
    //     //  widget.mediaFiles
    //     // isLoading.value = false;
    //     // selectedMedia = [...widget.initialList!];

    //     // selectedMedia.forEach((element) {
    //     //   videoControllers.addAll({
    //     //     VideoPlayerController.network(
    //     //         TomatoEndpoints.Uploads + element.name,
    //     //         // 'https://mrtomato-qa2.dev.trustsourcing.com/uploads/${element.name}',
    //     //         httpHeaders: {
    //     //           "cookie": serviceLocator<LocalStorage>().authCookie
    //     //         }): element.name
    //     //   });
    //     // });
    //   },
    // );
  }

  void updateCurrentMediaFile(int index) {
    if (widget.model is EntityWithImage) {
      currentMediaFile.value = MapEntry(
          (widget.model as EntityWithImage).imageFile?.name ?? '', true);
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      currentMediaFile.notifyListeners();
    } else if (widget.model is EntityWithMultipleImages) {
      currentMediaFile.value = MapEntry(
          (widget.model as EntityWithMultipleImages)
              .mediaEntityList![index]
              .name,
          isAllMediaFilesLoadedWithHigerQuality);
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      currentMediaFile.notifyListeners();
    } else if (widget.model is EntityWithMedia) {
      // isLoading.value = true;
      currentMediaFile.value = MapEntry(
          (widget.model as EntityWithMedia)
              .mediaEntityList!
              .keys
              .toList()[index]
              .name,
          isAllMediaFilesLoadedWithHigerQuality);
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      currentMediaFile.notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(
        initialPage: widget.startingIndex, viewportFraction: 1.1);

    ChipIndicator chip = ChipIndicator(
        currentPage: widget.startingIndex, totalPages: mediaFiles.length);

    return Scaffold(
      backgroundColor: AppColors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 150,
        leading: InkWell(
          onTap: () {
            UIRouter.popScreen(context: context);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: kMainPadding),
              Center(
                child: SvgPicture.asset(
                  AppUtility.getArrowAssetLocalized(rightArrowInLTR: false),
                  // "assets/vectors/ArrowLeft.svg",
                  height: 12,
                  width: 9,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(width: kBottomPadding),
              Text(
                AppLocale.back.getString(context).capitalizeFirstLetter(),
                style: TextStyles.InterWhiteS16W600,
              ),
            ],
          ),
        ),
        actions: [
          ValueListenableBuilder<MapEntry<String, bool>>(
            valueListenable: currentMediaFile,
            builder: (context, currentMediaFile, child) =>
                (!mediaWasAlreadyLoadedBefore())
                    ? const Center(
                        child: SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: AppColors.primary700,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : const SizedBox(),
          ),
          const SizedBox(width: kMainPadding),
        ],
      ),
      body: Center(
        child: SizedBox(
          child: ValueListenableBuilder<MapEntry<String, bool>>(
            valueListenable: currentMediaFile,
            builder: (context, currentMediaFile, child) {
              updateMediaFile();
              return TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                builder: (_, double value, Widget? child) => Opacity(
                  opacity: value,
                  child: child,
                ),
                child: PhotoViewGallery.builder(
                  pageController: controller,
                  gaplessPlayback: true,
                  wantKeepAlive: true,
                  backgroundDecoration:
                      const BoxDecoration(color: AppColors.black),
                  itemCount: mediaFiles.length,
                  allowImplicitScrolling: true,
                  onPageChanged: (index) {
                    updateCurrentMediaFile(index);
                    widget.videoControllers?.keys.forEach((element) {
                      element.pause();
                    });
                    chip.onPageChanged(index);
                    if (startVideoWithPlaying) {
                      if (mounted) {
                        setState(
                          () {
                            startVideoWithPlaying = false;
                          },
                        );
                      }
                    }
                  },
                  builder: (context, index) {
                    if (mediaFiles.values.elementAt(index) != null &&
                        widget.videoControllers != null) {
                      return PhotoViewGalleryPageOptions.customChild(
                        heroAttributes: PhotoViewHeroAttributes(
                            tag: mediaFiles.keys.elementAt(index).name),
                        initialScale: PhotoViewComputedScale.contained,
                        child: AppVideoPlayerScreen(
                          model: AppVideoPlayerScreenVM(
                            controller: widget.videoControllers!.entries
                                .firstWhere(
                                  (element) =>
                                      element.value ==
                                      mediaFiles.values.elementAt(index),
                                )
                                .key,
                            startVideoWithPlaying: startVideoWithPlaying
                                ? index == widget.startingIndex
                                : false,
                            file: mediaFiles.keys.elementAt(index).name.isVideo
                                ? null
                                : mediaFiles.keys.elementAt(index),
                          ),
                        ),
                      );
                    }
                    if (mediaFiles.keys.elementAt(index).bytes != null) {
                      return PhotoViewGalleryPageOptions(
                        heroAttributes: PhotoViewHeroAttributes(
                            tag: mediaFiles.keys.elementAt(index).name),
                        imageProvider: MemoryImage(
                          mediaFiles.keys.elementAt(index).bytes!,
                        ),
                        initialScale: PhotoViewComputedScale.contained,
                      );
                    }

                    if (mediaFiles.keys.elementAt(index).path != null) {
                      return PhotoViewGalleryPageOptions(
                        heroAttributes: PhotoViewHeroAttributes(
                            tag: mediaFiles.keys.elementAt(index).name),
                        imageProvider: FileImage(
                          File(mediaFiles.keys.elementAt(index).path!),
                        ),
                        initialScale: PhotoViewComputedScale.contained,
                      );
                    }
                    return PhotoViewGalleryPageOptions.customChild(
                        heroAttributes: PhotoViewHeroAttributes(
                            tag: mediaFiles.keys.elementAt(index).name),
                        initialScale: PhotoViewComputedScale.contained,
                        child: const SizedBox());
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ChipIndicator extends ChangeNotifier {
  int currentPage;
  int totalPages;
  ChipIndicator({required this.currentPage, required this.totalPages});

  onPageChanged(int value) {
    currentPage = value;
    notifyListeners();
  }
}
