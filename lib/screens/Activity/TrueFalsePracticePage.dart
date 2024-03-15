import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Activity/TrueFalsePracticePageVM.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class TrueFalsePracticePage extends StatefulWidget {
  const TrueFalsePracticePage({
    required this.model,
    super.key,
  });

  final TrueFalsePracticePageVM model;

  @override
  State<TrueFalsePracticePage> createState() => _TrueFalsePracticePageState();
}

class _TrueFalsePracticePageState extends State<TrueFalsePracticePage> {
  @override
  void initState() {
    super.initState();

    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final size = MediaQuery.sizeOf(context);
          widget.model.setScreenSize(size);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.model,
      child: Container(
        height: 700,
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // if (widget.model.isInNewsFeed) ...[

              Align(
                child: widget.model.getQuestionHeader(),
              ),
              const SizedBox(height: kBottomPadding),

              SizedBox(
                height: 343,
                // width: 343,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Container(
                    //   constraints: const BoxConstraints(minHeight: 375),
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(50),
                    //     child: Stack(
                    //       fit: StackFit.expand,
                    //       children: [
                    //         // Consumer<TrueFalsePracticePageVM>(
                    //         //   builder: (context, model, child) => model
                    //         //               .selectedValue ==
                    //         //           null
                    //         //       ? Container()
                    //         //       : Container(
                    //         //           height: 343,
                    //         //           decoration: BoxDecoration(
                    //         //             // color: model.selectedValue
                    //         //             //     ? TomatoColors.Green50
                    //         //             //     : TomatoColors.Red50,
                    //         //             borderRadius: BorderRadius.circular(50),
                    //         //           ),
                    //         //           margin: const EdgeInsets.symmetric(
                    //         //               horizontal: kMainPadding),
                    //         //           child: Stack(
                    //         //             alignment: Alignment.center,
                    //         //             children: [
                    //         //               Positioned.fill(
                    //         //                 child: ClipRRect(
                    //         //                   borderRadius:
                    //         //                       BorderRadius.circular(50),
                    //         //                   child: DefaultContainer(
                    //         //                     height: 220,
                    //         //                     width: double.infinity,
                    //         //                     child: PhotoView(
                    //         //                       disableGestures: true,
                    //         //                       imageProvider: NetworkImage(
                    //         //                         model.currentTask
                    //         //                                 .downloadUrl ??
                    //         //                             "",
                    //         //                         scale: 1,
                    //         //                       ),
                    //         //                       loadingBuilder:
                    //         //                           (context, event) {
                    //         //                         final expectedBytes = event
                    //         //                             ?.expectedTotalBytes;
                    //         //                         final loadedBytes = event
                    //         //                             ?.cumulativeBytesLoaded;
                    //         //                         final value =
                    //         //                             loadedBytes != null &&
                    //         //                                     expectedBytes !=
                    //         //                                         null
                    //         //                                 ? loadedBytes /
                    //         //                                     expectedBytes
                    //         //                                 : null;

                    //         //                         return Center(
                    //         //                           child: SizedBox(
                    //         //                             width: 20.0,
                    //         //                             height: 20.0,
                    //         //                             child:
                    //         //                                 CircularProgressIndicator(
                    //         //                               value: value,
                    //         //                               color: AppColors
                    //         //                                   .primary700,
                    //         //                             ),
                    //         //                           ),
                    //         //                         );
                    //         //                       },
                    //         //                       initialScale:
                    //         //                           PhotoViewComputedScale
                    //         //                               .contained,
                    //         //                     ),
                    //         //                   ),
                    //         //                 ),
                    //         //               ),
                    //         //               ClipRRect(
                    //         //                 borderRadius:
                    //         //                     BorderRadius.circular(50),
                    //         //                 child: Container(
                    //         //                   color: AppColors.black
                    //         //                       .withOpacity(0.6),
                    //         //                   height: double.infinity,
                    //         //                   width: double.infinity,
                    //         //                 ),
                    //         //               ),
                    //         //               Column(
                    //         //                 crossAxisAlignment:
                    //         //                     CrossAxisAlignment.center,
                    //         //                 children: [
                    //         //                   const SizedBox(
                    //         //                       height: kBottomPadding),
                    //         //                   model.selectedValue
                    //         //                       ? Image.asset(
                    //         //                           'assets/loaders/loader.gif',
                    //         //                           height: 220,
                    //         //                         )
                    //         //                       : Image.asset(
                    //         //                           'assets/loaders/Sad.gif',
                    //         //                           height: 220,
                    //         //                         ),
                    //         //                   // Spacer(),
                    //         //                   // if (!widget.model.isInNewsFeed) ...[
                    //         //                   const SizedBox(height: 10),
                    //         //                   // Flexible(
                    //         //                   //   child: Container(
                    //         //                   //     padding:
                    //         //                   //         const EdgeInsets.symmetric(
                    //         //                   //             horizontal:
                    //         //                   //                 kHelpingPadding),
                    //         //                   //     child: Text(
                    //         //                   //       model.selectedValue
                    //         //                   //           ? AppLocalizations.of(
                    //         //                   //                   context)
                    //         //                   //               .wowAnserIsCorrect
                    //         //                   //               .capitalizeFirstLetter()
                    //         //                   //           // 'Wow...Answer is correct!'
                    //         //                   //           : AppLocalizations.of(
                    //         //                   //                   context)
                    //         //                   //               .answerISNotCorrect
                    //         //                   //               .capitalizeFirstLetter(),
                    //         //                   //       // 'Answer is not correct...',
                    //         //                   //       style: TextStyles
                    //         //                   //           .InterWhiteS18W700,
                    //         //                   //       textAlign: TextAlign.center,
                    //         //                   //     ),
                    //         //                   //   ),
                    //         //                   // ),
                    //         //                   const SizedBox(height: 4),
                    //         //                   Text(
                    //         //                     AppLocale
                    //         //                         .yourResponseIsOnPointTrulyMotivational
                    //         //                         .getString(context)
                    //         //                         .capitalizeFirstLetter(),
                    //         //                     // 'Your response is on point and truly motivational.',
                    //         //                     style: TextStyles
                    //         //                         .InterWhiteS14W400,
                    //         //                     textAlign: TextAlign.center,
                    //         //                   ),
                    //         //                   const SizedBox(height: 30),
                    //         //                 ],
                    //         //                 // ],
                    //         //               ),
                    //         //             ],
                    //         //           ),
                    //         //         ),
                    //         // ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // if (!isFinishedByTapping)
                    SizedBox(
                      height: 143,
                      child: Consumer<TrueFalsePracticePageVM>(
                        builder: (context, model, child) => model
                                .isFinishedByTapping
                            ? Container()
                            : GestureDetector(
                                onPanStart: model.startPosition,
                                onPanUpdate: model.updatePosition,
                                onPanEnd: (details) {
                                  bool? isFalseSelected = model.endPosition();
                                  if (isFalseSelected != null) {
                                    model.submitAnswer(!isFalseSelected);
                                    bool selectedValue = !isFalseSelected ==
                                        widget.model.getAnswerValue();
                                    model.model.onSelectOption(
                                        model.currentTask.options!.first,
                                        selectedCorrectAnswer: selectedValue);
                                    // widget.goToNextPage(selectedValue);
                                  }
                                },
                                child: Builder(
                                  builder: (context) {
                                    final milliseconds =
                                        model.isDragging ? 0 : 400;
                                    final position = model.positon;
                                    final center =
                                        constraints.biggest.center(Offset.zero);
                                    // if (center.dy == double.infinity) {
                                    //   center.dy = 145;
                                    // }
                                    final angle = model.angle * pi / 180;
                                    final rotatedMatrix = Matrix4.identity()
                                      ..translate(center.dx, center.dy)
                                      ..rotateZ(angle)
                                      ..translate(-center.dx, -center.dy);
                                    return AnimatedContainer(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kMainPadding),
                                      duration: Duration(
                                        milliseconds: milliseconds,
                                      ),
                                      transform: rotatedMatrix
                                        ..translate(position.dx, position.dy),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: DefaultContainer(
                                          height: 220,
                                          width: double.infinity,
                                          child: PhotoView(
                                            disableGestures: true,
                                            imageProvider: NetworkImage(
                                              model.currentTask.downloadUrl ??
                                                  "",
                                            ),
                                            loadingBuilder: (context, event) {
                                              final expectedBytes =
                                                  event?.expectedTotalBytes;
                                              final loadedBytes =
                                                  event?.cumulativeBytesLoaded;
                                              final value = loadedBytes !=
                                                          null &&
                                                      expectedBytes != null
                                                  ? loadedBytes / expectedBytes
                                                  : null;
                                              return Center(
                                                child: SizedBox(
                                                  width: 20.0,
                                                  height: 20.0,
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: value,
                                                    color: AppColors.primary700,
                                                  ),
                                                ),
                                              );
                                            },
                                            initialScale: PhotoViewComputedScale
                                                .contained,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: kBottomPadding),
              Center(
                child: Text(
                  AppLocale.youCanSwipeLeftRight
                      .getString(context)
                      .toUpperCase(),
                  // 'You can swipe left/right',
                  style: TextStyles.InterGrey500S12W600,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: kBottomPadding),
              // if (widget.model.selectedValue == null)
              Consumer<TrueFalsePracticePageVM>(
                builder: (context, model, child) => Row(
                  children: [
                    const SizedBox(width: kBottomPadding),
                    practiceSelectionButton(
                      true,
                      'checkMark',
                      AppColors.deepBlue300,
                      model.selectedValue != null
                          ? () {}
                          : () {
                              widget.model
                                  .submitAnswer(true, finishedByTapping: true);
                              bool selectedValue =
                                  true == widget.model.getAnswerValue();
                              model.model.onSelectOption(
                                  model.currentTask.options!.first,
                                  selectedCorrectAnswer: selectedValue);
                              // widget.goToNextPage(selectedValue);
                            },
                      model.selectedValue != null,
                      true == widget.model.getAnswerValue(),
                    ),
                    const SizedBox(width: kBottomPadding),
                    // if (selectedValue == null)
                    practiceSelectionButton(
                      false,
                      'crossMark',
                      AppColors.red300,
                      model.selectedValue != null
                          ? () {}
                          : () {
                              widget.model
                                  .submitAnswer(false, finishedByTapping: true);
                              bool selectedValue =
                                  false == widget.model.getAnswerValue();
                              model.model.onSelectOption(
                                  model.currentTask.options!.first,
                                  selectedCorrectAnswer: selectedValue);
                              // widget.goToNextPage(selectedValue);
                            },
                      model.selectedValue != null,
                      false == widget.model.getAnswerValue(),
                    ),
                    const SizedBox(width: kBottomPadding),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget practiceSelectionButton(
    bool isTrueButton,
    String iconName,
    Color color,
    VoidCallback submissionFunction,
    bool isAnswerSubmitted,
    bool isTrueAnswer,
  ) {
    return Expanded(
      child: InkWell(
        onTap: submissionFunction,
        child: Container(
          height: 80,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
              color:
                  isAnswerSubmitted && !isTrueAnswer ? AppColors.white : color,
              borderRadius: BorderRadius.circular(20)),
          child: SvgPicture.asset(
            'assets/svg/$iconName.svg',
            color: isAnswerSubmitted && !isTrueAnswer
                ? AppColors.grey300
                : isTrueButton
                    ? AppColors.deepBlue700
                    : AppColors.red600,
            height: isTrueButton ? 20 : 26,
            width: 26,
          ),
        ),
      ),
    );
  }
}
