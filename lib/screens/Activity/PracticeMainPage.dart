import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Activity/DayTable.dart';
import 'package:teachy_tec/screens/Activity/DayTableVM.dart';
import 'package:teachy_tec/screens/Activity/PracticeMainPageVM.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/widgets/BoardEmojisSelector.dart';
import 'package:teachy_tec/widgets/QuestionWidget.dart';
import 'package:teachy_tec/widgets/StudentsRoller.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';
import 'package:collection/collection.dart';

class PracticeMainPage extends StatelessWidget {
  const PracticeMainPage({required this.model, super.key});
  final PracticeMainPageVM model;
  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.viewInsetsOf(context).top +
        MediaQuery.paddingOf(context).top;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: model,
            ),
            ChangeNotifierProvider.value(
              value: model.dayTableModel,
            ),
          ],
          child: Consumer2<PracticeMainPageVM, DayTableVM>(
            builder: (context, model, dayTableModel, _) {
              if (model.currentPracticeWidget == null) {
                model.getCurrentPracticeWidget();
              }
              var currentTask = model.dayTableModel.currentSelectedTask;
              var currentStudentTask =
                  dayTableModel.selectedShuffledStudent.value == null
                      ? null
                      : dayTableModel.studentsToTask[
                              dayTableModel.selectedShuffledStudent.value!.id]
                          ?.firstWhereOrNull((task_) =>
                              task_.task ==
                              dayTableModel.currentSelectedTask!.task);
              // model.updateSelectedOptionOnPageStart();
              return Stack(
                fit: StackFit.expand,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: kToolbarHeight + kMainPadding + topPadding),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          ValueListenableBuilder<bool>(
                            valueListenable: model.dayTableModel.isTimerOpen,
                            builder: (context, isTimerOpen, child) {
                              return TimerWidget(
                                  isTimerOpen, model.dayTableModel);
                            },
                          ),
                          AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              reverseDuration:
                                  const Duration(milliseconds: 300),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              child: dayTableModel
                                              .selectedShuffledStudent.value !=
                                          null &&
                                      dayTableModel.studentsToTask[dayTableModel
                                                  .selectedShuffledStudent
                                                  .value!
                                                  .id]
                                              ?.firstWhereOrNull((task_) =>
                                                  task_.task ==
                                                  currentTask?.task)
                                              ?.emoji_id !=
                                          null
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: kMainPadding),
                                      child: Row(
                                        children: [
                                          const SizedBox(width: kMainPadding),
                                          Text(
                                            AppLocale.score
                                                .getString(context)
                                                .toUpperCase(),
                                            style: TextStyles.InterBlackS18W000,
                                          ),
                                          const SizedBox(
                                              width: kInternalPadding),
                                          EmojisIconPreview(
                                            model: getEmojiById(dayTableModel
                                                .studentsToTask[dayTableModel
                                                    .selectedShuffledStudent
                                                    .value!
                                                    .id]
                                                ?.firstWhereOrNull((task_) =>
                                                    task_.task ==
                                                    currentTask?.task)!
                                                .emoji_id),
                                          ),
                                          const Spacer(),
                                          currentStudentTask?.comment == null
                                              ? InkWell(
                                                  onTap: () => dayTableModel.addNotes(
                                                      student: dayTableModel
                                                          .selectedShuffledStudent
                                                          .value!,
                                                      task:
                                                          currentStudentTask!),
                                                  child: SvgPicture.asset(
                                                    'assets/svg/addNote.svg',
                                                    height: 32,
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () =>
                                                      dayTableModel.editComment(
                                                          student: dayTableModel
                                                              .selectedShuffledStudent
                                                              .value!,
                                                          task:
                                                              currentStudentTask),
                                                  child: SvgPicture.asset(
                                                    'assets/svg/notesIcon.svg',
                                                    height: 25,
                                                  ),
                                                ),
                                          const SizedBox(
                                              width: kHelpingPadding),
                                          InkWell(
                                            onTap: () =>
                                                model.restartScoreForTask(
                                                    student: dayTableModel
                                                        .selectedShuffledStudent
                                                        .value!,
                                                    task: currentStudentTask!),
                                            child: SvgPicture.asset(
                                              'assets/svg/restart.svg',
                                              height: 30,
                                            ),
                                          ),
                                          const SizedBox(width: kMainPadding),
                                        ],
                                      ),
                                    )
                                  : const SizedBox()),
                          const SizedBox(height: kMainPadding),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: model.isPreviousQuestionButtonActive()
                                    ? model.goToreviousQuestion
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: kMainPadding),
                                  child: SvgPicture.asset(
                                    matchTextDirection: true,
                                    'assets/svg/arrowPrevious.svg',
                                    color:
                                        model.isPreviousQuestionButtonActive()
                                            ? null
                                            : Colors.transparent,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: CheckpointWidget(
                                    index: model.getCurrentQuestionIndex(),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: model.isNextQuestionButtonActive()
                                    ? model.goToNextQuestion
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: kMainPadding),
                                  child: SvgPicture.asset(
                                    'assets/svg/arrowNext.svg',
                                    matchTextDirection: true,
                                    color: model.isNextQuestionButtonActive()
                                        ? null
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: kMainPadding,
                          ),
                          if (currentTask != null &&
                              model.currentPracticeWidget != null)
                            model.currentPracticeWidget!,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.only(top: topPadding),
                      height: kToolbarHeight + topPadding + kMainPadding,
                      decoration: BoxDecoration(
                        boxShadow: KboxBlurredShadowsArray,
                        color: AppColors.white,
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsetsDirectional.only(
                                start: kMainPadding,
                              ),
                              child: SvgPicture.asset(
                                  AppUtility.getArrowAssetLocalized(),
                                  height: 22,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.grey400,
                                    BlendMode.srcIn,
                                  )),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 60),
                              child: model.dayTableModel.selectedShuffledStudent
                                          .value ==
                                      null
                                  ? Text(
                                      AppLocale.taskActivity
                                          .getString(context)
                                          .capitalizeAllWord(),
                                      textAlign: TextAlign.center,
                                      style: TextStyles.InterGrey800S16W600,
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(
                                              kBottomPadding),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppColors.primary700,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: SvgPicture.asset(model
                                                      .dayTableModel
                                                      .selectedShuffledStudent
                                                      .value
                                                      ?.gender ==
                                                  Gender.male
                                              ? 'assets/svg/male.svg'
                                              : 'assets/svg/female.svg'),
                                        ),
                                        const SizedBox(width: kInternalPadding),
                                        Text(
                                          model
                                              .dayTableModel
                                              .selectedShuffledStudent
                                              .value!
                                              .name,
                                          style: TextStyles.InterGrey800S12W400,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsetsDirectional.only(
                              start: kMainPadding,
                            ),
                            child: SvgPicture.asset(
                                AppUtility.getArrowAssetLocalized(),
                                height: 22,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.white,
                                  BlendMode.srcIn,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned.directional(
                    textDirection: AppUtility.getTextDirectionality(),
                    start: dayTableModel.position?.dx ??
                        MediaQuery.sizeOf(context).width - 48,
                    top: dayTableModel.position?.dy ??
                        MediaQuery.sizeOf(context).height - 200,
                    child: Draggable(
                      feedback: ActivityTableSettings(
                        dayTableModel,
                        isInPracticePage: true,
                        answerSubmittedType:
                            model.getAnswerTypeForCurrentTask(),
                      ),
                      childWhenDragging: Container(),
                      onDragEnd: (details) {
                        var currentSize = MediaQuery.of(context).size;
                        double nearestX =
                            details.offset.dx + 22 > (currentSize.width / 2)
                                ? 4.0
                                : currentSize.width - 48.0;
                        var currentVerticalOffset = details.offset.dy - 130 < 0
                            ? 130
                            : details.offset.dy + 250 > currentSize.height
                                ? currentSize.height - 250
                                : details.offset.dy;

                        dayTableModel.setWidgetOffset(
                            Offset(nearestX, currentVerticalOffset.toDouble()));
                      },
                      child: Center(
                        child: ActivityTableSettings(
                          dayTableModel,
                          isInPracticePage: true,
                          answerSubmittedType:
                              model.getAnswerTypeForCurrentTask(),
                          onEmojiSelected:
                              model.setEmojiForCurrentTaskAndCurrentUser,
                        ),
                      ),
                    ),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: model.isFeedBackShown,
                    builder: (context, isFeedBackShown, child) =>
                        AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      reverseDuration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      child: !isFeedBackShown ||
                              model.currentSelectedOption == null
                          ? const SizedBox()
                          : Stack(
                              children: [
                                Positioned.fill(
                                  child: ClipRRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 5, sigmaY: 5),
                                      child: Container(),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: DefaultContainer(
                                      boxShadow: kListShadowsArray,
                                      color: AppColors.white,
                                      height: 350,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: kMainPadding),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                              height: kBottomPadding),
                                          Text(
                                              (currentTask?.taskType ==
                                                              TaskType
                                                                  .trueFalse &&
                                                          model.selectedCorrectAnswerValue ==
                                                              true) ||
                                                      (currentTask?.taskType !=
                                                              TaskType
                                                                  .trueFalse &&
                                                          model
                                                              .currentSelectedOption!
                                                              .isCorrect)

                                                  //   ?    model.currentSelectedOption!
                                                  // .isCorrect
                                                  ? AppLocale.wellDone
                                                      .getString(context)
                                                      .capitalizeFirstLetter()
                                                  : AppLocale.couldDoBetter
                                                      .getString(context)
                                                      .capitalizeFirstLetter(),
                                              style:
                                                  TextStyles.InterBlackS30W700),
                                          // const SizedBox(height: kBottomPadding),
                                          Expanded(
                                              child: Image.asset((currentTask
                                                                  ?.taskType ==
                                                              TaskType
                                                                  .trueFalse &&
                                                          model.selectedCorrectAnswerValue ==
                                                              true) ||
                                                      (currentTask?.taskType !=
                                                              TaskType
                                                                  .trueFalse &&
                                                          model
                                                              .currentSelectedOption!
                                                              .isCorrect)
                                                  ? 'assets/gif/happy.gif'
                                                  : 'assets/gif/sad.gif')),
                                          const SizedBox(
                                              height: kBottomPadding),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                    ),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: dayTableModel.showFortuneWheel,
                    builder: (context, showFortuneWheel, child) =>
                        showFortuneWheel
                            ? Positioned.fill(
                                child: InkWell(
                                  onTap: dayTableModel.removeShuffle,
                                  child: ClipRRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 5, sigmaY: 5),
                                      child: Container(),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: dayTableModel.showFortuneWheel,
                    builder: (context, showFortuneWheel, child) =>
                        showFortuneWheel
                            ? Padding(
                                padding: const EdgeInsets.all(kMainPadding),
                                child: StudentsRoller(
                                  students: [
                                    ...dayTableModel.getStudentsToShuffle()
                                  ],
                                  startRollerSound:
                                      dayTableModel.startRollerSound,
                                  onCancelShuffle: dayTableModel.removeShuffle,
                                  shuffledStudents: [
                                    ...dayTableModel.shuffledStudents
                                  ],
                                  onSelectStudent: (student) =>
                                      dayTableModel.onSelectShuffledStudent(
                                    selectedStudentFromWheel: student,
                                  ),
                                  onRestartShuffle:
                                      dayTableModel.restartShuffling,
                                ),
                              )
                            : Container(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
