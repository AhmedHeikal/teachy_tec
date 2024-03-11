// import 'dart:io';
// import 'dart:ui';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:mr_tomato/AbstractClasses/EntityWithImage.dart';
// import 'package:mr_tomato/localization/AppLocalizations.dart';
// import 'package:mr_tomato/localization/TomatoStrings.dart';
// import 'package:mr_tomato/networking/TomatoEndpoints.dart';
// import 'package:mr_tomato/services/service_locator.dart';
// import 'package:mr_tomato/styles/AppColors.dart';
// import 'package:mr_tomato/styles/TomatoTextStyles.dart';
// import 'package:mr_tomato/utils/LocalStorage.dart';
// import 'package:mr_tomato/utils/TomatoAnalyticsConstants.dart';
// import 'package:mr_tomato/utils/TomatoConstants.dart';
// import 'package:mr_tomato/utils/TomatoExtensions.dart';
// import 'package:mr_tomato/utils/UIRouter.dart';
// import 'package:mr_tomato/utils/VideoCache.dart';
// import 'package:mr_tomato/widgets/AnimatedChipContainer.dart';
// import 'package:mr_tomato/widgets/CachedVideoPreview.dart';
// import 'package:mr_tomato/widgets/MediaPageCarousel.dart';
// import 'package:provider/provider.dart';
// import 'package:teachy_tec/styles/AppColors.dart';
// import 'package:video_player/video_player.dart';

// class MediaProvider extends StatelessWidget {
//   const MediaProvider({
//     this.height,
//     this.width,
//     this.onTapFunction,
//     this.imageRequestHeight,
//     this.imageRequestWidth,
//     this.startingIndex = 0,
//     this.padding,
//     this.margin,
//     this.borderRadius,
//     this.emptyImageAlternative,
//     required this.model,
//     this.selectFirst = false,
//     this.showCurrentImageIndicator = false,
//     this.addTopPaddingToAnimatedChip = false,
//     this.enlargeFeauture = false,
//     this.addFullScreenModeBannerInVideos = true,
//     this.enlargeVideoOnTappingAnyWhere = false,
//     this.isLoadingCallback,
//     this.showVideoPlaybutton = true,
//     this.minimizeVideoEnlargementIcon = false,
//     this.isInView,
//     this.videoCache,
//     super.key,
//   });

//   final bool addFullScreenModeBannerInVideos;
//   final bool enlargeVideoOnTappingAnyWhere;
//   final bool minimizeVideoEnlargementIcon;
//   final int? imageRequestHeight;
//   final int? imageRequestWidth;
//   final double? height;
//   final bool? isInView;
//   final double? width;
//   final EdgeInsets? padding;
//   final EdgeInsets? margin;
//   final BorderRadius? borderRadius;
//   final bool showCurrentImageIndicator;
//   final bool addTopPaddingToAnimatedChip;
//   final dynamic model;
//   final Widget? emptyImageAlternative;
//   final bool selectFirst;
//   final int startingIndex;
//   final bool enlargeFeauture;
//   final VoidCallback? onTapFunction;
//   final VideoCache? videoCache;
//   final Function(bool)? isLoadingCallback;

//   /// For media provider .. videos .. a live case is in stories in newsfeed where no videos reuired
//   final bool showVideoPlaybutton;

//   @override
//   Widget build(BuildContext context) {
//     if (model is EntityWithImage)
//       return ChangeNotifierProvider.value(
//         value: model as EntityWithImage,
//         child: _EntityWithImageWidget(
//           height: this.height,
//           width: this.width,
//           imageRequestHeight: this.imageRequestHeight,
//           imageRequestWidth: this.imageRequestWidth,
//           padding: this.padding,
//           margin: this.margin,
//           borderRadius: this.borderRadius,
//           emptyImageAlternative: this.emptyImageAlternative,
//           enlargeFeauture: this.enlargeFeauture,
//           addTopPaddingToAnimatedChip: this.addTopPaddingToAnimatedChip,
//           onTapFunction: this.onTapFunction,
//           // isLoadingCallback: isLoadingCallback,
//         ),
//       );
//     else if (model is EntityWithMultipleImages)
//       return ChangeNotifierProvider.value(
//         value: model as EntityWithMultipleImages,
//         child: _EntityWithMultipleImagesWidget(
//           height: this.height,
//           width: this.width,
//           imageRequestHeight: this.imageRequestHeight,
//           imageRequestWidth: this.imageRequestWidth,
//           padding: this.padding,
//           margin: this.margin,
//           borderRadius: this.borderRadius,
//           emptyImageAlternative: this.emptyImageAlternative,
//           selectFirst: this.selectFirst,
//           showCurrentImageIndicator: this.showCurrentImageIndicator,
//           startingIndex: this.startingIndex,
//           enlargeFeauture: this.enlargeFeauture,
//           addTopPaddingToAnimatedChip: this.addTopPaddingToAnimatedChip,
//           onTapFunction: this.onTapFunction,
//           // isLoadingCallback: isLoadingCallback,
//         ),
//       );
//     else if (model is EntityWithMedia)
//       return ChangeNotifierProvider.value(
//         value: model as EntityWithMedia,
//         child: _EntityWithMediaWidget(
//           height: this.height,
//           width: this.width,
//           imageRequestHeight: this.imageRequestHeight,
//           addFullScreenModeBannerInVideos: this.addFullScreenModeBannerInVideos,
//           enlargeVideoOnTappingAnyWhere: this.enlargeVideoOnTappingAnyWhere,
//           minimizeVideoEnlargementIcon: this.minimizeVideoEnlargementIcon,
//           imageRequestWidth: this.imageRequestWidth,
//           padding: this.padding,
//           margin: this.margin,
//           borderRadius: this.borderRadius,
//           emptyImageAlternative: this.emptyImageAlternative,
//           selectFirst: this.selectFirst,
//           showCurrentImageIndicator: this.showCurrentImageIndicator,
//           startingIndex: this.startingIndex,
//           enlargeFeauture: this.enlargeFeauture,
//           addTopPaddingToAnimatedChip: this.addTopPaddingToAnimatedChip,
//           isLoadingCallback: this.isLoadingCallback,
//           showVideoPlaybutton: this.showVideoPlaybutton,
//           onTapFunction: this.onTapFunction,
//           videoCache: this.videoCache,
//         ),
//       );
//     return emptyImageAlternative != null
//         ? emptyImageAlternative!
//         : const SizedBox();
//   }
// }

// class _EntityWithImageWidget extends StatefulWidget {
//   const _EntityWithImageWidget({
//     this.height,
//     this.width,
//     this.imageRequestHeight,
//     this.imageRequestWidth,
//     this.padding,
//     this.margin,
//     this.borderRadius,
//     this.emptyImageAlternative,
//     required this.addTopPaddingToAnimatedChip,
//     required this.enlargeFeauture,
//     this.onTapFunction,
//     // this.isLoadingCallback,
//   });

//   final int? imageRequestHeight;
//   final int? imageRequestWidth;
//   final double? height;
//   final double? width;
//   final EdgeInsets? padding;
//   final EdgeInsets? margin;
//   final BorderRadius? borderRadius;
//   final Widget? emptyImageAlternative;
//   final bool enlargeFeauture;
//   final bool addTopPaddingToAnimatedChip;
//   final VoidCallback? onTapFunction;

//   @override
//   State<_EntityWithImageWidget> createState() => _EntityWithImageWidgetState();
// }

// class _EntityWithImageWidgetState extends State<_EntityWithImageWidget> {
//   // final Function(bool)? isLoadingCallback;
//   ValueNotifier<bool> isLoading = ValueNotifier(false);

//   @override
//   Widget build(BuildContext context) {
//     var model = Provider.of<EntityWithImage>(context);
//     // If image is loaded before but a new size requested larger than the current height
//     bool newSize = ((model.loadedHeight != null && model.loadedWidth != null) &&
//         (model.loadedHeight! < (widget.imageRequestHeight ?? 0) ||
//             model.loadedWidth! < (widget.imageRequestWidth ?? 0)));

//     // If image file is null and not loaded before
//     if ((model.imageFile == null && !model.isLoadedBefore) || newSize) {
//       model.loadImage(
//           height: widget.imageRequestHeight, width: widget.imageRequestWidth);
//     }

//     return (model.imageFile != null)
//         ? LayoutBuilder(
//             builder: (context, constraint) => Container(
//               height: widget.height,
//               width: widget.width,
//               margin: widget.margin,
//               padding: widget.padding,
//               child: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   InkWell(
//                     onTap: widget.onTapFunction ??
//                         (widget.enlargeFeauture
//                             ? () => onMediaProviderImageTap(
//                                   model,
//                                   isLoadingCallBack: (isLoading) {
//                                     this.isLoading.value = isLoading;
//                                   },
//                                 )
//                             : null),
//                     child: ClipRRect(
//                       borderRadius: widget.borderRadius ?? BorderRadius.zero,
//                       child: Image.memory(
//                         model.imageFile!.bytes!,
//                         width: constraint.maxWidth,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   ValueListenableBuilder<bool>(
//                     valueListenable: isLoading,
//                     builder: (context, isLoading, child) => isLoading
//                         ? Positioned(
//                             top: 0,
//                             bottom: 0,
//                             left: 0,
//                             right: 0,
//                             child: AbsorbPointer(
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(8),
//                                 child: Container(
//                                   color: AppColors.Grey400.withOpacity(0.4),
//                                   child: Center(
//                                     child: CircularProgressIndicator(
//                                       color: AppColors.Blue700,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 0,
//                             width: 0,
//                           ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         : InkWell(
//             onTap: widget.onTapFunction,
//             child: widget.emptyImageAlternative ?? Container(),
//           );
//   }
// }

// onMediaProviderImageTap(
//   dynamic model, {
//   int? index,
//   Map<VideoPlayerController, String?>? videoController,
//   bool? startWithVideoPlaying,
//   required Function(bool isLoading) isLoadingCallBack,
// }) async {
//   await UIRouter.pushScreen(
//     rootNavigator: true,
//     MediaPageForMediaModels(
//       model: model,
//       // mediaFiles: model.mediaEntityList ?? {},
//       videoControllers: videoController,
//       startVideoWithPlaying: startWithVideoPlaying ?? false,
//       startingIndex: index ?? 0,
//     ),
//     pageName: TomatoAnalyticsConstants.MediaPreviewScreen,
//   );
// }

// onCustomnMediaProviderImageTap(
//   Future<dynamic>? loadMedia({int? height, int? width}),
//   Map<PlatformFile, String?>? mediaEntityList, {
//   int? index,
//   Map<VideoPlayerController, String?>? videoController,
//   bool? startWithVideoPlaying,
//   required Function(bool isLoading) isLoadingCallBack,
// }) async {
//   Map<PlatformFile, String?> mediaFiles = {};
//   // ignore: unnecessary_null_comparison
//   if (loadMedia != null) {
//     isLoadingCallBack(true);
//     await loadMedia(height: 2000, width: 2000);
//     isLoadingCallBack(false);

//     if (mediaEntityList != null) {
//       mediaEntityList.forEach((key, value) {
//         mediaFiles.addAll({
//           key: null,
//         });
//       });

//       // forEach((element) {

//       // });
//     }

//     await UIRouter.pushScreen(
//       rootNavigator: true,
//       MediaPageCarousel(
//         mediaFiles: mediaFiles,
//         videoControllers: videoController,
//         startVideoWithPlaying: startWithVideoPlaying ?? false,
//         startingIndex: index ?? 0,
//       ),
//       pageName: TomatoAnalyticsConstants.MediaPreviewScreen,
//     );
//   }
// }

// class _EntityWithMultipleImagesWidget extends StatefulWidget {
//   const _EntityWithMultipleImagesWidget({
//     this.height,
//     this.width,
//     this.imageRequestHeight,
//     this.imageRequestWidth,
//     this.padding,
//     this.margin,
//     this.borderRadius,
//     this.emptyImageAlternative,
//     required this.enlargeFeauture,
//     required this.addTopPaddingToAnimatedChip,

//     /// To show only the first item
//     this.selectFirst = false,

//     /// In image enlargement
//     this.showCurrentImageIndicator = false,

//     /// Which image to start with in page view
//     this.startingIndex = 0,
//     this.onTapFunction,
//   });

//   final int? imageRequestHeight;
//   final int? imageRequestWidth;
//   final double? height;
//   final double? width;
//   final EdgeInsets? padding;
//   final EdgeInsets? margin;
//   final BorderRadius? borderRadius;
//   final bool showCurrentImageIndicator;
//   final Widget? emptyImageAlternative;
//   final bool selectFirst;
//   final int startingIndex;
//   final bool enlargeFeauture;
//   final bool addTopPaddingToAnimatedChip;
//   final VoidCallback? onTapFunction;

//   @override
//   State<_EntityWithMultipleImagesWidget> createState() =>
//       _EntityWithMultipleImagesWidgetState();
// }

// class _EntityWithMultipleImagesWidgetState
//     extends State<_EntityWithMultipleImagesWidget> {
//   // late PageController controller;
//   late PageController controller;
//   ValueNotifier<bool> isLoading = ValueNotifier(false);
//   @override
//   void initState() {
//     super.initState();
//     controller = PageController(initialPage: widget.startingIndex);
//   }

//   void loadPreviousAndNextVideosInCahce(int index) {}

//   @override
//   Widget build(BuildContext context) {
//     // var topInsets = MediaQuery.of(context).padding;
//     var model = Provider.of<EntityWithMultipleImages>(context);

//     ChipIndicator chip = ChipIndicator(
//       currentPage: widget.startingIndex,
//       totalPages: model.mediaEntityList?.length ?? 1,
//     );

//     // If image is loaded before but a new size requested larger than the current height
//     bool newSize = ((model.loadedHeight != null && model.loadedWidth != null) &&
//         (model.loadedHeight! < (widget.imageRequestHeight ?? 0) ||
//             model.loadedWidth! < (widget.imageRequestWidth ?? 0)));

//     // If image file is null and not loaded before
//     if ((model.mediaEntityList == null && !model.isLoadedBefore) || newSize) {
//       model.loadMedia(
//         height: widget.imageRequestHeight,
//         width: widget.imageRequestWidth,
//       );
//     }

//     if (widget.selectFirst)
//       return model.mediaEntityList != null && model.mediaEntityList!.length > 0
//           ? Container(
//               height: widget.height ?? 200,
//               width: widget.width ?? double.infinity,
//               margin: widget.margin,
//               padding: widget.padding,
//               child: ClipRRect(
//                 borderRadius: widget.borderRadius ?? BorderRadius.zero,
//                 child: Image.memory(
//                   model.mediaEntityList!.first.bytes!,
//                   // width: constraint.maxWidth,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               // ),
//             )
//           : InkWell(
//               onTap: widget.onTapFunction,
//               child: widget.emptyImageAlternative ?? Container(),
//             );
//     // widget.emptyImageAlternative ?? Container();

//     return model.mediaEntityList != null && model.mediaEntityList!.length > 0
//         ? Container(
//             height: widget.height ?? 200,
//             width: widget.width ?? double.infinity,
//             child: Stack(
//               children: [
//                 PageView.builder(
//                   scrollDirection: Axis.horizontal,
//                   controller: controller,
//                   onPageChanged: chip.onPageChanged,
//                   itemBuilder: (context, index) => Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       Container(
//                         margin: widget.margin,
//                         padding: widget.padding,
//                         child: InkWell(
//                           onTap: widget.onTapFunction ??
//                               (widget.enlargeFeauture
//                                   ? () => onMediaProviderImageTap(
//                                         model,
//                                         index: index,
//                                         isLoadingCallBack: (isLoading) {
//                                           this.isLoading.value = isLoading;
//                                         },
//                                       )
//                                   : null),
//                           child: ClipRRect(
//                             borderRadius:
//                                 widget.borderRadius ?? BorderRadius.zero,
//                             child: model.mediaEntityList![index].bytes != null
//                                 ? Image.memory(
//                                     model.mediaEntityList![index].bytes!,
//                                     fit: BoxFit.cover,
//                                     // width: constraint.maxWidth,
//                                   )
//                                 : model.mediaEntityList![index].path != null
//                                     ? Image.file(
//                                         File(model
//                                             .mediaEntityList![index].path!),
//                                         // width: constraint.maxWidth,
//                                         // width: double.infinity,
//                                         fit: BoxFit.cover,
//                                       )
//                                     : widget.emptyImageAlternative ??
//                                         Container(),
//                           ),
//                         ),
//                       ),
//                       ValueListenableBuilder<bool>(
//                         valueListenable: isLoading,
//                         builder: (context, isLoading, child) => isLoading
//                             ? Positioned(
//                                 top: 0,
//                                 bottom: 0,
//                                 left: 0,
//                                 right: 0,
//                                 child: AbsorbPointer(
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(8),
//                                     child: Container(
//                                       color: AppColors.Grey400.withOpacity(0.4),
//                                       child: Center(
//                                           child: CircularProgressIndicator(
//                                         color: AppColors.Blue700,
//                                       )),
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             : Container(
//                                 height: 0,
//                                 width: 0,
//                               ),
//                       ),
//                     ],
//                   ),
//                   itemCount: model.mediaEntityList != null
//                       ? model.mediaEntityList!.length
//                       : 0,
//                 ),
//                 // if (widget.showCurrentImageIndicator)
//                 Positioned.directional(
//                   textDirection: serviceLocator<AppLanguage>().textDirection,
//                   top: widget.addTopPaddingToAnimatedChip
//                       ? (MediaQuery.viewInsetsOf(context).top / 2) +
//                           kInternalPadding
//                       : ((model.loadedHeight ?? 200) > 300
//                               ? 1.5 * kMainPadding
//                               : 0) +
//                           kMainPadding,
//                   end: kMainPadding,
//                   child: ChangeNotifierProvider.value(
//                     value: chip,
//                     child: Consumer<ChipIndicator>(
//                       builder: (context, model, _) => model.totalPages > 1
//                           ? AnimatedChipContainer(
//                               currentIndex: model.currentPage + 1,
//                               itemsCount: model.totalPages)
//                           : const SizedBox(),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             // ),
//           )
//         : InkWell(
//             onTap: widget.onTapFunction,
//             child: widget.emptyImageAlternative ?? Container(),
//           );
//   }
// }

// class _EntityWithMediaWidget extends StatefulWidget {
//   final int? imageRequestHeight;
//   final int? imageRequestWidth;
//   final double? height;
//   final double? width;
//   final EdgeInsets? padding;
//   final EdgeInsets? margin;
//   final BorderRadius? borderRadius;
//   final bool showCurrentImageIndicator;
//   final Widget? emptyImageAlternative;
//   final bool selectFirst;
//   final int startingIndex;
//   final bool enlargeFeauture;
//   final bool addTopPaddingToAnimatedChip;
//   final Function(bool)? isLoadingCallback;
//   final bool showVideoPlaybutton;
//   final VoidCallback? onTapFunction;
//   final bool addFullScreenModeBannerInVideos;
//   final bool enlargeVideoOnTappingAnyWhere;
//   final bool minimizeVideoEnlargementIcon;
//   final VideoCache? videoCache;
//   const _EntityWithMediaWidget({
//     Key? key,
//     this.height,
//     this.width,
//     this.imageRequestHeight,
//     this.imageRequestWidth,
//     this.padding,
//     this.margin,
//     this.borderRadius,
//     this.emptyImageAlternative,
//     this.isLoadingCallback,
//     this.videoCache,
//     required this.addFullScreenModeBannerInVideos,
//     required this.enlargeVideoOnTappingAnyWhere,
//     required this.minimizeVideoEnlargementIcon,
//     required this.addTopPaddingToAnimatedChip,
//     required this.enlargeFeauture,
//     required this.showVideoPlaybutton,

//     /// To show only the first item
//     this.selectFirst = false,

//     /// In image enlargement
//     this.showCurrentImageIndicator = false,

//     /// Which image to start with in page view
//     this.startingIndex = 0,
//     this.onTapFunction,
//   }) : super(key: key);

//   @override
//   State<_EntityWithMediaWidget> createState() => _EntityWithMediaWidgetState();
// }

// class _EntityWithMediaWidgetState extends State<_EntityWithMediaWidget> {
//   late PageController controller;
//   ValueNotifier<bool> isLoading = ValueNotifier(false);
//   late VideoCache videoCache;
//   @override
//   void initState() {
//     super.initState();
//     controller = PageController(initialPage: widget.startingIndex);
//     videoCache = widget.videoCache ?? serviceLocator<VideoCache>();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     // videoControllers.keys.forEach((element) {
//     //   element.dispose();
//     // });
//   }

//   // Map<VideoPlayerController, String?> videoControllers = {};

//   @override
//   Widget build(BuildContext context) {
//     // var topInsets = MediaQuery.of(context).padding;
//     var model = Provider.of<EntityWithMedia>(context);

//     // void loadPreviousAndNextVideosInCahce(int index) {

//     //   if (index < ((model.mediaEntityList?.length ?? 0) - 1)) {
//     //     var nextMediaFile = model.mediaEntityList?.values.toList()[index + 1];
//     //     if (nextMediaFile != null &&
//     //         !videoCache.fileNameIsInCache(nextMediaFile)) {
//     //       var currentVideo = VideoPlayerController.network(
//     //         TomatoEndpoints.Uploads + nextMediaFile,
//     //         httpHeaders: {
//     //           "cookie": serviceLocator<LocalStorage>().authCookie,
//     //         },
//     //       );
//     //       videoCache.put(
//     //         nextMediaFile,
//     //         currentVideo,
//     //       );
//     //     }
//     //   }

//     //   if (index > 0) {
//     //     var previousMediaFile =
//     //         model.mediaEntityList?.values.toList()[index - 1];
//     //     if (previousMediaFile != null &&
//     //         !videoCache.fileNameIsInCache(previousMediaFile))
//     //       videoCache.put(
//     //         previousMediaFile,
//     //         VideoPlayerController.network(
//     //           TomatoEndpoints.Uploads + previousMediaFile,
//     //           httpHeaders: {
//     //             "cookie": serviceLocator<LocalStorage>().authCookie,
//     //           },
//     //         ),
//     //       );
//     //     // setState(() {});
//     //   }
//     // }

//     ChipIndicator chip = ChipIndicator(
//       currentPage: widget.startingIndex,
//       totalPages: model.mediaEntityList?.length ?? 1,
//     );

//     // If image is loaded before but a new size requested larger than the current height
//     bool newSize = ((model.loadedHeight != null && model.loadedWidth != null) &&
//         (model.loadedHeight! < (widget.imageRequestHeight ?? 0) ||
//             model.loadedWidth! < (widget.imageRequestWidth ?? 0)));

//     // If image file is null and not loaded before
//     if ((model.mediaEntityList == null && !model.isLoadedBefore) || newSize) {
//       model.loadMedia(
//         height: widget.imageRequestHeight,
//         width: widget.imageRequestWidth,
//         isLoadingCallback: widget.isLoadingCallback,
//       );
//     }

//     if (model.mediaEntityList != null) {
//       model.mediaEntityList!.entries.forEach(
//         (element) {
//           if (element.value != null &&
//               !videoCache.fileNameIsInCache(element.value!)) {
//             videoCache.put(
//                 element.value!,
//                 VideoPlayerController.networkUrl(
//                   Uri.parse(TomatoEndpoints.Uploads + element.value!),
//                   httpHeaders: {
//                     "cookie": serviceLocator<LocalStorage>().authCookie,
//                   },
//                 )

//                 // VideoPlayerController.network(
//                 //   TomatoEndpoints.Uploads + element.value!,
//                 //   httpHeaders: {
//                 //     "cookie": serviceLocator<LocalStorage>().authCookie,
//                 //   },
//                 // )

//                 );
//           }
//         },
//       );

//       // if ((widget.isInView ?? false) &&
//       //     model.mediaEntityList?.values.first != null)
//       //   videoControllers.keys.first.initialize().then((value) {
//       //     videoControllers.keys.first.play();
//       //     setState(() {});
//       //   });
//     }

//     // if (model.mediaEntityList != null) {
//     //   model.mediaEntityList!.entries.forEach(
//     //     (element) {
//     //       if (element.value != null &&
//     //           !videoCache.fileNameIsInCache(element.value!)) {
//     //         BetterPlayerDataSource betterPlayerDataSource =
//     //             BetterPlayerDataSource(
//     //           BetterPlayerDataSourceType.network,
//     //           TomatoEndpoints.Uploads + element.value!,
//     //           headers: {
//     //             "cookie": serviceLocator<LocalStorage>().authCookie,
//     //           },
//     //         );

//     //         var controller = BetterPlayerController(BetterPlayerConfiguration(),
//     //             betterPlayerDataSource: betterPlayerDataSource);

//     //         videoCache.put(element.value!, controller);
//     //       }
//     //     },
//     //   );

//     //   // if ((widget.isInView ?? false) &&
//     //   //     model.mediaEntityList?.values.first != null)
//     //   //   videoControllers.keys.first.initialize().then((value) {
//     //   //     videoControllers.keys.first.play();
//     //   //     setState(() {});
//     //   //   });
//     // }

//     if (model.mediaEntityList != null) {
//       bool addedFirstVideo = false;
//       model.mediaEntityList!.entries.forEach(
//         (element) {
//           if (element.value != null && !addedFirstVideo) {
//             addedFirstVideo = true;

//             // BetterPlayerDataSource betterPlayerDataSource =
//             //     BetterPlayerDataSource(
//             //   BetterPlayerDataSourceType.network,
//             //   TomatoEndpoints.Uploads + element.value!,
//             //   headers: {
//             //     "cookie": serviceLocator<LocalStorage>().authCookie,
//             //   },
//             // );

//             // var controller = BetterPlayerController(BetterPlayerConfiguration(),
//             //     betterPlayerDataSource: betterPlayerDataSource);

//             if (!videoCache.fileNameIsInCache(element.value!))
//               videoCache.put(
//                 element.value!,
//                 VideoPlayerController.network(
//                   TomatoEndpoints.Uploads + element.value!,
//                   httpHeaders: {
//                     "cookie": serviceLocator<LocalStorage>().authCookie,
//                   },
//                 ),
//               );

//             if (chip.currentPage < ((model.mediaEntityList?.length ?? 0) - 1)) {
//               var nextMediaFile =
//                   model.mediaEntityList?.values.toList()[chip.currentPage + 1];
//               if (nextMediaFile != null &&
//                   !videoCache.fileNameIsInCache(nextMediaFile))
//                 videoCache.put(
//                   nextMediaFile,
//                   VideoPlayerController.network(
//                     TomatoEndpoints.Uploads + nextMediaFile,
//                     httpHeaders: {
//                       "cookie": serviceLocator<LocalStorage>().authCookie,
//                     },
//                   ),
//                 );
//               setState(() {});
//             }
//           }
//         },
//       );
//     }

//     if (widget.selectFirst)
//       return model.mediaEntityList != null && model.mediaEntityList!.length > 0
//           ? LayoutBuilder(
//               builder: (context, constraint) => Container(
//                 height: widget.height ?? 200,
//                 width: widget.width ?? double.infinity,
//                 margin: widget.margin,
//                 padding: widget.padding,
//                 child: ClipRRect(
//                   borderRadius: widget.borderRadius ?? BorderRadius.zero,
//                   child: model.mediaEntityList!.keys.first.path != null
//                       ? Image.file(
//                           File(model.mediaEntityList!.keys.first.path!),
//                           width: constraint.maxWidth,
//                           fit: BoxFit.cover,
//                         )
//                       : model.mediaEntityList!.keys.first.bytes != null
//                           ? Image.memory(
//                               model.mediaEntityList!.keys.first.bytes!,
//                               width: constraint.maxWidth,
//                               fit: BoxFit.cover,
//                             )
//                           : null,
//                 ),
//               ),
//             )
//           : widget.emptyImageAlternative ?? Container();

//     return model.mediaEntityList != null && model.mediaEntityList!.length > 0
//         ? LayoutBuilder(
//             builder: (context, constraint) => Container(
//               height: widget.height ?? 200,
//               width: widget.width ?? double.infinity,
//               child: Stack(
//                 children: [
//                   PageView.builder(
//                     scrollDirection: Axis.horizontal,
//                     controller: controller,
//                     onPageChanged: (index) {
//                       chip.onPageChanged(index);
//                       // loadPreviousAndNextVideosInCahce(index);
//                     },

//                     itemBuilder: (context, index) {
//                       Widget imageWidget = model.mediaEntityList!.keys
//                                   .elementAt(index)
//                                   .bytes !=
//                               null
//                           ? InkWell(
//                               onTap: widget.enlargeVideoOnTappingAnyWhere ||
//                                       (widget.enlargeFeauture &&
//                                           model.mediaEntityList!.values
//                                                   .elementAt(index) ==
//                                               null)
//                                   ? () => onMediaProviderImageTap(
//                                         model,
//                                         index: index,
//                                         videoController: videoCache
//                                             .getVideoControllersByFileNamesForImageEnalrgment(
//                                           (model.mediaEntityList?.values
//                                                   .where((e) => e != null)
//                                                   .toList()) ??
//                                               [],
//                                         ),
//                                         startWithVideoPlaying: false,
//                                         isLoadingCallBack: (isLoading) {
//                                           this.isLoading.value = isLoading;
//                                         },
//                                       )
//                                   : null,
//                               child: Image.memory(
//                                 model.mediaEntityList!.keys
//                                     .elementAt(index)
//                                     .bytes!,
//                                 fit: BoxFit.cover,
//                                 width: constraint.maxWidth,
//                                 height: widget.height,
//                               ),
//                             )
//                           : model.mediaEntityList!.keys.elementAt(index).path !=
//                                   null
//                               ? InkWell(
//                                   onTap: widget.enlargeFeauture &&
//                                           model.mediaEntityList!.values
//                                                   .elementAt(index) ==
//                                               null
//                                       ? () => onMediaProviderImageTap(
//                                             model,
//                                             index: index,
//                                             videoController: videoCache
//                                                 .getVideoControllersByFileNamesForImageEnalrgment(
//                                               (model.mediaEntityList?.values
//                                                       .where((e) => e != null)
//                                                       .toList()) ??
//                                                   [],
//                                             ),
//                                             // videoController: videoControllers,
//                                             startWithVideoPlaying: false,
//                                             isLoadingCallBack: (isLoading) {
//                                               this.isLoading.value = isLoading;
//                                             },
//                                           )
//                                       : null,
//                                   child: Image.file(
//                                     File(model.mediaEntityList!.keys
//                                         .elementAt(index)
//                                         .path!),
//                                     width: constraint.maxWidth,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 )
//                               : widget.emptyImageAlternative ?? Container();
//                       return Container(
//                         margin: widget.margin,
//                         padding: widget.padding,
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             ClipRRect(
//                               borderRadius:
//                                   widget.borderRadius ?? BorderRadius.zero,
//                               child: widget.showVideoPlaybutton &&
//                                       model.mediaEntityList!.values
//                                               .elementAt(index) !=
//                                           null
//                                   ? videoCache.fileNameIsInCache(model
//                                           .mediaEntityList!.values
//                                           .elementAt(index)!)
//                                       ? CachedVideoPreview.loadVideoDirectly(
//                                           fileName: model
//                                               .mediaEntityList!.values
//                                               .elementAt(index)!,
//                                           videoCache: videoCache,
//                                           imageAlternative: imageWidget,
//                                         )
//                                       : CachedVideoPreview.dontLoadVideo(
//                                           fileName: model
//                                               .mediaEntityList!.values
//                                               .elementAt(index)!,
//                                           videoCache: videoCache,
//                                           imageAlternative: imageWidget,
//                                         )
//                                   : imageWidget,
//                             ),
//                             ValueListenableBuilder<bool>(
//                               valueListenable: isLoading,
//                               builder: (context, isLoading, child) => isLoading
//                                   ? Positioned(
//                                       top: 0,
//                                       bottom: 0,
//                                       left: 0,
//                                       right: 0,
//                                       child: AbsorbPointer(
//                                         child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           child: Container(
//                                             color:
//                                                 AppColors.Grey400.withOpacity(
//                                                     0.4),
//                                             child: Center(
//                                               child: CircularProgressIndicator(
//                                                 color: AppColors.Green700,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                   : Container(
//                                       height: 0,
//                                       width: 0,
//                                     ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     // itemBuilder: (context, index) => Container(
//                     //   margin: widget.margin,
//                     //   padding: widget.padding,
//                     //   child: Stack(
//                     //     alignment: Alignment.center,
//                     //     children: [
//                     //       InkWell(
//                     //         onTap: widget.enlargeFeauture
//                     //             ? () => onMediaProviderImageTap(
//                     //                   model,
//                     //                   index: index,
//                     //                   videoController: videoControllers,
//                     //                   startWithVideoPlaying: false,
//                     //                   isLoadingCallBack: (isLoading) {
//                     //                     this.isLoading.value = isLoading;
//                     //                   },
//                     //                 )
//                     //             : null,
//                     //         child: ClipRRect(
//                     //           borderRadius:
//                     //               widget.borderRadius ?? BorderRadius.zero,
//                     //           child: model.mediaEntityList!.keys
//                     //                       .elementAt(index)
//                     //                       .bytes !=
//                     //                   null
//                     //               ? Image.memory(
//                     //                   model.mediaEntityList!.keys
//                     //                       .elementAt(index)
//                     //                       .bytes!,
//                     //                   fit: BoxFit.cover,
//                     //                   width: constraint.maxWidth,
//                     //                   height: widget.height,
//                     //                 )
//                     //               : model.mediaEntityList!.keys
//                     //                           .elementAt(index)
//                     //                           .path !=
//                     //                       null
//                     //                   ? Image.file(
//                     //                       File(model.mediaEntityList!.keys
//                     //                           .elementAt(index)
//                     //                           .path!),
//                     //                       width: constraint.maxWidth,
//                     //                       fit: BoxFit.cover,
//                     //                     )
//                     //                   : widget.emptyImageAlternative ??
//                     //                       Container(),
//                     //         ),
//                     //       ),
//                     //       // if (widget.showVideoPlaybutton)
//                     //       if (widget.showVideoPlaybutton &&
//                     //           model.mediaEntityList!.values.elementAt(index) !=
//                     //               null)
//                     //         InkWell(
//                     //           onTap: widget.onTapFunction ??
//                     //               () => onMediaProviderImageTap(
//                     //                     model,
//                     //                     index: index,
//                     //                     videoController: videoControllers,
//                     //                     startWithVideoPlaying: true,
//                     //                     isLoadingCallBack: (isLoading) {
//                     //                       this.isLoading.value = isLoading;
//                     //                     },
//                     //                   ),
//                     //           child: LayoutBuilder(
//                     //             builder: (context, constraint) => Container(
//                     //               height: constraint.maxWidth > 300 ? 72 : 36,
//                     //               width: constraint.maxWidth > 300 ? 72 : 36,
//                     //               child: ClipOval(
//                     //                 // borderRadius: BorderRadius.all(Radius.circular(100)),
//                     //                 child: BackdropFilter(
//                     //                   filter: ImageFilter.blur(
//                     //                       sigmaX: 10.0, sigmaY: 10.0),
//                     //                   child: Container(
//                     //                     color:
//                     //                         AppColors.White.withOpacity(0.2),
//                     //                     // padding: EdgeInsets.all(kInternalPadding),
//                     //                     child: Center(
//                     //                       child: Icon(
//                     //                         Icons.play_arrow_rounded,
//                     //                         color: AppColors.White,
//                     //                         size: constraint.maxWidth > 300
//                     //                             ? 40
//                     //                             : 30,
//                     //                       ),
//                     //                     ),
//                     //                   ),
//                     //                 ),
//                     //               ),
//                     //             ),
//                     //           ),
//                     //         ),
//                     //       ValueListenableBuilder<bool>(
//                     //         valueListenable: isLoading,
//                     //         builder: (context, isLoading, child) => isLoading
//                     //             ? Positioned(
//                     //                 top: 0,
//                     //                 bottom: 0,
//                     //                 left: 0,
//                     //                 right: 0,
//                     //                 child: AbsorbPointer(
//                     //                   child: ClipRRect(
//                     //                     borderRadius: BorderRadius.circular(8),
//                     //                     child: Container(
//                     //                       color:
//                     //                           AppColors.Grey400.withOpacity(
//                     //                               0.4),
//                     //                       child: Center(
//                     //                           child: CircularProgressIndicator(
//                     //                         color: AppColors.Blue700,
//                     //                       )),
//                     //                     ),
//                     //                   ),
//                     //                 ),
//                     //               )
//                     //             : Container(
//                     //                 height: 0,
//                     //                 width: 0,
//                     //               ),
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                     itemCount: model.mediaEntityList != null
//                         ? model.mediaEntityList!.length
//                         : 0,
//                   ),
//                   // if (widget.showCurrentImageIndicator)
//                   Positioned.directional(
//                     textDirection: serviceLocator<AppLanguage>().textDirection,
//                     top: widget.addTopPaddingToAnimatedChip
//                         ? (MediaQuery.paddingOf(context).top / 2) +
//                             kInternalPadding
//                         : ((model.loadedHeight ?? 200) > 300
//                                 ? 1.5 * kMainPadding
//                                 : 0) +
//                             kMainPadding,
//                     end: kMainPadding,
//                     child: ChangeNotifierProvider.value(
//                       value: chip,
//                       child: Consumer<ChipIndicator>(
//                         builder: (context, model, _) => model.totalPages > 1
//                             ? AnimatedChipContainer(
//                                 currentIndex: model.currentPage + 1,
//                                 itemsCount: model.totalPages,
//                               )
//                             : const SizedBox(),
//                       ),
//                     ),
//                   ),
//                   if (widget.addFullScreenModeBannerInVideos)
//                     ChangeNotifierProvider.value(
//                       value: chip,
//                       child: Consumer<ChipIndicator>(
//                         builder: (context, chip, _) => model
//                                     .mediaEntityList?.values
//                                     .toList()[chip.currentPage] ==
//                                 null
//                             ? Container()
//                             : Positioned.directional(
//                                 textDirection:
//                                     serviceLocator<AppLanguage>().textDirection,
//                                 bottom: widget.minimizeVideoEnlargementIcon
//                                     ? 4
//                                     : kMainPadding,
//                                 start: widget.minimizeVideoEnlargementIcon
//                                     ? 4
//                                     : kMainPadding,
//                                 child: InkWell(
//                                   onTap: () => onMediaProviderImageTap(
//                                     model,
//                                     index: chip.currentPage,
//                                     videoController: videoCache
//                                         .getVideoControllersByFileNamesForImageEnalrgment(
//                                       (model.mediaEntityList?.values
//                                               .where((e) => e != null)
//                                               .toList()) ??
//                                           [],
//                                     ),
//                                     startWithVideoPlaying: false,
//                                     isLoadingCallBack: (isLoading) {
//                                       this.isLoading.value = isLoading;
//                                     },
//                                   ),
//                                   // : null,
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(8),
//                                     child: BackdropFilter(
//                                       filter: ImageFilter.blur(
//                                           sigmaX: 15.0, sigmaY: 15.0),
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           color: AppColors.Grey900.withOpacity(
//                                               0.5),
//                                         ),
//                                         child: Container(
//                                           padding: const EdgeInsets.symmetric(
//                                               vertical: kInternalPadding,
//                                               horizontal: kBottomPadding),
//                                           child: Row(
//                                             children: [
//                                               SvgPicture.asset(
//                                                 'assets/vectors/enlargeScreen.svg',
//                                               ),
//                                               if (!widget
//                                                   .minimizeVideoEnlargementIcon) ...[
//                                                 SizedBox(width: 4),
//                                                 Text(
//                                                   AppLocalizations.of(context)
//                                                       .fullScreen
//                                                       .capitalizeAllWord(),
//                                                   style: TomatoTextStyles
//                                                       .InterWhiteS14W500H18,
//                                                 ),
//                                               ],
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           )
//         : widget.emptyImageAlternative ?? Container();
//   }
// }

// // class NewsFeedMediaProvider extends StatelessWidget {
// //   const NewsFeedMediaProvider({
// //     this.height,
// //     this.width,
// //     this.imageRequestHeight,
// //     this.imageRequestWidth,
// //     this.startingIndex = 0,
// //     this.padding,
// //     this.margin,
// //     this.borderRadius,
// //     this.emptyImageAlternative,
// //     required this.model,
// //     this.selectFirst = false,
// //     this.showCurrentImageIndicator = false,
// //     this.enlargeFeauture = true,
// //     this.isLoadingCallback,
// //     super.key,
// //   });

// //   final int? imageRequestHeight;
// //   final int? imageRequestWidth;
// //   final double? height;
// //   final double? width;
// //   final EdgeInsets? padding;
// //   final EdgeInsets? margin;
// //   final BorderRadius? borderRadius;
// //   final bool showCurrentImageIndicator;
// //   final dynamic model;
// //   final Widget? emptyImageAlternative;
// //   final bool selectFirst;
// //   final int startingIndex;
// //   final bool enlargeFeauture;
// //   final Function(bool)? isLoadingCallback;

// //   @override
// //   Widget build(BuildContext context) {
// //     if (model is EntityWithMedia)
// //       return ChangeNotifierProvider.value(
// //         value: model as EntityWithMedia,
// //         child: _NewsFeedEntityWithMedia(
// //           height: this.height,
// //           width: this.width,
// //           addTopPaddingToAnimatedChip: true,
// //           showVideoPlaybutton: true,
// //           imageRequestHeight: this.imageRequestHeight,
// //           imageRequestWidth: this.imageRequestWidth,
// //           padding: this.padding,
// //           margin: this.margin,
// //           borderRadius: this.borderRadius,
// //           emptyImageAlternative: this.emptyImageAlternative,
// //           selectFirst: this.selectFirst,
// //           showCurrentImageIndicator: this.showCurrentImageIndicator,
// //           startingIndex: this.startingIndex,
// //           enlargeFeauture: this.enlargeFeauture,
// //           isLoadingCallback: this.isLoadingCallback,
// //         ),
// //       );
// //     return Container();
// //   }
// // }

// // class _NewsFeedEntityWithMedia extends StatefulWidget {
// //   final int? imageRequestHeight;
// //   final int? imageRequestWidth;
// //   final double? height;
// //   final double? width;
// //   final EdgeInsets? padding;
// //   final EdgeInsets? margin;
// //   final BorderRadius? borderRadius;
// //   final bool showCurrentImageIndicator;
// //   final Widget? emptyImageAlternative;
// //   final bool selectFirst;
// //   final int startingIndex;
// //   final bool enlargeFeauture;
// //   final bool addTopPaddingToAnimatedChip;
// //   final Function(bool)? isLoadingCallback;
// //   final bool showVideoPlaybutton;
// //   // final VoidCallback? onTapFunction;

// //   const _NewsFeedEntityWithMedia({
// //     Key? key,
// //     this.height,
// //     this.width,
// //     this.imageRequestHeight,
// //     this.imageRequestWidth,
// //     this.padding,
// //     this.margin,
// //     this.borderRadius,
// //     this.emptyImageAlternative,
// //     this.isLoadingCallback,
// //     required this.addTopPaddingToAnimatedChip,
// //     required this.enlargeFeauture,
// //     required this.showVideoPlaybutton,

// //     /// To show only the first item
// //     this.selectFirst = false,

// //     /// In image enlargement
// //     this.showCurrentImageIndicator = false,

// //     /// Which image to start with in page view
// //     this.startingIndex = 0,
// //   });

// //   @override
// //   State<_NewsFeedEntityWithMedia> createState() =>
// //       __NewsFeedEntityWithMediaState();
// // }

// // class __NewsFeedEntityWithMediaState extends State<_NewsFeedEntityWithMedia> {
// //   late PageController controller;
// //   ValueNotifier<bool> isLoading = ValueNotifier(false);
// //   @override
// //   void initState() {
// //     super.initState();
// //     controller = PageController(initialPage: widget.startingIndex);
// //   }
// //   @override
// //   void dispose() {
// //     super.dispose();
// //     // videoControllers.keys.forEach((element) {
// //     //   element.dispose();
// //     // });
// //   }
// //   // Map<VideoPlayerController, String?> videoControllers = {};
// //   @override
// //   Widget build(BuildContext context) {
// //     final videoCache = Provider.of<HomeScreenVM>(context).videoCache;

// //     // debugPrint('Heikal - this media provider is in view ${widget.isInView}');
// //     // var topInsets = MediaQuery.of(context).padding;
// //     var model = Provider.of<EntityWithMedia>(context);

// //     void loadPreviousAndNextVideosInCahce(int index) {
// //       if (index < ((model.mediaEntityList?.length ?? 0) - 1)) {
// //         var nextMediaFile = model.mediaEntityList?.values.toList()[index + 1];
// //         if (nextMediaFile != null &&
// //             !videoCache.fileNameIsInCache(nextMediaFile))
// //           videoCache.put(
// //             nextMediaFile,
// //             VideoPlayerController.network(
// //               TomatoEndpoints.Uploads + nextMediaFile,
// //               httpHeaders: {
// //                 "cookie": serviceLocator<LocalStorage>().authCookie,
// //               },
// //             ),
// //           );
// //       }
// //       if (index > 0) {
// //         var previousMediaFile =
// //             model.mediaEntityList?.values.toList()[index - 1];
// //         if (previousMediaFile != null &&
// //             !videoCache.fileNameIsInCache(previousMediaFile))
// //           videoCache.put(
// //             previousMediaFile,
// //             VideoPlayerController.network(
// //               TomatoEndpoints.Uploads + previousMediaFile,
// //               httpHeaders: {
// //                 "cookie": serviceLocator<LocalStorage>().authCookie,
// //               },
// //             ),
// //           );
// //         // setState(() {});
// //       }
// //     }

// //     ChipIndicator chip = ChipIndicator(
// //       currentPage: widget.startingIndex,
// //       totalPages: model.mediaEntityList?.length ?? 1,
// //     );

// //     // If image is loaded before but a new size requested larger than the current height
// //     bool newSize = ((model.loadedHeight != null && model.loadedWidth != null) &&
// //         (model.loadedHeight! < (widget.imageRequestHeight ?? 0) ||
// //             model.loadedWidth! < (widget.imageRequestWidth ?? 0)));

// //     // If image file is null and not loaded before
// //     if ((model.mediaEntityList == null && !model.isLoadedBefore) || newSize) {
// //       model.loadMedia(
// //         height: widget.imageRequestHeight,
// //         width: widget.imageRequestWidth,
// //         isLoadingCallback: widget.isLoadingCallback,
// //       );
// //     }

// //     if (model.mediaEntityList != null) {
// //       bool addedFirstVideo = false;
// //       model.mediaEntityList!.entries.forEach(
// //         (element) {
// //           if (element.value != null && !addedFirstVideo) {
// //             addedFirstVideo = true;

// //             if (!videoCache.fileNameIsInCache(element.value!))
// //               videoCache.put(
// //                 element.value!,
// //                 VideoPlayerController.network(
// //                   TomatoEndpoints.Uploads + element.value!,
// //                   httpHeaders: {
// //                     "cookie": serviceLocator<LocalStorage>().authCookie,
// //                   },
// //                 ),
// //               );

// //             if (chip.currentPage < ((model.mediaEntityList?.length ?? 0) - 1)) {
// //               var nextMediaFile =
// //                   model.mediaEntityList?.values.toList()[chip.currentPage + 1];
// //               if (nextMediaFile != null &&
// //                   !videoCache.fileNameIsInCache(nextMediaFile))
// //                 videoCache.put(
// //                   nextMediaFile,
// //                   VideoPlayerController.network(
// //                     TomatoEndpoints.Uploads + nextMediaFile,
// //                     httpHeaders: {
// //                       "cookie": serviceLocator<LocalStorage>().authCookie,
// //                     },
// //                   ),
// //                 );
// //               setState(() {});
// //             }
// //           }
// //         },
// //       );
// //     }
// //     return model.mediaEntityList != null && model.mediaEntityList!.length > 0
// //         ? LayoutBuilder(
// //             builder: (context, constraint) => Container(
// //               height: widget.height ?? 200,
// //               width: widget.width ?? double.infinity,
// //               child: Stack(
// //                 children: [
// //                   PageView.builder(
// //                     scrollDirection: Axis.horizontal,
// //                     controller: controller,
// //                     onPageChanged: (index) {
// //                       loadPreviousAndNextVideosInCahce(index);
// //                       chip.onPageChanged(index);
// //                     },
// //                     itemBuilder: (context, index) {
// //                       Widget imageWidget = model.mediaEntityList!.keys
// //                                   .elementAt(index)
// //                                   .bytes !=
// //                               null
// //                           ? Image.memory(
// //                               model.mediaEntityList!.keys
// //                                   .elementAt(index)
// //                                   .bytes!,
// //                               fit: BoxFit.cover,
// //                               width: constraint.maxWidth,
// //                               height: widget.height,
// //                             )
// //                           : model.mediaEntityList!.keys.elementAt(index).path !=
// //                                   null
// //                               ? Image.file(
// //                                   File(model.mediaEntityList!.keys
// //                                       .elementAt(index)
// //                                       .path!),
// //                                   width: constraint.maxWidth,
// //                                   fit: BoxFit.cover,
// //                                 )
// //                               : widget.emptyImageAlternative ?? Container();

// //                       return Container(
// //                         margin: widget.margin,
// //                         padding: widget.padding,
// //                         child: Stack(
// //                           alignment: Alignment.center,
// //                           children: [
// //                             ClipRRect(
// //                               borderRadius:
// //                                   widget.borderRadius ?? BorderRadius.zero,
// //                               child: model.mediaEntityList!.values
// //                                           .elementAt(index) !=
// //                                       null
// //                                   ? videoCache.fileNameIsInCache(model
// //                                           .mediaEntityList!.values
// //                                           .elementAt(index)!)
// //                                       ? CachedVideoPreview.loadVideoDirectly(
// //                                           fileName: model
// //                                               .mediaEntityList!.values
// //                                               .elementAt(index)!,
// //                                           videoCache: videoCache,
// //                                           imageAlternative: imageWidget,
// //                                         )
// //                                       : CachedVideoPreview.dontLoadVideo(
// //                                           fileName: model
// //                                               .mediaEntityList!.values
// //                                               .elementAt(index)!,
// //                                           videoCache: videoCache,
// //                                           imageAlternative: imageWidget,
// //                                         )
// //                                   : InkWell(
// //                                       onTap: () => onMediaProviderImageTap(
// //                                             model,
// //                                             index: chip.currentPage,
// //                                             isLoadingCallBack: (isLoading) {
// //                                               this.isLoading.value = isLoading;
// //                                             },
// //                                             videoController: videoCache
// //                                                 .getVideoControllersByFileNamesForImageEnalrgment(
// //                                               model.mediaEntityList?.values
// //                                                   .where((e) => e != null)
// //                                                   .toList(),
// //                                             ),
// //                                           ),
// //                                       child: imageWidget),
// //                             ),
// //                             ValueListenableBuilder<bool>(
// //                               valueListenable: isLoading,
// //                               builder: (context, isLoading, child) => isLoading
// //                                   ? Positioned(
// //                                       top: 0,
// //                                       bottom: 0,
// //                                       left: 0,
// //                                       right: 0,
// //                                       child: AbsorbPointer(
// //                                         child: ClipRRect(
// //                                           borderRadius:
// //                                               BorderRadius.circular(8),
// //                                           child: Container(
// //                                             color: AppColors.Grey400
// //                                                 .withOpacity(0.4),
// //                                             child: Center(
// //                                               child: CircularProgressIndicator(
// //                                                 color: AppColors.Green700,
// //                                               ),
// //                                             ),
// //                                           ),
// //                                         ),
// //                                       ),
// //                                     )
// //                                   : Container(
// //                                       height: 0,
// //                                       width: 0,
// //                                     ),
// //                             ),
// //                           ],
// //                         ),
// //                       );
// //                     },
// //                     itemCount: model.mediaEntityList != null
// //                         ? model.mediaEntityList!.length
// //                         : 0,
// //                   ),
// //                   // if (widget.showCurrentImageIndicator)
// //                   Positioned(
// //                     top: widget.addTopPaddingToAnimatedChip
// //                         ? (MediaQuery.of(context).padding.top / 2) +
// //                             (Platform.isIOS ? kInternalPadding : 0)
// //                         : ((model.loadedHeight ?? 200) > 300
// //                                 ? 1.5 * kMainPadding
// //                                 : 0) +
// //                             kMainPadding,
// //                     right: kMainPadding,
// //                     child: ChangeNotifierProvider.value(
// //                       value: chip,
// //                       child: Consumer<ChipIndicator>(
// //                         builder: (context, model, _) => model.totalPages > 1
// //                             ? AnimatedChipContainer(
// //                                 currentIndex: model.currentPage + 1,
// //                                 itemsCount: model.totalPages,
// //                               )
// //                             : const SizedBox(),
// //                       ),
// //                     ),
// //                   ),

// //                   ChangeNotifierProvider.value(
// //                     value: chip,
// //                     child: Consumer<ChipIndicator>(
// //                       builder: (context, chip, _) => model
// //                                   .mediaEntityList?.values
// //                                   .toList()[chip.currentPage] ==
// //                               null
// //                           ? Container()
// //                           : Positioned(
// //                               bottom: kHelpingPadding,
// //                               left: kMainPadding,
// //                               child: InkWell(
// //                                 onTap: /* widget.enlargeFeauture &&
// //                                           model.mediaEntityList!.values
// //                                                   .elementAt(index) ==
// //                                               null
// //                                       ? */
// //                                     () => onMediaProviderImageTap(
// //                                   model,
// //                                   index: chip.currentPage,
// //                                   videoController: videoCache
// //                                       .getVideoControllersByFileNamesForImageEnalrgment(
// //                                     model.mediaEntityList?.values
// //                                         .where((e) => e != null)
// //                                         .toList(),
// //                                   ),
// //                                   // videoController: videoControllers,
// //                                   startWithVideoPlaying: false,
// //                                   isLoadingCallBack: (isLoading) {
// //                                     this.isLoading.value = isLoading;
// //                                   },
// //                                 ),
// //                                 // : null,
// //                                 child: ClipRRect(
// //                                   borderRadius: BorderRadius.circular(8),
// //                                   child: BackdropFilter(
// //                                     filter: ImageFilter.blur(
// //                                         sigmaX: 15.0, sigmaY: 15.0),
// //                                     child: Container(
// //                                         decoration: BoxDecoration(
// //                                           color:
// //                                               AppColors.Grey900.withOpacity(
// //                                                   0.5),
// //                                         ),
// //                                         child: Container(
// //                                           padding: const EdgeInsets.symmetric(
// //                                               vertical: kInternalPadding,
// //                                               horizontal: kBottomPadding),
// //                                           child: Row(
// //                                             children: [
// //                                               SvgPicture.asset(
// //                                                 'assets/vectors/enlargeScreen.svg',
// //                                               ),
// //                                               SizedBox(width: 4),
// //                                               Text(
// //                                                 AppLocalizations.of(context)
// //                                                     .fullScreen
// //                                                     .capitalizeAllWord(),
// //                                                 // 'Full Screen',
// //                                                 style: TomatoTextStyles
// //                                                     .InterWhiteS14W500H18,
// //                                               )
// //                                             ],
// //                                           ),
// //                                         )),
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                     ),
// //                   ),
// //                   // if (widget.isInView ?? false) Text('True'),
// //                 ],
// //               ),
// //             ),
// //           )
// //         : widget.emptyImageAlternative ?? Container();
// //   }
// // }

// class ChipIndicator extends ChangeNotifier {
//   int currentPage;
//   int totalPages;
//   ChipIndicator({required this.currentPage, required this.totalPages});

//   onPageChanged(int value) {
//     currentPage = value;
//     notifyListeners();
//   }
// }

// class MediaProviderCarousel extends StatelessWidget {
//   const MediaProviderCarousel({
//     this.height,
//     this.width,
//     this.imageRequestHeight,
//     this.imageRequestWidth,
//     this.startingIndex = 0,
//     this.padding,
//     this.margin,
//     this.borderRadius,
//     this.emptyImageAlternative,
//     required this.model,
//     this.selectFirst = false,
//     this.showCurrentImageIndicator = false,
//     this.enlargeFeauture = true,
//     super.key,
//   });

//   final int? imageRequestHeight;
//   final int? imageRequestWidth;
//   final double? height;
//   final double? width;
//   final EdgeInsets? padding;
//   final EdgeInsets? margin;
//   final BorderRadius? borderRadius;
//   final bool showCurrentImageIndicator;
//   final dynamic model;
//   final Widget? emptyImageAlternative;
//   final bool selectFirst;
//   final int startingIndex;
//   final bool enlargeFeauture;

//   @override
//   Widget build(BuildContext context) {
//     if (model is EntityWithMedia)
//       return ChangeNotifierProvider.value(
//         value: model as EntityWithMedia,
//         child: _EntityWithMediaCarouselWidget(
//           height: this.height,
//           width: this.width,
//           imageRequestHeight: this.imageRequestHeight,
//           imageRequestWidth: this.imageRequestWidth,
//           padding: this.padding,
//           margin: this.margin,
//           borderRadius: this.borderRadius,
//           emptyImageAlternative: this.emptyImageAlternative,
//           selectFirst: this.selectFirst,
//           showCurrentImageIndicator: this.showCurrentImageIndicator,
//           startingIndex: this.startingIndex,
//           enlargeFeauture: this.enlargeFeauture,
//         ),
//       );
//     return Container();
//   }
// }

// class _EntityWithMediaCarouselWidget extends StatefulWidget {
//   final int? imageRequestHeight;
//   final int? imageRequestWidth;
//   final double? height;
//   final double? width;
//   final EdgeInsets? padding;
//   final EdgeInsets? margin;
//   final BorderRadius? borderRadius;
//   final bool showCurrentImageIndicator;
//   final Widget? emptyImageAlternative;
//   final bool selectFirst;
//   final int startingIndex;
//   final bool enlargeFeauture;

//   const _EntityWithMediaCarouselWidget({
//     Key? key,
//     this.height,
//     this.width,
//     this.imageRequestHeight,
//     this.imageRequestWidth,
//     this.padding,
//     this.margin,
//     this.borderRadius,
//     this.emptyImageAlternative,
//     required this.enlargeFeauture,

//     /// To show only the first item
//     this.selectFirst = false,

//     /// In image enlargement
//     this.showCurrentImageIndicator = false,

//     /// Which image to start with in page view
//     this.startingIndex = 0,
//   }) : super(key: key);

//   @override
//   State<_EntityWithMediaCarouselWidget> createState() =>
//       _EntityWithMediaCarouselWidgetState();
// }

// class _EntityWithMediaCarouselWidgetState
//     extends State<_EntityWithMediaCarouselWidget> {
//   late PageController controller;
//   ValueNotifier<bool> isLoading = ValueNotifier(false);

//   @override
//   void initState() {
//     super.initState();
//     controller = PageController(initialPage: widget.startingIndex);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     videoControllers.keys.forEach((element) {
//       element.dispose();
//     });
//   }

//   Map<VideoPlayerController, String?> videoControllers = {};

//   @override
//   Widget build(BuildContext context) {
//     // var topInsets = MediaQuery.of(context).padding;
//     var model = Provider.of<EntityWithMedia>(context);

//     // ChipIndicator chip = ChipIndicator(
//     //   currentPage: widget.startingIndex,
//     //   totalPages: model.mediaEntityList?.length ?? 1,
//     // );

//     // If image is loaded before but a new size requested larger than the current height
//     bool newSize = ((model.loadedHeight != null && model.loadedWidth != null) &&
//         (model.loadedHeight! < (widget.imageRequestHeight ?? 0) ||
//             model.loadedWidth! < (widget.imageRequestWidth ?? 0)));

//     // If image file is null and not loaded before
//     if ((model.mediaEntityList == null && !model.isLoadedBefore) || newSize) {
//       model.loadMedia(
//           height: widget.imageRequestHeight, width: widget.imageRequestWidth);
//     }

//     if (model.mediaEntityList != null) {
//       model.mediaEntityList!.entries.forEach((element) {
//         if (element.value != null) {
//           videoControllers.addAll({
//             VideoPlayerController.network(
//                 TomatoEndpoints.Uploads + element.value!,

//                 // 'https://mrtomato-qa2.dev.trustsourcing.com/uploads/${element.value}',
//                 httpHeaders: {
//                   "cookie": serviceLocator<LocalStorage>().authCookie
//                 }): element.value
//           });
//         }
//       });
//     }

//     // if (widget.selectFirst)
//     //   return model.mediaEntityList != null && model.mediaEntityList!.length > 0
//     //       ? LayoutBuilder(
//     //           builder: (context, constraint) => Container(
//     //             height: widget.height ?? 200,
//     //             width: constraint.maxWidth,
//     //             margin: widget.margin,
//     //             padding: widget.padding,
//     //             child: ClipRRect(
//     //               borderRadius: widget.borderRadius ?? BorderRadius.zero,
//     //               child: Image.memory(
//     //                 model.mediaEntityList!.keys.first.bytes!,
//     //                 width: constraint.maxWidth,
//     //                 fit: BoxFit.cover,
//     //               ),
//     //             ),
//     //           ),
//     //         )
//     //       : widget.emptyImageAlternative ?? Container();

//     return model.mediaEntityList != null && model.mediaEntityList!.length > 0
//         ? LayoutBuilder(
//             builder: (context, constraint) => Container(
//               height: widget.height,
//               width: double.infinity,
//               child: Stack(
//                 children: [
//                   ListView.separated(
//                     physics: ClampingScrollPhysics(),
//                     scrollDirection: Axis.horizontal,
//                     padding: widget.padding,
//                     controller: controller,
//                     separatorBuilder: (context, index) => SizedBox(
//                       width: kHelpingPadding,
//                     ),
//                     itemBuilder: (context, index) => Container(
//                       margin: widget.margin,
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           InkWell(
//                             onTap: widget.enlargeFeauture
//                                 ? () => onMediaProviderImageTap(
//                                       model,
//                                       index: index,
//                                       videoController: videoControllers,
//                                       startWithVideoPlaying: false,
//                                       isLoadingCallBack: (isLoading) {
//                                         this.isLoading.value = isLoading;
//                                       },
//                                     )
//                                 : null,
//                             child: ClipRRect(
//                               borderRadius: widget.borderRadius ??
//                                   BorderRadius.circular(10),
//                               child: model.mediaEntityList!.keys
//                                           .elementAt(index)
//                                           .bytes !=
//                                       null
//                                   ? Image.memory(
//                                       model.mediaEntityList!.keys
//                                           .elementAt(index)
//                                           .bytes!,
//                                       fit: BoxFit.cover,
//                                       width: widget.width,
//                                       height: widget.height,
//                                     )
//                                   : model.mediaEntityList!.keys
//                                               .elementAt(index)
//                                               .path !=
//                                           null
//                                       ? Image.file(
//                                           File(model.mediaEntityList!.keys
//                                               .elementAt(index)
//                                               .path!),
//                                           width: widget.width,
//                                           height: widget.height,
//                                           fit: BoxFit.cover,
//                                         )
//                                       : widget.emptyImageAlternative ??
//                                           Container(),
//                             ),
//                           ),
//                           if (model.mediaEntityList!.values.elementAt(index) !=
//                               null)
//                             InkWell(
//                               onTap: () => onMediaProviderImageTap(
//                                 model,
//                                 index: index,
//                                 videoController: videoControllers,
//                                 startWithVideoPlaying: true,
//                                 isLoadingCallBack: (isLoading) {
//                                   this.isLoading.value = isLoading;
//                                 },
//                               ),
//                               child: LayoutBuilder(
//                                 builder: (context, constraint) => Container(
//                                   height: widget.width! > 300 ? 72 : 36,
//                                   width: widget.width! > 300 ? 72 : 36,
//                                   child: ClipOval(
//                                     // borderRadius: BorderRadius.all(Radius.circular(100)),
//                                     child: BackdropFilter(
//                                       filter: ImageFilter.blur(
//                                           sigmaX: 10.0, sigmaY: 10.0),
//                                       child: Container(
//                                         color: AppColors.white.withOpacity(0.2),
//                                         // padding: EdgeInsets.all(kInternalPadding),
//                                         child: Center(
//                                           child: Icon(
//                                             Icons.play_arrow_rounded,
//                                             color: AppColors.white,
//                                             size: constraint.maxWidth > 300
//                                                 ? 40
//                                                 : 30,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             )
//                         ],
//                       ),
//                     ),
//                     itemCount: model.mediaEntityList != null
//                         ? model.mediaEntityList!.length
//                         : 0,
//                   ),
//                   // if (widget.showCurrentImageIndicator)
//                 ],
//               ),
//             ),
//           )
//         : widget.emptyImageAlternative ?? Container();
//   }
// }
