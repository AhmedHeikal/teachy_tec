// ignore_for_file: prefer_null_aware_operators
import 'dart:ui';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/hive/controllers/activityStudentsController.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/models/Task.dart';
import 'package:teachy_tec/screens/Activity/DayTableVM.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/utils/SoundService.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/widgets/AppPickers.dart';
import 'package:teachy_tec/widgets/BoardEmojisSelector.dart';
import 'package:teachy_tec/widgets/StudentsRoller.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';
import 'package:collection/collection.dart';

const double fixedRowWidth = 112;
const double containerFullHeight = 75;
const double containerMinimizedHeight = 65;
const double containerFullWidth = 51;
const double containerMinimizedWidth = 40;
const double translationOffset = 5;

// ignore: must_be_immutable
class DayTable extends StatefulWidget {
  final DayTableVM model;
  late double fixedColWidth;
  late double cellWidth;
  late double cellHeight;
  late double cellMargin;
  late double cellSpacing;

  DayTable({super.key, required this.model}) {
    fixedColWidth = 112.0;
    cellHeight = containerFullHeight;
    cellWidth = 120.0;
    cellMargin = 0.0;
    cellSpacing = 0.0;
  }

  @override
  State<DayTable> createState() => _DayTableState();
}

class _DayTableState extends State<DayTable> {
  final _columnController = ScrollController();
  final _rowController = ScrollController();
  // final _subTableXController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    ActivityStudentsController().updateSingleStudentActivityToServer(
        activityId: widget.model.currentActivity.id);
    widget.model.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    widget.model.stopPlayer();
    widget.model.stopEmojisPlayer();
    // Be careful : you must `close` the audio session when you have finished with it.
    // widget.model.player.stop();
    widget.model.player.dispose();
    // widget.model.emojisPlayer.stop();
    widget.model.emojisPlayer.dispose();
  }

  // final Debouncer _debouncer = Debouncer(milliseconds: 200);

  @override
  void initState() {
    super.initState();

    widget.model.rowsScrollController.addListener(() {
      if (_rowController.position.pixels !=
          widget.model.rowsScrollController.position.pixels) {
        _rowController
            .jumpTo(widget.model.rowsScrollController.position.pixels);
      }
    });

    widget.model.columnsScrollController.addListener(() {
      if (_columnController.position.pixels !=
          widget.model.columnsScrollController.position.pixels) {
        _columnController
            .jumpTo(widget.model.columnsScrollController.position.pixels);
      }
    });

    _rowController.addListener(() {
      if (widget.model.rowsScrollController.position.pixels !=
          _rowController.position.pixels) {
        widget.model.rowsScrollController
            .jumpTo(_rowController.position.pixels);
      }
    });

    _columnController.addListener(() {
      if (widget.model.columnsScrollController.position.pixels !=
          _columnController.position.pixels) {
        widget.model.columnsScrollController
            .jumpTo(_columnController.position.pixels);
      }
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
    ]);

    // addEmojiSound();
  }

  Widget _buildFixedCol() => Material(
        child: DataTable(
          horizontalMargin: widget.cellMargin,
          columnSpacing: widget.cellSpacing,
          headingRowHeight: widget.cellHeight,
          dataRowMinHeight: widget.cellHeight,
          dataRowMaxHeight: widget.cellHeight,
          dividerThickness: 0,
          showCheckboxColumn: false,
          decoration: const BoxDecoration(border: null),
          columns: const [DataColumn(label: SizedBox())],
          rows: (widget.model.currentActivity.students ?? []).mapWithIndex(
            (student, index) {
              var isStudentSelectedInShuffle =
                  student.name.trim().toLowerCase() ==
                      widget.model.selectedShuffledStudent.value?.name
                          .trim()
                          .toLowerCase();

              return DataRow(
                cells: [
                  DataCell(
                    Container(
                      width: widget.fixedColWidth,
                      color: AppColors.white,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 3, 3, 3),
                        padding: const EdgeInsets.fromLTRB(
                            3, 3, kInternalPadding, 3),
                        decoration: BoxDecoration(
                          // boxShadow: [kDropShadow, KCardShadow],
                          border: Border.all(color: AppColors.grey400),
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12)),
                          color: isStudentSelectedInShuffle
                              ? AppColors.primary500
                              : AppColors.white,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          (index + 1).toString(),
                                          style: TextStyles.InterGrey400S12W400,
                                        ),
                                      ),
                                      if (isStudentSelectedInShuffle)
                                        InkWell(
                                          onTap: widget.model
                                              .removeShuffledStudentAndExitShuffle,
                                          child: const Icon(
                                            Icons.close,
                                            color: AppColors.red600,
                                          ),
                                        )
                                    ],
                                  ),
                                  // Spacer(),
                                  Expanded(
                                    // alignment: AlignmentDirectional.bottomStart,
                                    child: Align(
                                      alignment:
                                          AlignmentDirectional.bottomStart,
                                      child: Text(
                                        student.name,
                                        //  +
                                        //     "asd fads f asdl kjlksjkdls jlksadj lajdsl kjsakldj alksjd lkajsd ;kljasd;kl jds;kal",
                                        maxLines: 2,
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyles.InterBlackS14W400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ).toList(),
        ),
      );

  Widget _buildFixedRow() => Material(
        color: Colors.greenAccent,
        child: DataTable(
            horizontalMargin: widget.cellMargin,
            columnSpacing: widget.cellSpacing,
            headingRowHeight: widget.cellHeight,
            dataRowHeight: widget.cellHeight,
            dividerThickness: 0,
            showCheckboxColumn: false,
            decoration: const BoxDecoration(
              border: null,
              color: AppColors.white,
            ),
            columns: (widget.model.currentActivity.tasks ?? [])
                .mapWithIndex((question, index) {
              return DataColumn(
                label: InkWell(
                  onTap: () => widget.model.onTaskTap(selectedTask: question),
                  // widget.model.controlQuestionPreview(question.task),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      boxShadow: [kDropShadow, KCardShadow],
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.grey900,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.passthrough,
                        children: [
                          SizedBox(
                            height: containerFullHeight,
                            width: fixedRowWidth - 4,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: kHelpingPadding),
                                            child: Text(
                                              question.task,
                                              softWrap: true,
                                              style:
                                                  TextStyles.InterWhiteS12W400,
                                              maxLines:
                                                  question.downloadUrl != null
                                                      ? 1
                                                      : 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: kHelpingPadding,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (question.downloadUrl != null)
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: PhotoView(
                                          disableGestures: true,
                                          imageProvider: NetworkImage(
                                            question.downloadUrl!,
                                          ),
                                          initialScale:
                                              PhotoViewComputedScale.covered *
                                                  1,
                                          loadingBuilder: (context, event) {
                                            final expectedBytes =
                                                event?.expectedTotalBytes;

                                            final loadedBytes =
                                                event?.cumulativeBytesLoaded;

                                            final value = loadedBytes != null &&
                                                    expectedBytes != null
                                                ? loadedBytes / expectedBytes
                                                : null;

                                            return Stack(
                                              children: [
                                                Align(
                                                  child: SizedBox(
                                                    height: 10,
                                                    width: 10,
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        value: value,
                                                        color: AppColors
                                                            .primary700,
                                                        strokeWidth: 2,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),

                                        // Image.network(
                                        //   question.downloadUrl!,
                                        //   fit: BoxFit.cover,
                                        // ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          // if (question.options != null &&
                          //     question.options!.isNotEmpty)
                          Positioned.directional(
                            textDirection: Directionality.of(context),
                            bottom: 0,
                            end: 0,
                            child: ClipRRect(
                              borderRadius: const BorderRadiusDirectional.only(
                                topStart: Radius.circular(8),
                              ),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                                child: Container(
                                  color: question.downloadUrl != null
                                      ? AppColors.grey900.withOpacity(0.6)
                                      : AppColors.white.withOpacity(0.8),
                                  padding: const EdgeInsets.all(4),
                                  child: Row(
                                    children: [
                                      if (question.taskType ==
                                          TaskType.multipleOptions) ...[
                                        Text(
                                          question.options!.length.toString(),
                                          style: TextStyles.InterWhiteS12W600
                                              .copyWith(
                                            fontStyle: FontStyle.italic,
                                            color: question.downloadUrl != null
                                                ? null
                                                : AppColors.grey900,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                      ],
                                      question.taskType == TaskType.textOnly
                                          ? SvgPicture.asset(
                                              'assets/svg/textQuestion.svg',
                                              height: 14,
                                              color:
                                                  question.downloadUrl != null
                                                      ? AppColors.primary50
                                                      : AppColors.grey900,
                                            )
                                          : question.taskType ==
                                                  TaskType.trueFalse
                                              ? SvgPicture.asset(
                                                  'assets/svg/trueFalse2.svg',
                                                  height: 14,
                                                  color: question.downloadUrl !=
                                                          null
                                                      ? AppColors.primary50
                                                      : AppColors.grey900,
                                                )
                                              : SvgPicture.asset(
                                                  'assets/svg/documents.svg',
                                                  color: question.downloadUrl !=
                                                          null
                                                      ? AppColors.primary50
                                                      : AppColors.grey900,
                                                )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // LanguageDropdown(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
            rows: const []),
      );

  Widget _buildSubTable() => DataTable(
      horizontalMargin: widget.cellMargin,
      columnSpacing: widget.cellSpacing,
      headingRowHeight: widget.cellHeight,
      dataRowHeight: widget.cellHeight,
      dividerThickness: 0,
      showCheckboxColumn: false,
      decoration: const BoxDecoration(
        border: null,
        color: AppColors.white,
      ),
      columns: (widget.model.currentActivity.tasks ?? []).map((task) {
        return DataColumn(
          label: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey400.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 20,
                  offset: const Offset(0, 2),
                ),
              ],
              color: AppColors.white,
            ),
            height: containerFullHeight,
            width: containerFullWidth,
            child: Row(
              children: [
                dottedVerticalLine,
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: kHelpingPadding),
                    ],
                  ),
                ),
                const SizedBox(width: 1),
              ],
            ),
          ),
        );
      }).toList(),
      rows: (widget.model.currentActivity.students ?? []).map((student) {
        return DataRow(
            cells: (widget.model.currentActivity.tasks ?? []).mapWithIndex(
          (task, index) {
            var currentDate = DateTime.now();
            currentDate = DateTime(
              currentDate.year,
              currentDate.month,
              currentDate.day - 1,
              23,
              59,
              59,
              59,
              59,
            );

            return DataCell(
              InkWell(
                onTap: widget.model.selectedEmoji?.emojiType == null
                    ? null
                    : widget.model.selectedEmoji?.emojiPath == EmojisPath.Eraser
                        ? () {
                            widget.model.eraserEmojiSound();
                            widget.model.removeEmojiFromCell(
                                student: student,
                                task: Task(
                                  task: task.task,
                                  id: task.id,
                                ));
                          }
                        : widget.model.selectedEmoji?.emojiPath ==
                                EmojisPath.AddNote
                            ? () {
                                widget.model.noteEmojiSound();
                                widget.model.addNotes(
                                  student: student,
                                  task: Task(
                                    task: task.task,
                                    id: task.id,
                                    grade_value: widget.model.selectedEmoji!
                                        .emojiPath.iconGrade.iconValue,
                                    emoji_id: widget.model.selectedEmoji!.id,
                                    taskType: task.taskType,
                                  ),
                                );
                              }
                            : () {
                                if (widget.model.selectedEmoji != null) {
                                  if (widget.model.selectedEmoji!.soundType ==
                                      SoundType.correct) {
                                    widget.model.correctEmojiSound();
                                  } else {
                                    widget.model.wrongEmojiSound();
                                  }
                                }
                                widget.model.setEmojisToCell(
                                  student: student,
                                  task: Task(
                                    task: task.task,
                                    id: task.id,
                                    taskType: task.taskType,
                                    grade_value:
                                        widget.model.selectedEmoji == null
                                            ? null
                                            : widget.model.selectedEmoji!
                                                .emojiPath.iconGrade.iconValue,
                                    emoji_id: widget.model.selectedEmoji == null
                                        ? null
                                        : widget.model.selectedEmoji!.id,
                                  ),
                                );
                              },
                child: TaskWidget(
                  isFirstCell: index == 0,
                  isSelectedStudentToShuffle: widget
                          .model.selectedShuffledStudent.value?.name
                          .toLowerCase() ==
                      student.name.toLowerCase(),
                  editComment: () => widget.model.editComment(
                      student: student,
                      task: widget.model.studentsToTask[student.id]
                          ?.firstWhereOrNull(
                              (task_) => task_.task == task.task)),
                  task: widget.model.studentsToTask[student.id]
                      ?.firstWhereOrNull((task_) => task_.task == task.task),
                ),
              ),
            );
          },
        ).toList());
      }).toList());

  Widget _buildCornerCell() => DataTable(
          horizontalMargin: widget.cellMargin,
          columnSpacing: widget.cellSpacing,
          headingRowHeight: widget.cellHeight,
          dataRowHeight: widget.cellHeight,
          dividerThickness: 0,
          showCheckboxColumn: false,
          columns: [
            DataColumn(
              label: Container(
                width: widget.fixedColWidth,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                ),
                child: InkWell(
                  onTap: widget.model.addNewItem,
                  child: Center(
                      child: SvgPicture.asset(
                    'assets/svg/addButtonWithCircle.svg',
                    height: 45,
                  )),
                ),
              ),
            )
          ],
          rows: const []);

  @override
  Widget build(BuildContext context) {
    debugPrint(
        'Heikal - directionality of context in day table ${Directionality.of(context)}');

    bool is24HoursFormat = MediaQuery.alwaysUse24HourFormatOf(context);

    double topPadding = MediaQuery.viewInsetsOf(context).top +
        MediaQuery.paddingOf(context).top;
    return OrientationBuilder(
      builder: (context, orientation) {
        // Lock orientation to landscape only when the screen is in landscape mode
        if (orientation == Orientation.landscape) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeRight,
          ]);
        } else {
          // Restore system preferred orientations in portrait mode
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
        }

        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: ChangeNotifierProvider.value(
            value: widget.model,
            child: Scaffold(
              backgroundColor: AppColors.white,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              body: Stack(
                children: [
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: Consumer<DayTableVM>(
                      builder: (context, model, _) => Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                top: kToolbarHeight + topPadding),
                            child: Column(
                              children: [
                                ValueListenableBuilder<bool>(
                                  valueListenable: model.isTimerOpen,
                                  builder: (context, isTimerOpen, child) {
                                    return TimerWidget(isTimerOpen, model);
                                  },
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    physics: const ClampingScrollPhysics(),
                                    controller: model.mainAxisController,
                                    // physics: NeverScrollableScrollPhysics(),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: kMainPadding),
                                      child: Stack(
                                        alignment:
                                            AlignmentDirectional.topCenter,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              SingleChildScrollView(
                                                controller: _columnController,
                                                scrollDirection: Axis.vertical,
                                                physics:
                                                    const ClampingScrollPhysics(),
                                                child: _buildFixedCol(),
                                              ),
                                              if (widget.model.currentActivity
                                                          .tasks !=
                                                      null &&
                                                  widget.model.currentActivity
                                                      .tasks!.isNotEmpty)
                                                Flexible(
                                                  child: SingleChildScrollView(
                                                    controller: model
                                                        .rowsScrollController,
                                                    physics:
                                                        const ClampingScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child:
                                                        SingleChildScrollView(
                                                      controller: model
                                                          .columnsScrollController,
                                                      physics:
                                                          const ClampingScrollPhysics(),
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      child: _buildSubTable(),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          if (widget.model.currentActivity
                                                      .tasks !=
                                                  null &&
                                              widget.model.currentActivity
                                                  .tasks!.isNotEmpty)
                                            Row(
                                              children: <Widget>[
                                                _buildCornerCell(),
                                                Flexible(
                                                  child: SingleChildScrollView(
                                                    controller: _rowController,
                                                    physics:
                                                        const ClampingScrollPhysics(),
                                                    // controller:
                                                    //     _rowController,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    // physics:
                                                    //     const NeverScrollableScrollPhysics(),
                                                    child: _buildFixedRow(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          Row(
                                            children: [
                                              _buildCornerCell(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable: model.showActivityInfo,
                            builder: (context, showActivityInfo, child) =>
                                !showActivityInfo
                                    ? Container()
                                    : Positioned(
                                        top: kToolbarHeight + topPadding,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: kMainPadding),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 10, sigmaY: 10),
                                              child: DefaultContainer(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: kMainPadding),
                                                color: AppColors.grey900
                                                    .withOpacity(0.7),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                            AppLocale.classVar
                                                                .getString(
                                                                    context)
                                                                .capitalizeFirstLetter(),
                                                            style: TextStyles
                                                                .InterYellow700S16W500),
                                                        const Text(": ",
                                                            style: TextStyles
                                                                .InterYellow700S16W500),
                                                        Text(
                                                          widget
                                                              .model
                                                              .currentActivity
                                                              .currentClass!
                                                              .name,
                                                          style: TextStyles
                                                                  .InterWhiteS16W400
                                                              .copyWith(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal:
                                                              kMainPadding),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/svg/calendar.svg',
                                                            colorFilter:
                                                                const ColorFilter
                                                                    .mode(
                                                              AppColors
                                                                  .primary700,
                                                              BlendMode.srcIn,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                              AppUtility.appTimeFormat(
                                                                  DateTime.fromMillisecondsSinceEpoch(widget
                                                                      .model
                                                                      .currentActivity
                                                                      .timestamp)),
                                                              style: TextStyles
                                                                  .InterWhiteS16W400),
                                                          const Spacer(),
                                                          SvgPicture.asset(
                                                            'assets/svg/clock.svg',
                                                            colorFilter:
                                                                const ColorFilter
                                                                    .mode(
                                                              AppColors
                                                                  .primary700,
                                                              BlendMode.srcIn,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                              is24HoursFormat
                                                                  ? AppUtility
                                                                      .getTwentyFourTimeFromSeconds(
                                                                      widget
                                                                          .model
                                                                          .currentActivity
                                                                          .time,
                                                                      inUtc:
                                                                          true,
                                                                    )
                                                                  : AppUtility
                                                                      .getAMPMTimeFromSeconds(
                                                                      widget
                                                                          .model
                                                                          .currentActivity
                                                                          .time,
                                                                      inUtc:
                                                                          true,
                                                                    ),
                                                              style: TextStyles
                                                                  .InterWhiteS16W400),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: topPadding),
                    height: kToolbarHeight + topPadding,
                    decoration: BoxDecoration(
                      boxShadow: KboxBlurredShadowsArray,
                      color: AppColors.white,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.loose,
                      children: [
                        Positioned.directional(
                          textDirection: AppUtility.getTextDirectionality(),
                          start: 0,
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  kHelpingPadding,
                                  kHelpingPadding,
                                  kBottomPadding,
                                  2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                      start: kHelpingPadding,
                                    ),
                                    child: SvgPicture.asset(
                                      AppUtility.getArrowAssetLocalized(),
                                      height: 22,
                                      colorFilter: const ColorFilter.mode(
                                          AppColors.grey400, BlendMode.srcIn),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          child: InkWell(
                            onTap: widget.model.toggleSchedule,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppLocale.classActivity
                                      .getString(context)
                                      .capitalizeFirstLetter(),
                                  style: TextStyles.InterGrey800S16W600,
                                ),
                                const SizedBox(width: 4),
                                InkWell(
                                  onTap: widget.model.toggleActivityInfo,
                                  child: SvgPicture.asset(
                                    'assets/svg/info.svg',
                                    colorFilter: const ColorFilter.mode(
                                        AppColors.primary700, BlendMode.srcIn),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Consumer<DayTableVM>(
                          builder: (context, model, _) =>
                              Positioned.directional(
                            textDirection: AppUtility.getTextDirectionality(),
                            end: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: model.onEditTapped,
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            kMainPadding,
                                            kHelpingPadding,
                                            kMainPadding,
                                            2),
                                    child: SvgPicture.asset(
                                      'assets/svg/pen.svg',
                                      height: 24,
                                      // color: AppColors.grey700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Consumer<DayTableVM>(
                    builder: (context, model, _) => Positioned.directional(
                      textDirection: AppUtility.getTextDirectionality(),
                      start: model.position?.dx ??
                          MediaQuery.sizeOf(context).width - 48,
                      top: model.position?.dy ??
                          MediaQuery.sizeOf(context).height - 200,
                      child: Draggable(
                        feedback: ActivityTableSettings(model),
                        childWhenDragging: Container(),
                        onDragEnd: (details) {
                          var currentSize = MediaQuery.of(context).size;
                          double nearestX =
                              details.offset.dx + 22 > (currentSize.width / 2)
                                  ? 4.0
                                  : currentSize.width - 48.0;
                          var currentVerticalOffset =
                              details.offset.dy - 130 < 0
                                  ? 130
                                  : details.offset.dy + 250 > currentSize.height
                                      ? currentSize.height - 250
                                      : details.offset.dy;

                          widget.model.setWidgetOffset(Offset(
                              nearestX, currentVerticalOffset.toDouble()));
                        },
                        child: ActivityTableSettings(model),
                      ),
                    ),
                  ),
                  // Consumer<DayTableVM>(
                  //     builder: (context, model, _) => model.selectedQuestion ==
                  //             null
                  //         ? Container()
                  //         : InkWell(
                  //             onTap: () => model.controlQuestionPreview(null),
                  //             child: Stack(
                  //               children: [
                  //                 Positioned.fill(
                  //                   child: ClipRRect(
                  //                     child: BackdropFilter(
                  //                       filter: ImageFilter.blur(
                  //                           sigmaX: 5, sigmaY: 5),
                  //                       child: Container(),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 Positioned.fill(
                  //                     child: Center(
                  //                   child: DefaultContainer(
                  //                     margin: const EdgeInsets.all(30),
                  //                     color: AppColors.grey900,
                  //                     padding: const EdgeInsets.symmetric(
                  //                         vertical: 20,
                  //                         horizontal: kBottomPadding),
                  //                     child: Text(
                  //                       model.selectedQuestion!,
                  //                       style: TextStyles.InterYellow700S30W700,
                  //                     ),
                  //                   ),
                  //                 ))
                  //               ],
                  //             ),
                  //           )),
                  if (!widget.model.isInPracticePage) ...[
                    ValueListenableBuilder<bool>(
                      valueListenable: widget.model.showFortuneWheel,
                      builder: (context, showFortuneWheel, child) =>
                          showFortuneWheel
                              ? Positioned.fill(
                                  child: InkWell(
                                    onTap: widget.model.removeShuffle,
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
                      valueListenable: widget.model.showFortuneWheel,
                      builder: (context, showFortuneWheel, child) =>
                          showFortuneWheel
                              ? Padding(
                                  padding: const EdgeInsets.all(kMainPadding),
                                  child: StudentsRoller(
                                    students: [
                                      ...widget.model.getStudentsToShuffle()
                                    ],
                                    startRollerSound:
                                        widget.model.startRollerSound,
                                    onCancelShuffle: widget.model.removeShuffle,
                                    shuffledStudents: [
                                      ...widget.model.shuffledStudents
                                    ],
                                    onSelectStudent: (student) =>
                                        widget.model.onSelectShuffledStudent(
                                      selectedStudentFromWheel: student,
                                    ),
                                    onRestartShuffle:
                                        widget.model.restartShuffling,
                                  ),
                                )
                              : Container(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget ActivityTableSettings(
  DayTableVM model, {
  bool isInPracticePage = false,
  AnswerSubmittedType? answerSubmittedType,
  Function(Emoji)? onEmojiSelected,
}) =>
    DefaultContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: kInternalPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.grey800,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.6),
            spreadRadius: 0,
            blurRadius: 1.28,
            offset: const Offset(0.64, 0.96),
          ),
          BoxShadow(
            color: AppColors.black.withOpacity(0.6),
            spreadRadius: 0,
            blurRadius: 1.28,
            offset: const Offset(-0.256, -0.64), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isInPracticePage || answerSubmittedType != null) ...[
            InkWell(
              onTap: () => model.showEmojisPicker(
                answerSubmittedType:
                    !isInPracticePage ? null : answerSubmittedType,
                onEmojiSelected: onEmojiSelected,
              ),
              child: model.selectedEmoji == null
                  ? SvgPicture.asset(
                      'assets/svg/emojis.svg',
                    )
                  : model.selectedEmoji!.emojiPath.iconPath.contains('svg')
                      ? SvgPicture.asset(
                          model.selectedEmoji!.emojiPath.iconPath,
                          height: 30,
                          // width: 35,
                        )
                      : Image.asset(
                          model.selectedEmoji!.emojiPath.iconPath,
                          height: 30,
                          // width: 35,
                        ),
            ),
            const SizedBox(height: kInternalPadding),
            seperator(),
            const SizedBox(height: 2),
            seperator(),
            const SizedBox(height: kInternalPadding),
          ],
          if ((model.currentActivity.students?.length ?? 0) > 1) ...[
            InkWell(
              onTap: model.showShuffleOverlay,
              child: SvgPicture.asset(
                model.selectedShuffledStudent.value != null
                    ? 'assets/svg/restartArrow.svg'
                    : 'assets/svg/randomSelect.svg',
                width: 35,
              ),
            ),
            const SizedBox(height: kInternalPadding),
            seperator(),
            const SizedBox(height: 2),
            seperator(),
            const SizedBox(height: kInternalPadding),
          ],
          ValueListenableBuilder<bool>(
            valueListenable: model.isTimerOpen,
            builder: (context, isTimerActive, child) => InkWell(
              onTap: model.toggleTimerOpen,
              child: SvgPicture.asset(
                !isTimerActive
                    ? 'assets/svg/addTimer.svg'
                    : 'assets/svg/removeTimer.svg',
                width: 35,
              ),
            ),
          ),
        ],
      ),
    );

AnimatedContainer TimerWidget(bool isTimerOpen, DayTableVM model) {
  return AnimatedContainer(
    height: isTimerOpen ? 80 : 0.0,
    duration: const Duration(milliseconds: 500),
    child: !isTimerOpen
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(top: kMainPadding),
            child: ClipRect(
              child: Row(
                children: [
                  const SizedBox(width: kMainPadding),
                  InkWell(
                    onTap: () async {},
                    child: ValueListenableBuilder<int>(
                      valueListenable: model.currentTimerValue,
                      builder: (context, currentTimerValue, child) {
                        var currentTimeCharactersList =
                            AppUtility.getTimerTextFromSeconds(
                                    currentTimerValue)
                                .characters
                                .toList();
                        return InkWell(
                          onTap: () async {
                            await UIRouter.showAppBottomDrawerWithCustomWidget(
                              child: SecondsMinutesTimer(
                                initialValue: model.latestTimerSetValue,
                                callbackFunction: (duration) {
                                  model.setTimerValue(duration);
                                },
                                title: AppLocale.setTimer
                                    .getString(context)
                                    .capitalizeFirstLetter(),
                              ),
                            );
                          },
                          child: Row(
                            textDirection: TextDirection.ltr,
                            children: currentTimeCharactersList
                                .mapWithIndex(
                                  (e, index) => Container(
                                    width: e == ':' ? 16 : 36,
                                    decoration: BoxDecoration(
                                      boxShadow: e == ':'
                                          ? []
                                          : [kDropShadow, kUpperShadow],
                                      color: e != ':'
                                          ? AppColors.grey900
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: e == ':' ? 0 : 2),
                                    child: Text(
                                      e,
                                      textAlign: TextAlign.center,
                                      style: TextStyles.InterYellow700S30W700
                                          .copyWith(
                                        color: currentTimerValue <= 5
                                            ? AppColors.red700
                                            : e == '0' &&
                                                    ((index == 1 &&
                                                            currentTimeCharactersList[
                                                                    0] ==
                                                                '0') ||
                                                        (index == 4 &&
                                                            currentTimeCharactersList[
                                                                    3] ==
                                                                '0') ||
                                                        index == 0 ||
                                                        index == 3)
                                                ? AppColors.primary500
                                                : null,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      },
                    ),
                  ),
                  const Spacer(),
                  ValueListenableBuilder<bool>(
                    valueListenable: model.isTimerActive,
                    builder: (context, isTimerActive, child) => InkWell(
                      onTap: model.toggleTimer,
                      child: SvgPicture.asset(
                        isTimerActive
                            ? 'assets/svg/pause.svg'
                            : 'assets/svg/play.svg',
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: model.resetTimer,
                    child: SvgPicture.asset(
                      'assets/svg/replay.svg',
                    ),
                  ),
                  const SizedBox(width: kMainPadding),
                ],
              ),
            ),
          ),
  );
}

Widget dottedVerticalLine = DottedBorder(
  customPath: (_) => Path()
    ..moveTo(0, 0)
    ..lineTo(0, containerFullHeight),
  borderType: BorderType.RRect,
  dashPattern: const <double>[8, 8],
  color: AppColors.grey900,
  padding: EdgeInsets.zero,
  // strokeCap: StrokeCap,
  strokeWidth: 1,
  child: const SizedBox(
    height: containerFullHeight,
    width: 1,
  ),
);

Widget _dottedHorizontalLine = DottedBorder(
  customPath: (_) => Path()
    ..moveTo(0, 1)
    ..lineTo(fixedRowWidth, 0),
  borderType: BorderType.RRect,
  padding: EdgeInsets.zero,
  color: AppColors.grey900,
  dashPattern: const <double>[8, 8],
  strokeWidth: 1,
  child: const SizedBox(
    height: 1,
    width: fixedRowWidth,
  ),
);

Widget seperator() => Container(
      decoration: BoxDecoration(
        color: AppColors.grey800,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.6),
            spreadRadius: 0,
            blurRadius: 1.28,
            offset: const Offset(0.64, 0.96),
          ),
          BoxShadow(
            color: AppColors.black.withOpacity(0.6),
            spreadRadius: 0,
            blurRadius: 1.28,
            offset: const Offset(-0.256, -0.64),
          ),
        ],
        borderRadius: BorderRadius.circular(2.6),
      ),
      height: 2,
      width: 30,
    );

// ignore: must_be_immutable
class TaskWidget extends StatelessWidget {
  TaskWidget({
    this.task,
    required this.isFirstCell,
    this.editComment,
    this.isSelectedStudentToShuffle,
    super.key,
  });
  final Task? task;
  final bool isFirstCell;
  final VoidCallback? editComment;
  final bool? isSelectedStudentToShuffle;
  Emoji? emoji;

  @override
  Widget build(BuildContext context) {
    emoji = task != null ? getEmojiById(task?.emoji_id) : null;

    return Container(
      color: isSelectedStudentToShuffle ?? false
          ? AppColors.primary300
          : AppColors.white,
      height: containerFullHeight,
      width: fixedRowWidth,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isFirstCell) dottedVerticalLine,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (emoji != null) ...[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(kInternalPadding),
                          child: Image.asset(emoji!.emojiPath.iconPath),
                        ),
                      ),
                    ],
                    if (emoji == null) ...[
                      const Expanded(
                        child: Center(
                          child: Text(
                            '',
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ),
                      ),
                    ],
                    _dottedHorizontalLine,
                  ],
                ),
              ),
            ],
          ),
          if (task?.comment != null)
            Positioned.directional(
              textDirection: AppUtility.getTextDirectionality(),
              end: 2,
              top: 4,
              child: InkWell(
                onTap: editComment,
                child: SvgPicture.asset(
                  'assets/svg/notesIcon.svg',
                  height: 22,
                ),
              ),
            )
        ],
      ),
    );
  }
}
