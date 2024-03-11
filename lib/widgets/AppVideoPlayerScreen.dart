import 'dart:async';
import 'dart:io';

// import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:video_player/video_player.dart';
// import 'dart:math' as Math;

class AppVideoPlayerScreen extends StatefulWidget {
  final AppVideoPlayerScreenVM model;
  const AppVideoPlayerScreen({super.key, required this.model});

  @override
  State<AppVideoPlayerScreen> createState() => _AppVideoPlayerScreenState();
}

class _AppVideoPlayerScreenState extends State<AppVideoPlayerScreen> {
  late VideoPlayerController controller;
  bool wasControllerPlayingBeforeSlidingScroll = false;
  Duration currentVideoPosition = Duration.zero;
  double currentVideoSliderValue = 0;
  Duration totalVideoDuration = Duration.zero;
  Timer? _debounce;
  var videoPlayerListener;

  @override
  void initState() {
    super.initState();
    videoPlayerListener = () {
      if (mounted) {
        setState(() {
          currentVideoPosition = controller.value.position;
          currentVideoSliderValue = (currentVideoPosition.inMilliseconds /
                  totalVideoDuration.inMilliseconds) *
              100;
        });
      }
    };

    if (!widget.model.controller.value.isInitialized) {
      controller = widget.model.controller
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              totalVideoDuration = controller.value.duration;
              if (widget.model.startVideoWithPlaying) controller.play();
            });
          }
        });
    } else {
      controller = widget.model.controller;
      if (mounted) {
        setState(() {
          totalVideoDuration = controller.value.duration;
          currentVideoPosition = controller.value.position;
          currentVideoSliderValue = (currentVideoPosition.inMilliseconds /
                  totalVideoDuration.inMilliseconds) *
              100;
          if (widget.model.startVideoWithPlaying) controller.play();
        });
      }
    }

    controller.addListener(() {
      videoPlayerListener();
    });
  }

  // Restart the controller before dispose
  @override
  void dispose() {
    controller.removeListener(() {
      videoPlayerListener();
    });
    if (controller.value.isPlaying) controller.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          if (controller.value.isPlaying) {
            controller.pause();
          } else {
            controller.play();
          }
        });
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            alignment: Alignment.center,
            color: Colors.transparent,
            child: currentVideoPosition == Duration.zero &&
                    widget.model.file != null
                ? widget.model.file!.bytes != null
                    ? Image.memory(
                        widget.model.file!.bytes!,
                        fit: BoxFit.fitWidth,
                        scale: 0.9,
                      )
                    : Image.file(
                        File(widget.model.file!.path!),
                        fit: BoxFit.fitWidth,
                        scale: 0.9,
                      )
                : controller.value.isInitialized
                    ? Center(
                        child: AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: VideoPlayer(controller),
                        ),
                      )
                    : const SizedBox(),
          ),
          if (!controller.value.isInitialized)
            const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary700,
              ),
            ),
          Positioned(
            bottom: 23,
            child: InkWell(
              onTap: () {
                setState(() {
                  if (controller.value.isPlaying) {
                    controller.pause();
                    wasControllerPlayingBeforeSlidingScroll = false;
                  } else {
                    controller.play();
                    wasControllerPlayingBeforeSlidingScroll = true;
                  }
                });
              },

              // child: Icon(
              //   controller.value.isPlaying
              //       ? Icons.pause
              //       : Icons.play_arrow_rounded,
              //   color: Colors.white,
              //   size: 40,
              // ),
              child: SvgPicture.asset(controller.value.isPlaying
                  ? "assets/vectors/pause.svg"
                  : "assets/vectors/play.svg"),
            ),
          ),
          Positioned(
            bottom: 42,
            right: 6,
            left: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                  // width: 400,
                  child: SliderTheme(
                    data: const SliderThemeData(
                      thumbColor: Colors.green,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 5,
                        pressedElevation: 12,
                      ),
                      trackHeight: 6,
                    ),
                    child: Slider(
                      min: 0,
                      max: 100,
                      activeColor: AppColors.white,
                      inactiveColor: AppColors.white.withOpacity(0.5),
                      value: currentVideoSliderValue >= 0 &&
                              currentVideoSliderValue <= 100
                          ? currentVideoSliderValue
                          : 0,
                      onChangeEnd: (value) {
                        var secondsTarget = value *
                            (totalVideoDuration.inMilliseconds / 100000);

                        var tappedPosition = Duration(
                          seconds: secondsTarget.toInt(),
                          milliseconds:
                              ((secondsTarget - (secondsTarget).truncate()) *
                                      1000)
                                  .toInt(),
                        );

                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce = Timer(const Duration(milliseconds: 30), () {
                          controller.seekTo(tappedPosition);
                          if (!controller.value.isPlaying &&
                              wasControllerPlayingBeforeSlidingScroll) {
                            controller.play();
                          }
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          currentVideoSliderValue = value;
                          if (controller.value.isPlaying) {
                            wasControllerPlayingBeforeSlidingScroll =
                                controller.value.isPlaying;
                            controller.pause();
                          }
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Text(
                        AppUtility.getvideoDurationFromDuration(
                            currentVideoPosition),
                        style: TextStyles.InterWhiteS12W400,
                      ),
                      const Spacer(),
                      Text(
                        AppUtility.getvideoDurationFromDuration(
                            totalVideoDuration),
                        style: TextStyles.InterWhiteS12W400,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomSlider extends StatelessWidget {
  double totalWidth = 200.0;
  double percentage;
  Color positiveColor;
  Color negetiveColor;

  CustomSlider(
      {super.key, required this.percentage,
      required this.positiveColor,
      required this.negetiveColor});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print((percentage / 100) * totalWidth);
    }
    if (kDebugMode) {
      print((1 - percentage / 100) * totalWidth);
    }
    return Container(
      width: totalWidth + 4.0,
      height: 30.0,
      decoration: BoxDecoration(
          color: negetiveColor,
          border: Border.all(color: Colors.black, width: 2.0)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            color: positiveColor,
            width: (percentage / 100) * totalWidth,
          ),
        ],
      ),
    );
  }
}

class AppVideoPlayerScreenVM {
  // final String videoLink;
  final VideoPlayerController controller;
  final bool startVideoWithPlaying;
  final PlatformFile? file;
  const AppVideoPlayerScreenVM({
    required this.controller,
    this.startVideoWithPlaying = false,
    this.file,
  });
}

// Custom Gesture Recognizer.
// rejectGesture() is overridden. When a gesture is rejected, this is the function that is called. By default, it disposes of the
// Recognizer and runs clean up. However we modified it so that instead the Recognizer is disposed of, it is actually manually added.
// The result is instead you have one Recognizer winning the Arena, you have two. It is a win-win.
class AllowMultipleGestureRecognizer extends HorizontalDragGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
