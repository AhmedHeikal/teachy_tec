import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/utils/Routing/AppAnalyticsConstants.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/widgets/AppPermissionBottomDialogue.dart';
import 'package:teachy_tec/widgets/MediaPageCarousel.dart';
import 'package:teachy_tec/widgets/showSpecificNotifications.dart';
import 'package:teachy_tec/widgets/unfocusCurrentNode.dart';
import 'package:video_player/video_player.dart';

enum mediaSelectionType {
  takePicture,
  takeVideo,
  selectMediaFromGallery,
}

class MediaPickerWidget extends StatefulWidget {
  final int maxMediaCount;
  final bool canUploadVideos;
  final bool canSelectFromGallery;
  final bool isStartingbyLoading;

  // final double height;
  final List<PlatformFile>? initialList;
  final double? width;
  final double? height;
  final bool isReadOnly;
  final Widget? customDesignWithoutSelection;
  final Widget Function(List<PlatformFile>?)? customDesignWithSelection;
  final Function(List<PlatformFile>?)? mediaCallBack;
  // final Funtion(List<PlatformFile>)? callbackActionWhenMediaIsSelected;
  // Same widget for Single and Multiple upload.
  // Control the videos and media count by parameters when creating the widget.
  const MediaPickerWidget({
    Key? key,
    this.initialList,
    this.isReadOnly = false,
    this.maxMediaCount = 1,
    this.customDesignWithoutSelection,
    this.customDesignWithSelection,
    this.isStartingbyLoading = false,
    this.canUploadVideos = false,
    this.canSelectFromGallery = true,
    // this.callbackActionWhenMediaIsSelected,
    // this.height = 200,
    this.width /* = double.infinity */,
    this.height,
    this.mediaCallBack,
  })  : _isExternallyControlledWithInitialHidingAndSmallMediaPreview = false,
        super(key: key);

  const MediaPickerWidget.externallyControlledWithInitialHidingAndSmallMediaPreview({
    Key? key,
    this.initialList,
    this.isReadOnly = false,
    this.maxMediaCount = 1,
    this.isStartingbyLoading = false,
    this.customDesignWithSelection,
    this.customDesignWithoutSelection,
    this.canUploadVideos = false,
    this.canSelectFromGallery = true,
    this.width,
    this.height,
    this.mediaCallBack,
  })  : _isExternallyControlledWithInitialHidingAndSmallMediaPreview = true,
        super(key: key);
  final bool _isExternallyControlledWithInitialHidingAndSmallMediaPreview;
  @override
  State<MediaPickerWidget> createState() => MediaPickerWidgetState();
}

class MediaPickerWidgetState
    extends State<MediaPickerWidget> /* with WidgetsBindingObserver */ {
  List<PlatformFile> selectedMedia = [];
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  Map<VideoPlayerController, String?> videoControllers = {};

  @override
  void didUpdateWidget(covariant MediaPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (oldWidget.initialList?.length == 0 && widget.initialList?.length != 0) {

    if (widget.initialList != null &&
        (oldWidget.initialList?.length != widget.initialList?.length &&
            mounted)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(
          () {
            isLoading.value = false;
            selectedMedia = [...widget.initialList!];
            // TODO: VIDEO Stream
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
      });
    }
  }

  late double gridWidth;
  late double gridHeight;
  mediaSelectionType? selectedMediaType;

  @override
  void dispose() {
    super.dispose();
    // WidgetsBinding.instance.removeObserver(this);
    for (var element in videoControllers.keys) {
      element.dispose();
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint(
        'Heikal - is the _isExternallyControlledWithInitialHidingAndSmallMediaPreview ${widget._isExternallyControlledWithInitialHidingAndSmallMediaPreview}');

    isLoading.value = widget.isStartingbyLoading;

    if (widget.initialList != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          isLoading.value = false;
          selectedMedia = [...widget.initialList!];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.width == null) {
      // Subtracted 7 that's symmetric padding and KMainpadding/2 is half horizontal space betwween items
      gridWidth = (MediaQuery.sizeOf(context).width) - (kMainPadding / 2);
    } else {
      gridWidth = widget.width!;
    }

    gridHeight = ((widget.height ?? 200) * gridWidth) / (widget.width ?? 343);

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          InkWell(
            onTap: widget.isReadOnly
                ? null
                : widget
                        ._isExternallyControlledWithInitialHidingAndSmallMediaPreview
                    ? () => _onImageTap(
                          index: 0,
                          videoController: videoControllers,
                        )
                    : isLoading.value ||
                            (widget.maxMediaCount != 1 &&
                                selectedMedia.isNotEmpty)
                        ? null
                        : () async {
                            unfocusCurrentNode();
                            await mediaSelectionBottomSheet(context);
                          },
            child: widget
                        ._isExternallyControlledWithInitialHidingAndSmallMediaPreview &&
                    selectedMedia.isEmpty
                ? Container()
                : selectedMedia.isEmpty
                    ? widget.customDesignWithoutSelection ??
                        Container(
                          width: gridWidth,
                          height: gridHeight,
                          padding: const EdgeInsets.symmetric(vertical: 38),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            border: Border.all(color: AppColors.grey200),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                widget.canUploadVideos
                                    ? 'assets/svg/ImageVideoFrame.svg'
                                    : 'assets/svg/ImageFrame.svg',
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                widget.canUploadVideos
                                    ? AppLocale.tapToUploadMedia
                                        .getString(context)
                                        .capitalizeAllWord()
                                    : AppLocale.tapToUploadPhoto
                                        .getString(context)
                                        .capitalizeAllWord(),
                                style: TextStyles.InterGrey300S12W600,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                widget.canUploadVideos
                                    ? AppLocale.mediaConstraints
                                        .getString(context)
                                        .toLowerCase()
                                    : AppLocale.photoConstraints
                                        .getString(context)
                                        .toLowerCase(),
                                style: TextStyles.InterGrey300S12W600,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                    : widget.customDesignWithSelection != null
                        ? widget.customDesignWithSelection!(selectedMedia)
                        : widget.maxMediaCount == 1
                            ? SingleMediaPickerTile(
                                isReadOnly: widget.isReadOnly,
                                file: selectedMedia.single,
                                isExternallyControlledAndSmallPreviewed: widget
                                    ._isExternallyControlledWithInitialHidingAndSmallMediaPreview,
                                videoController: (selectedMedia
                                            .single.name.isVideo) ||
                                        (selectedMedia.single.path != null &&
                                            selectedMedia.single.path!.isVideo)
                                    ? videoControllers.entries.first.key
                                    : null,
                                // isVideo: selectedMedia.single.path != null
                                //     ? selectedMedia.single.path!.isVideo
                                //     : false,
                                width: gridWidth,
                                height: gridHeight,
                                onTapMedia: () => mediaSelectionBottomSheet(
                                  context,
                                ),
                                onRemoveTapped: () {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    setState(() {
                                      if (selectedMedia.single.name.isVideo) {
                                        videoControllers.keys.first.dispose();
                                        videoControllers.clear();
                                      }
                                      selectedMedia.clear();
                                      widget.mediaCallBack?.call(selectedMedia);
                                    });
                                  });
                                },
                              )
                            : selectedMedia.length == 1
                                ? SingleMediaPickerTile(
                                    isReadOnly: widget.isReadOnly,
                                    file: selectedMedia.single,
                                    isExternallyControlledAndSmallPreviewed: widget
                                        ._isExternallyControlledWithInitialHidingAndSmallMediaPreview,
                                    height: gridHeight,
                                    width: gridWidth,
                                    videoController:
                                        selectedMedia.single.name.isVideo
                                            ? videoControllers.entries.first.key
                                            : null,

                                    // isVideo: selectedMedia.single.path != null
                                    //     ? selectedMedia.single.path!.isVideo
                                    //     : false,
                                    multipleMedia: true,
                                    onTapMedia: () =>
                                        mediaSelectionBottomSheet(context),
                                    onRemoveTapped: () {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        setState(() {
                                          if (selectedMedia
                                              .single.name.isVideo) {
                                            videoControllers.keys.first
                                                .dispose();

                                            videoControllers.clear();
                                          }

                                          selectedMedia.clear();
                                          widget.mediaCallBack
                                              ?.call(selectedMedia);
                                        });
                                      });
                                    })
                                : GridView.builder(
                                    shrinkWrap: true,
                                    clipBehavior: Clip.none,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          (widget._isExternallyControlledWithInitialHidingAndSmallMediaPreview &&
                                                  selectedMedia.length < 3
                                              ? selectedMedia.length
                                              : 3),
                                      mainAxisSpacing: 8,
                                      crossAxisSpacing: 8,
                                      childAspectRatio: 54 / 31,
                                    ),
                                    itemCount: widget
                                            ._isExternallyControlledWithInitialHidingAndSmallMediaPreview
                                        ? selectedMedia.length
                                        : widget.maxMediaCount,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      // debugPrint(
                                      //"Riad - isVideo = ${selectedMedia.elementAtOrNull(index)?.name.isVideo}");
                                      final isVideo =
                                          (selectedMedia.length >= index) &&
                                              (selectedMedia
                                                      .elementAtOrNull(index)
                                                      ?.name
                                                      .isVideo ??
                                                  false);
                                      return MediaPickerTile(
                                        key: UniqueKey(),
                                        isReadOnly: widget.isReadOnly,
                                        onMediaTapped: () => _onImageTap(
                                          index: index,
                                          videoController: videoControllers,
                                        ),

                                        //  {
                                        /*  if (isVideo ?? false) {
                                    // UIRouter.pushScreen(TomatoVideoPlayerScreen(
                                    //     model: TomatoVideoPlayerScreenVM(
                                    //         videoLink: selectedMedia
                                    //             .elementAtOrNull(index)!
                                    //             .name)));
                                  } else { */
                                        // UIRouter.pushScreen(MediaPageCarousel(
                                        //   startingIndex: index,
                                        //   mediaFiles: selectedMedia,
                                        // ));
                                        // }
                                        // },
                                        videoController: isVideo
                                            ? videoControllers.entries
                                                .firstWhere((element) =>
                                                    element.value ==
                                                    selectedMedia
                                                        .elementAtOrNull(index)
                                                        ?.name)
                                                .key
                                            : null,
                                        // isVideo: isVideo,
                                        onRemoveTapped: () {
                                          // debugPrint(
                                          //'Heikal - videosController length before deleting - ' +
                                          //videoControllers.length.toString());
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            setState(() {
                                              if (isVideo) {
                                                var elementIndex =
                                                    videoControllers.entries
                                                        .toList()
                                                        .indexWhere((element) =>
                                                            element.value ==
                                                            selectedMedia
                                                                .elementAtOrNull(
                                                                    index)
                                                                ?.name);

                                                videoControllers.entries
                                                    .toList()[elementIndex]
                                                    .key
                                                    .dispose();

                                                videoControllers.remove(
                                                    videoControllers.entries
                                                        .toList()[elementIndex]
                                                        .key);
                                                // element.key.dispose();
                                                // videoControllers.remove(element);
                                              }
                                              selectedMedia.removeAt(index);
                                              // debugPrint(
                                              //'Heikal - videosController length after deleting - ' +
                                              //  videoControllers.length.toString());
                                              widget.mediaCallBack
                                                  ?.call(selectedMedia);
                                            });
                                          });
                                        },
                                        // mediaPath: selectedMedia.elementAtOrNull(index)?.path,
                                        file: selectedMedia
                                            .elementAtOrNull(index),
                                        onEmptyTileTap: () async {
                                          unfocusCurrentNode();
                                          await mediaSelectionBottomSheet(
                                              context);
                                        },
                                      );
                                    }),
          ),
          // if (isLoading)
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (context, isLoading, child) => isLoading
                ? Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AbsorbPointer(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          color: AppColors.grey400.withOpacity(0.4),
                          child: const Center(
                              child: CircularProgressIndicator(
                            color: AppColors.primary700,
                          )),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          )
        ],
      ),
    );
  }

  _onImageTap({
    required int index,
    Map<VideoPlayerController, String?>? videoController,
    bool? startWithVideoPlaying,
  }) async {
    Map<PlatformFile, String?> mediaFiles = {};

    selectedMedia.forEach((element) {
      mediaFiles.addAll({element: element.name.isVideo ? element.name : null});
    });

    await UIRouter.pushScreen(
      MediaPageCarousel(
          mediaFiles: mediaFiles,
          videoControllers: videoController,
          startVideoWithPlaying: startWithVideoPlaying ?? false,
          startingIndex: index),
      pageName: AppAnalyticsConstants.MediaPreviewScreen,
    );
  }

  // Future<String> saveMediaFile(File pickedFile, int stepId) async {
  //   // Get the directory for the platform-specific external storage directory.
  //   // This will return null on iOS since iOS doesn't have an external storage directory.
  //   final directory = Platform.isAndroid
  //       ? await getExternalStorageDirectory()
  //       : await getApplicationDocumentsDirectory();

  //   String filePath = "";
  //   final subDirectory = directory?.path ?? "";
  //   final fileName = 'checkListItemName' +
  //       '_' +
  //       stepId.toString() +
  //       '.' +
  //       pickedFile.path.split('.').last;
  //   filePath = '$subDirectory/$fileName';
  //   await pickedFile.copy(filePath);

  //   // // Write the media file to the platform-specific directory.
  //   // if (Platform.isAndroid) {
  //   //   // Get the external storage directory on Android
  //   //   final subDirectory = directory?.path ?? "";
  //   //   final fileName = checkListItem.name;
  //   //   // 'checklist_${DateTime.now().millisecondsSinceEpoch}${pickedFile.path.split('.').last}';
  //   //   final file = File('$subDirectory/$fileName');
  //   //   await file.writeAsBytes(await pickedFile.readAsBytes());
  //   //   filePath = file.path;
  //   // } else if (Platform.isIOS) {
  //   //   // Get the documents directory on iOS
  //   //   // final subDirectory = directory.path;
  //   //   final subDirectory = directory?.path ?? "";
  //   //   final fileName = checkListItem.name;

  //   //   // final fileName =
  //   //   //     'picked_media_${DateTime.now().millisecondsSinceEpoch}${pickedFile.path.split('.').last}';
  //   //   filePath = '$subDirectory/$fileName';
  //   //   // final file = File('$subDirectory/$fileName');
  //   //   await pickedFile.copy(filePath);
  //   //   // filePath = file.path;
  //   // }

  //   return filePath;
  // }

  Future<void> selectMediaFromGallery() async {
    if (!await checkIfAlreadyHasPermissionForMediaGallery()) {
      var acceptedToGivePermission = await AppPermissionBottomDialogue(
        headerText: AppLocale.photosPermission
            .getString(UIRouter.getCurrentContext())
            .capitalizeAllWord(),
        adviceText: AppLocale.photosPermissionDescription
            .getString(UIRouter.getCurrentContext())
            .capitalizeFirstLetter(),
      );

      // var acceptedToGivePermission =
      //     await tomatoAskForMediaGalleryPermissionModal();

      if (acceptedToGivePermission) {
        var permissionAccepted = await requestGalleryPermissions();
        if (!permissionAccepted) return;
      } else {
        return;
      }
    }

    // if (await checkIfAlreadyHasPermissionForMediaGallery()) {
    //   var permissionAccepted = await requestGalleryPermissions();
    //   if (!permissionAccepted) return;
    // } else {
    //   return;
    // }

    FilePicker picker = FilePicker.platform;
    isLoading.value = true;

    FilePickerResult? result = await picker.pickFiles(
      type: widget.canUploadVideos ? FileType.media : FileType.image,
      allowMultiple: widget.maxMediaCount > 1,
    );

    isLoading.value = false;

    if (result == null) {
    } else {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            if (widget.maxMediaCount == 1) selectedMedia.clear();
            List<PlatformFile> files =
                result.files.take(widget.maxMediaCount).toList();

            files = files
                .map(
                  (e) => PlatformFile(
                    name: e.name.replaceAll(' ', ''),
                    size: e.size,
                    path: e.path,
                    bytes: e.bytes,
                    identifier: e.identifier,
                  ),
                )
                .toList();
            for (var element in files) {
              var mediaType = MediaType.undefined;

              // If Item Chosen is not from the supported types remove it and show error
              if (kImageExtensions.any((ext) =>
                  element.extension?.toLowerCase() == ext.toLowerCase())) {
                mediaType = MediaType.image;
              } else if (kVideoExtensions.any((ext) =>
                  element.extension?.toLowerCase() == ext.toLowerCase())) {
                mediaType = MediaType.video;
              }

              if (mediaType == MediaType.undefined) {
                files.remove(element);
                showSpecificNotificaiton(
                    notifcationDetails: AppNotifcationsItems.unsupportedMedia);
                // EasyLoading.showError("You chose unsupported element (", duration: Duration(seconds: 2));
              }
              // if element more than the size then remove it and show error message
              else if ((mediaType == MediaType.image &&
                      ((element.size / (1024 * 1024)) > 10)) ||
                  (mediaType == MediaType.video &&
                      ((element.size / (1024 * 1024)) > 300))) {
                files.remove(element);
                showSpecificNotificaiton(
                  notifcationDetails: AppNotifcationsItems.fileSizeExceeded,
                );

                // EasyLoading.showError("the file size was exeeded",
                //     duration: Duration(seconds: 2));
              }
              // If the element is duplicated then remove it form the list
              else if (selectedMedia.any((selectedMediaFile) =>
                  selectedMediaFile.name == element.name)) {
                files.remove(element);
                showSpecificNotificaiton(
                    notifcationDetails:
                        AppNotifcationsItems.mediaChosenAlready);
                // EasyLoading.showError("You chose this item before ((",
                //     duration: Duration(seconds: 2));
              }
              // If the element is video, add its controller
              else if (element.path != null && element.path!.isVideo) {
                videoControllers.addAll({
                  VideoPlayerController.file(File(element.path!)): element.name
                });
              }
            }

            selectedMedia.addAll(files);
            if (result.files.length > widget.maxMediaCount) {
              showSpecificNotificaiton(
                  notifcationDetails:
                      AppNotifcationsItems.itemsExceeded(widget.maxMediaCount));
            }

            widget.mediaCallBack?.call(selectedMedia);
          });
        });
      }
    }
  }

  Future<void> captureVideo() async {
    if (!await checkIfAlreadyHasPermissionForPhotoAndVideoCapturing()) {
      var acceptedToGivePermission = await AppPermissionBottomDialogue(
        headerText: AppLocale.cameraMicrophonePermission
            .getString(UIRouter.getCurrentContext())
            .capitalizeAllWord(),
        adviceText: AppLocale.cameraMicrophonePermissionDescription
            .getString(UIRouter.getCurrentContext())
            .capitalizeFirstLetter(),
      );

      // var acceptedToGivePermission =
      //     await tomatoAskForPhotoAndVideoCapturingPermissionModal(
      //         isCamera: true);

      if (acceptedToGivePermission) {
        var permissionAccepted = await requestPhotoAndVideoPermissions();
        if (!permissionAccepted) return;
      } else {
        return;
      }
    }

    // debugPrint("Riad - showing image selector 22");
    final ImagePicker _picker = ImagePicker();
    final XFile? imageFile =
        await _picker.pickVideo(source: ImageSource.camera);
    if (imageFile == null) {
      return;
    }

    final video = File(imageFile.path);

    if (video.lengthSync() / (1024 * 1024) > 300) {
      showSpecificNotificaiton(
          notifcationDetails: AppNotifcationsItems.fileSizeExceeded);
      // EasyLoading.showError("video is more than 300MB (",
      //     duration: Duration(seconds: 2));
    }

    if (imageFile.path.isVideo) {
      videoControllers
          .addAll({VideoPlayerController.file(video): imageFile.name});
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (widget.maxMediaCount == 1) selectedMedia.clear();
        selectedMedia.add(
          PlatformFile(
            name: imageFile.name,
            size: video.lengthSync(),
            path: video.path,
            bytes: video.readAsBytesSync(),
          ),
        );
      });
    });
    widget.mediaCallBack?.call(selectedMedia);
  }

  Future<void> capturePhoto() async {
    if (!await checkIfAlreadyHasPermissionForPhotoAndVideoCapturing()) {
      var acceptedToGivePermission = await AppPermissionBottomDialogue(
        headerText: AppLocale.cameraMicrophonePermission
            .getString(UIRouter.getCurrentContext())
            .capitalizeAllWord(),
        adviceText: AppLocale.cameraMicrophonePermissionDescription
            .getString(UIRouter.getCurrentContext())
            .capitalizeFirstLetter(),
      );
      if (acceptedToGivePermission) {
        var permissionAccepted = await requestPhotoAndVideoPermissions();
        if (!permissionAccepted) return;
      } else {
        return;
      }
    }

    // if (await askForPhotoAndVideoCapturingPermissionModal(isCamera: true)) {
    //   var permissionAccepted = await requestPhotoAndVideoPermissions();
    //   if (!permissionAccepted) return;
    // } else {
    //   return;
    // }

    final ImagePicker _picker = ImagePicker();
    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (imageFile == null) {
      return;
    }

    final image = File(imageFile.path);

    if (image.lengthSync() / (1024 * 1024) > 10) {
      showSpecificNotificaiton(
          notifcationDetails: AppNotifcationsItems.fileSizeExceeded);
      // EasyLoading.showError("Image is more than 10MB (",
      //     duration: Duration(seconds: 2));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (widget.maxMediaCount == 1) selectedMedia.clear();
        selectedMedia.add(
          PlatformFile(
            name: image.path.trim(),
            size: image.lengthSync(),
            path: image.path,
            bytes: image.readAsBytesSync(),
          ),
        );
        widget.mediaCallBack?.call(selectedMedia);
      });
    });
  }

  Future<dynamic> mediaSelectionBottomSheet(
    BuildContext context,
  ) async {
    // Map<Permission, PermissionStatus> statuses = await [
    //   if (Platform.isIOS) Permission.photos,
    //   Permission.storage,
    //   if (Platform.isAndroid) Permission.accessMediaLocation,
    //   Permission.camera,
    //   Permission.microphone,
    // ].request();

    // if (statuses.values
    //     .any((element) => !(element.isLimited || element.isGranted))) return;

    return UIRouter.showAppBottomDrawer(
      // context: context,
      options: [
        InkWell(
          onTap: () async {
            UIRouter.popScreen(rootNavigator: true);
            await capturePhoto();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: kMainPadding),
              SvgPicture.asset(
                "assets/svg/Camera.svg",
                color: AppColors.primary700,
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocale.takePhoto.getString(context).capitalizeFirstLetter(),
                style: TextStyles.InterBlackS16W400,
              )
            ],
          ),
        ),
        if (widget.canUploadVideos)
          InkWell(
            onTap: () async {
              UIRouter.popScreen(rootNavigator: true);
              await captureVideo();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: kMainPadding),
                SvgPicture.asset(
                  "assets/svg/Video.svg",
                  color: AppColors.primary700,
                  height: 24,
                  width: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocale.recordVideo
                      .getString(context)
                      .capitalizeFirstLetter(),
                  style: TextStyles.InterBlackS16W400,
                )
              ],
            ),
          ),
        if (widget.canSelectFromGallery)
          InkWell(
            onTap: () async {
              // debugPrint("Riad - showing image selector 33");
              UIRouter.popScreen(rootNavigator: true);
              await selectMediaFromGallery();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: kMainPadding),
                SvgPicture.asset(
                  "assets/svg/Gallery.svg",
                  color: AppColors.primary700,
                  height: 24,
                  width: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocale.chooseFromGallery
                      .getString(context)
                      .capitalizeFirstLetter(),
                  style: TextStyles.InterBlackS16W400,
                )
              ],
            ),
          ),
        if (selectedMedia.length == 1)
          InkWell(
            onTap: () async {
              UIRouter.popScreen(rootNavigator: true);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  if (selectedMedia.single.name.isVideo) {
                    videoControllers.keys.first.dispose();
                    videoControllers.clear();
                  }
                  selectedMedia.clear();
                  widget.mediaCallBack?.call(selectedMedia);
                });
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: kMainPadding),
                SvgPicture.asset(
                  "assets/svg/bin.svg",
                  color: AppColors.red600,
                  height: 24,
                  width: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  selectedMedia.single.name.isVideo
                      ? AppLocale.removeCurrentVideo
                          .getString(context)
                          .toLowerCase()
                          .capitalizeFirstLetter()

                      //  'Remove current Video'
                      : AppLocale.removeCurrentPicture
                          .getString(context)
                          .toLowerCase()
                          .capitalizeFirstLetter(),
                  // "Record a video",
                  style: TextStyles.InterBlackS16W400,
                )
              ],
            ),
          ),
      ],
    );
  }
}

enum MediaType {
  undefined,
  image,
  video,
}

class MediaPickerTile extends StatefulWidget {
  // final bool? isVideo;
  // final String? mediaPath;
  final PlatformFile? file;
  final void Function()? onEmptyTileTap;
  final VoidCallback onRemoveTapped;
  final VoidCallback onMediaTapped;
  final bool isReadOnly;
  final VideoPlayerController? videoController;
  const MediaPickerTile(
      {Key? key,
      // required this.isVideo,
      this.isReadOnly = false,
      this.videoController,
      required this.onMediaTapped,
      // required this.mediaPath,
      this.file,
      required this.onRemoveTapped,
      this.onEmptyTileTap})
      : super(key: key);

  @override
  State<MediaPickerTile> createState() => _MediaPickerTileState();
}

class _MediaPickerTileState extends State<MediaPickerTile> {
  // VideoPlayerController? _controller;

  // late File mediaFile;

  Widget imageWidget = Container();

  @override
  void initState() {
    // debugPrint("Riad - _SingleMediaPickerTileState init state");
    super.initState();

    // widget.file!.path != null
    if (widget.file != null) {
      // if (widget.file!.path != null && widget.file!.path!.trim().isNotEmpty) {
      if (!(widget.file?.path?.checkEmpty ?? true)) {
        imageWidget = PhotoView(
          imageProvider: FileImage(
            File(widget.file!.path!),

            // fit: BoxFit.cover,
          ),
          initialScale: PhotoViewComputedScale.covered,
        );
      } else if (widget.file!.bytes != null) {
        imageWidget = PhotoView(
          imageProvider: MemoryImage(
            // child: Image.memory(
            widget.file!.bytes!,
            // fit: BoxFit.cover,
          ),
          initialScale: PhotoViewComputedScale.covered,
        );
      }
    }

    if ((widget.videoController != null &&
        !widget.videoController!.value.isInitialized)) {
      widget.videoController!.initialize().then((_) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {});
          });
        }
      });
    }

    // mediaFile = File(widget.mediaPath ?? '');
    // mediaFile = File(widget.file?.path ?? '');
    // if ((widget.isVideo ?? false)) {
    // _controller = VideoPlayerController.file(File(widget.mediaPath!))
    // _controller = VideoPlayerController.network(
    //     'https://mrtomato-qa2.dev.trustsourcing.com/uploads/${widget.file?.name}',
    //     httpHeaders: {"cookie": serviceLocator<LocalStorage>().authCookie})
    //   ..initialize().then((_) {
    //     setState(() {});
    //   });
    // }
  }

  // @override
  // void didUpdateWidget(MediaPickerTile oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.isVideo ?? false) {
  //     if (_controller!.value.isInitialized) {
  //       _controller!.dispose();
  //     }
  //     _controller = VideoPlayerController.file(mediaFile)
  //       ..initialize().then((_) => {setState(() {})});
  //   }
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   if (widget.isVideo ?? false) {
  //     if (_controller!.value.isInitialized) {
  //       _controller!.dispose();
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // // debugPrint("Riad - MediaPickerTile mediaPath is ${widget.mediaPath} and isVideo : ${widget.isVideo}");
    // // debugPrint(
    //     "Heikal - MediaPickerTile mediaPath is ${widget.file?.path ?? ""} and isVideo : ${widget.isVideo}");
    return InkWell(
      onTap: () {
        if (widget.file != null) {
          widget.onMediaTapped();
        } else {
          widget.onEmptyTileTap?.call();
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        // child: widget.mediaPath != null
        child: widget.file != null
            ? Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            child: widget.videoController != null
                                ? Center(
                                    child: AspectRatio(
                                        aspectRatio: widget
                                            .videoController!.value.aspectRatio,
                                        child: VideoPlayer(
                                            widget.videoController!)))
                                : imageWidget,
                          ),
                          Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.grey800.withOpacity(0.2),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (!widget.isReadOnly) ...[
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: InkWell(
                        onTap: widget.onRemoveTapped,
                        child: SvgPicture.asset(
                          'assets/svg/bin.svg',
                          color: AppColors.red600,
                          height: 24,
                        ),
                      ),
                    ),
                    if (widget.videoController != null) ...[
                      Positioned(
                        left: 4,
                        bottom: 4,
                        child: Text(
                            AppUtility.getvideoDurationFromDuration(
                              widget.videoController!.value.duration,
                            ),
                            style: TextStyles.InterWhiteS12W400),
                      ),

                      SizedBox(
                        height: 36,
                        width: 36,
                        child: ClipOval(
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: Container(
                              color: AppColors.white.withOpacity(0.2),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // ),
                    ],
                  ],
                ],
              )
            : DottedBorder(
                color: AppColors.grey200,
                radius: const Radius.circular(8),
                borderType: BorderType.RRect,
                dashPattern: const <double>[5, 4],
                strokeWidth: 1,
                child: Center(
                  child: SvgPicture.asset(
                    "assets/svg/PlusSVG.svg",
                    color: AppColors.grey300,
                    height: 20,
                    width: 20,
                  ),
                ),
              ),
      ),
    );
  }
}

class SingleMediaPickerTile extends StatefulWidget {
  final PlatformFile file;
  final void Function() onRemoveTapped;
  final VideoPlayerController? videoController;
  final bool multipleMedia;
  final double height;
  final double? width;
  final Future<dynamic> Function() onTapMedia;
  final bool isExternallyControlledAndSmallPreviewed;
  final bool isReadOnly;
  const SingleMediaPickerTile({
    super.key,
    required this.file,
    this.isReadOnly = false,
    this.height = 200,
    this.width,
    this.multipleMedia = false,
    this.videoController,
    this.isExternallyControlledAndSmallPreviewed = false,
    required this.onTapMedia,
    required this.onRemoveTapped,
  });

  @override
  State<SingleMediaPickerTile> createState() => _SingleMediaPickerTileState();
}

class _SingleMediaPickerTileState extends State<SingleMediaPickerTile> {
  // VideoPlayerController? _controller;

  @override
  void initState() {
    // debugPrint("Riad - _SingleMediaPickerTileState init state");
    super.initState();

    if ((widget.videoController != null &&
        !widget.videoController!.value.isInitialized)) {
      widget.videoController!.initialize().then((_) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {});
          });
        }
      });
    }
  }

  //   if (widget.isVideo && widget.file.path != null) {
  //     _controller = VideoPlayerController.file(File(widget.file.path!))
  //       ..initialize().then((_) => {setState(() {})});
  //     _controller!.setLooping(true);
  //     _controller!.setVolume(0);
  //     _controller!.play();
  //   }
  // }

  @override
  void didUpdateWidget(SingleMediaPickerTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (widget.isVideo && _controller != null) {
    //   if (_controller!.value.isInitialized) {
    //     _controller!.dispose();
    //   }
    //   _controller = VideoPlayerController.file(File(widget.file.path!))
    //     ..initialize().then((_) => {setState(() {})});
    //   _controller!.setLooping(true);
    //   _controller!.setVolume(0);
    //   _controller!.play();
    // }
  }

  @override
  void dispose() {
    // if (widget.isVideo && _controller != null) {
    //   if (_controller!.value.isInitialized) {
    //     _controller!.dispose();
    //   }
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // // debugPrint(
    //     "Riad - SingleMediaPickerTile mediaPath is ${widget.mediaPath} and isVideo : ${widget.isVideo}");
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: widget.height,
        width: widget.isExternallyControlledAndSmallPreviewed
            ? widget.width
            : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          /*     image: widget.isVideo
                ? null
                : DecorationImage(
                    image: Image.file(File(widget.mediaPath)).image,
                    fit: BoxFit.cover) */
        ),
        child: Stack(
          alignment: Alignment.center,
          // fit: StackFit.expand,
          children: [
            // if (widget.isVideo)
            Container(
              child: widget.videoController != null
                  ? Center(
                      child: AspectRatio(
                        aspectRatio: widget.videoController!.value.aspectRatio,
                        child: VideoPlayer(widget.videoController!),
                      ),
                    )
                  : widget.file.path != null
                      ? PhotoView(
                          imageProvider: FileImage(
                            File(widget.file.path!),
                            // fit: BoxFit.fill,
                            // fit: BoxFit.cover,
                          ),
                          // initialScale: PhotoViewComputedScale.covered,
                          // minScale: 0.1
                          tightMode: true,
                          // enablePanAlways:
                        )
                      : PhotoView(
                          imageProvider: MemoryImage(
                            widget.file.bytes!,
                            // fit: BoxFit.cover,
                          ),
                          // initialScale: PhotoViewComputedScale.covered,
                        ),
            ),
            if (!widget.isReadOnly) ...[
              IgnorePointer(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.grey800.withOpacity(0.2),
                  ),
                ),
              ),
              if (widget.isExternallyControlledAndSmallPreviewed)
                Positioned(
                    bottom: 4,
                    right: 4,
                    child: InkWell(
                      onTap: widget.onRemoveTapped,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: SvgPicture.asset(
                          "assets/svg/bin.svg",
                          height: 20,
                          width: 20,
                        ),
                      ),
                    )),
              Positioned(
                bottom: widget.height < 60
                    ? null
                    : widget.isExternallyControlledAndSmallPreviewed
                        ? 4
                        : null,
                top: widget.height < 60
                    ? null
                    : widget.isExternallyControlledAndSmallPreviewed
                        ? null
                        : 18,
                left: widget.height < 60
                    ? null
                    : widget.isExternallyControlledAndSmallPreviewed
                        ? 4
                        : 21,
                child: InkWell(
                  onTap: () {
                    unfocusCurrentNode();
                    widget.onTapMedia();
                  },
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                      child: Container(
                        padding: EdgeInsets.all(widget.height < 60 ? 1 : 2),
                        color: AppColors.white.withOpacity(0.3),
                        child: Transform.rotate(
                          angle: pi / 2,
                          child: SvgPicture.asset(
                            "assets/svg/additional.svg",
                            color: AppColors.white,
                            height:
                                widget.isExternallyControlledAndSmallPreviewed ||
                                        widget.height < 60
                                    ? 20
                                    : 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   padding: const EdgeInsets.all(4),
                  //   decoration: BoxDecoration(
                  //     color: AppColors.grey700,
                  //     shape: BoxShape.circle,
                  //   ),
                  //   child:

                  // ),
                ),
              ),
              if (widget.videoController != null)
                Positioned(
                    bottom: 18,
                    left: 21,
                    child: InkWell(
                      onTap: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            if (widget.videoController!.value.volume == 0) {
                              widget.videoController!.setVolume(1);
                            } else {
                              widget.videoController!.setVolume(0);
                            }
                          });
                        });
                      },
                      child: Icon(
                        widget.videoController!.value.volume == 0
                            ? Icons.volume_off_outlined
                            : Icons.volume_up_rounded,
                        color: AppColors.white,
                        size: 24,
                      ),
                    )),
              if (widget.videoController != null)
                Center(
                  child: InkWell(
                    onTap: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          if (widget.videoController!.value.isPlaying) {
                            widget.videoController!.pause();
                          } else {
                            widget.videoController!.play();
                          }
                        });
                      });
                    },
                    child: SizedBox(
                      height: 72,
                      width: 72,
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            color: AppColors.white.withOpacity(0.2),
                            child: !widget.videoController!.value.isPlaying
                                ? const Icon(
                                    Icons.play_arrow_rounded,
                                    color: AppColors.white,
                                    size: 40,
                                  )
                                : const Icon(
                                    Icons.pause,
                                    color: AppColors.white,
                                    size: 40,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

Future<bool> checkIfAlreadyHasPermissionForMediaGallery() async {
  var photosPermissionStatus = await Permission.photos.status;
  // var storagePermissionStatus = await Permission.storage.status;
  var accessMediaLocationPermissionStatus =
      await Permission.accessMediaLocation.status;

  return ((Platform.isAndroid ||
          photosPermissionStatus.isGranted ||
          photosPermissionStatus.isLimited) &&
      (Platform.isIOS ||
          accessMediaLocationPermissionStatus.isGranted ||
          accessMediaLocationPermissionStatus.isLimited));
}

Future<bool> checkPermenantelyDeniedForGallery() async {
  var photosPermissionStatus = await Permission.photos.status;
  var accessMediaLocationPermissionStatus =
      await Permission.accessMediaLocation.status;

  return ((Platform.isIOS && photosPermissionStatus.isPermanentlyDenied) ||
      (Platform.isAndroid &&
          accessMediaLocationPermissionStatus.isPermanentlyDenied));
}

Future<bool> checkIfAlreadyHasPermissionForPhotoAndVideoCapturing() async {
  var microphonePermissionStatus = await Permission.microphone.status;
  var cameraPermissionStatus = await Permission.camera.status;

  return (cameraPermissionStatus.isGranted ||
          cameraPermissionStatus.isLimited) &&
      (microphonePermissionStatus.isGranted ||
          microphonePermissionStatus.isLimited);
}

Future<bool> checkPermenantelyDeniedForPhotoAndVideoCapturing() async {
  var microphonePermissionStatus = await Permission.microphone.status;
  var cameraPermissionStatus = await Permission.camera.status;

  return ((cameraPermissionStatus.isPermanentlyDenied) ||
      (microphonePermissionStatus.isPermanentlyDenied));
}

Future<bool> requestGalleryPermissions(
    {Function(mediaSelectionType)? callbackOnOpenAppSettings}) async {
  if (await checkPermenantelyDeniedForGallery()) {
    openAppSettings();
    return false;
  }

  Map<Permission, PermissionStatus> statuses = await [
    if (Platform.isIOS) Permission.photos,
    // if (Platform.isIOS) Permission.storage,
    if (Platform.isAndroid) Permission.accessMediaLocation,
    // Permission.camera,
    // Permission.microphone,
  ].request();
  if (statuses.values.any((element) => (element.isPermanentlyDenied))) {
    // openAppSettings();
    return false;
  } else if (statuses.values
      .any((element) => !(element.isLimited || element.isGranted)))
    return false;
  return true;
}

// askForPhotoAndVideoCapturingPermissionModal
Future<bool> requestPhotoAndVideoPermissions() async {
  if (await checkPermenantelyDeniedForPhotoAndVideoCapturing()) {
    openAppSettings();
    return false;
  }

  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.microphone,
  ].request();
  if (statuses.values.any((element) => (element.isPermanentlyDenied))) {
    // openAppSettings();
    return false;
  } else if (statuses.values
      .any((element) => !(element.isLimited || element.isGranted))) {
    return false;
  }
  return true;
}
