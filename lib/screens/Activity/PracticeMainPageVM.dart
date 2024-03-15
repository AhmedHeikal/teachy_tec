import 'dart:async';
import 'package:flutter/material.dart';
import 'package:teachy_tec/models/CustomQuestionOptionModel.dart';
import 'package:teachy_tec/models/Student.dart';
import 'package:teachy_tec/models/Task.dart';
import 'package:teachy_tec/models/TaskViewModel.dart';
import 'package:teachy_tec/screens/Activity/DayTableVM.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/utils/SoundService.dart';
import 'package:collection/collection.dart';
import 'package:teachy_tec/widgets/BoardEmojisSelector.dart';

class PracticeMainPageVM extends ChangeNotifier {
  DayTableVM dayTableModel;
  String? currentAnswerValue;
  CustomQuestionOptionModel? currentSelectedOption;
  PracticeMainPageVM({required this.dayTableModel}) {
    updateSelectedOptionOnPageStart();
    dayTableModel.selectedShuffledStudent
        .addListener(updateSelectedOptionOnPageStart);
  }

  ValueNotifier<bool> isFeedBackShown = ValueNotifier(false);

  bool? getIsCurrentSelectedOptionIsCorrect() {
    var currentTaskForThisStudent = dayTableModel
        .studentsToTask[dayTableModel.selectedShuffledStudent.value?.id]
        ?.firstWhereOrNull(
            (task_) => task_.task == dayTableModel.currentSelectedTask!.task);
    return currentTaskForThisStudent?.isCorrectAnswerChosen;
  }

  void updateSelectedOptionOnPageStart() {
    var currentTaskForThisStudent = dayTableModel
        .studentsToTask[dayTableModel.selectedShuffledStudent.value?.id]
        ?.firstWhereOrNull(
            (task_) => task_.task == dayTableModel.currentSelectedTask!.task);

    // if (getSelectedTask()?.taskType == TaskType.textOnly) {
    //   dayTableModel.selectedEmoji =
    //       getEmojiById(currentTaskForThisStudent?.emoji_id);
    // }

    if (getSelectedTask()?.taskType == TaskType.textOnly) {
      if (currentTaskForThisStudent?.emoji_id != null) {
        dayTableModel.selectedEmoji =
            getEmojiById(currentTaskForThisStudent?.emoji_id);
      }

      currentAnswerValue = currentTaskForThisStudent?.enteredTextForCurrentTask;

      notifyListeners();
      return;
    }

    // if (currentTaskForThisStudent?.selectedOption == currentSelectedOption) {
    //   return;
    // }

    currentSelectedOption = currentTaskForThisStudent?.selectedOption;
    // currentSelectedOption = currentTaskForThisStudent?.selectedOption;

    // if (currentSelectedOption != null) {
    if (currentTaskForThisStudent?.emoji_id != null) {
      dayTableModel.selectedEmoji =
          getEmojiById(currentTaskForThisStudent?.emoji_id);
      // }
    }
    notifyListeners();
  }

  int? getCurrentQuestionIndex() {
    if (dayTableModel.currentSelectedTask != null) {
      var currentIndex = (dayTableModel.currentActivity.tasks
              ?.indexOf(dayTableModel.currentSelectedTask!) ??
          0);
      return currentIndex;
    }
    return null;
  }

  void restartScoreForTask(
      {required Student student, required Task task}) async {
    currentSelectedOption = null;
    dayTableModel.removeEmojiFromCell(
        student: student,
        task: Task(
          task: task.task,
          id: task.id,
          taskType: task.taskType,
        ));
    task.enteredTextForCurrentTask = null;
    currentAnswerValue = null;
    task.isCorrectAnswerChosen = null;
    task.selectedOption = null;
    await dayTableModel.updateCommentForStudet(
      student: student,
      task: task,
      comment: null,
    );

    notifyListeners();
  }

  void onSelectOption(CustomQuestionOptionModel? newlySelectedOption,
      {bool? selectedCorrectAnswer, String? text}) async {
    currentSelectedOption = newlySelectedOption;
    if (currentSelectedOption != null) {
      await Future.delayed(const Duration(milliseconds: 500), () async {
        isFeedBackShown.value = true;

        notifyListeners();
        await Future.delayed(const Duration(seconds: 2), () {
          isFeedBackShown.value = false;
          notifyListeners();
        });

        if (dayTableModel.selectedShuffledStudent.value == null) return;
        var returnedEmoji = await dayTableModel.showEmojisPicker(
          answerSubmittedType: currentSelectedOption?.isCorrect == true
              ? AnswerSubmittedType.showCorrectAnswerOptions
              : currentSelectedOption?.isCorrect == false
                  ? AnswerSubmittedType.showWrongAnswerOptions
                  : null,
          hideSpecifiedButtons: true,
        );
        setEmojiForCurrentTaskAndCurrentUser(
          returnedEmoji,
          isCorrectAnswerChosen: selectedCorrectAnswer,
          enteredText: text,
        );
      });
    } else {
      if (dayTableModel.selectedShuffledStudent.value == null) return;
      var returnedEmoji = await dayTableModel.showEmojisPicker(
        answerSubmittedType: AnswerSubmittedType.showFullAnswerOptions,
        hideSpecifiedButtons: true,
      );
      setEmojiForCurrentTaskAndCurrentUser(
        returnedEmoji,
        isCorrectAnswerChosen: selectedCorrectAnswer,
        enteredText: text,
      );
    }
  }

  void setEmojiForCurrentTaskAndCurrentUser(
    Emoji? returnedEmoji, {
    bool? isCorrectAnswerChosen,
    String? enteredText,
  }) {
    if (returnedEmoji != null) {
      if (returnedEmoji.soundType == SoundType.correct) {
        dayTableModel.correctEmojiSound();
      } else {
        dayTableModel.wrongEmojiSound();
      }

      dayTableModel.setEmojisToCell(
        student: dayTableModel.selectedShuffledStudent.value!,
        task: Task(
          task: dayTableModel.currentSelectedTask!.task,
          id: dayTableModel.currentSelectedTask!.id,
          grade_value: returnedEmoji.emojiPath.iconGrade.iconValue,
          emoji_id: returnedEmoji.id,
          isCorrectAnswerChosen: isCorrectAnswerChosen,
          enteredTextForCurrentTask: enteredText,
          selectedOption: currentSelectedOption,
          taskType: dayTableModel.currentSelectedTask?.taskType,
        ),
      );
    }
  }

  void goToNextQuestion() {
    if (!isNextQuestionButtonActive()) {
      return;
    }

    dayTableModel.onSelectQuestion(
        selectedTask: dayTableModel
            .currentActivity.tasks![(getCurrentQuestionIndex()!) + 1]);
    updateSelectedOptionOnPageStart();
  }

  void goToreviousQuestion() {
    if (!isPreviousQuestionButtonActive()) {
      return;
    }
    dayTableModel.onSelectQuestion(
        selectedTask: dayTableModel
            .currentActivity.tasks![(getCurrentQuestionIndex()!) - 1]);
    updateSelectedOptionOnPageStart();
  }

  bool isNextQuestionButtonActive() {
    var currentIndex = getCurrentQuestionIndex();
    return currentIndex != null &&
        (currentIndex + 1) < (dayTableModel.currentActivity.tasks?.length ?? 0);
  }

  TaskViewModel? getSelectedTask() {
    var currentTaskForThisStudent = dayTableModel.currentSelectedTask;

    // .studentsToTask[dayTableModel.selectedShuffledStudent.value?.id]
    // ?.firstWhereOrNull(
    //     (task_) => task_.task == dayTableModel.currentSelectedTask!.task);
    return currentTaskForThisStudent;
  }

  Task? getSelectedTaskForCurrentStudent() {
    var currentTaskForThisStudent = dayTableModel
        .studentsToTask[dayTableModel.selectedShuffledStudent.value?.id]
        ?.firstWhereOrNull(
            (task_) => task_.task == dayTableModel.currentSelectedTask!.task);
    return currentTaskForThisStudent;
  }

  AnswerSubmittedType? getAnswerTypeForCurrentTask() {
    return dayTableModel.selectedShuffledStudent.value == null
        ? null
        : (dayTableModel.currentSelectedTask?.taskType == TaskType.textOnly &&
                    getSelectedTaskForCurrentStudent()?.emoji_id != null) ||
                (currentSelectedOption?.isCorrect == null &&
                    getSelectedTaskForCurrentStudent()?.emoji_id != null)
            ? AnswerSubmittedType.showFullAnswerOptions
            : currentSelectedOption?.isCorrect == true
                ? AnswerSubmittedType.showCorrectAnswerOptions
                : currentSelectedOption?.isCorrect == false
                    ? AnswerSubmittedType.showWrongAnswerOptions
                    : null;
    // return dayTableModel.selectedShuffledStudent.value == null
    //     ? null
    //     : currentSelectedOption?.isCorrect == true
    //         ? AnswerSubmittedType.showCorrectAnswerOptions
    //         : currentSelectedOption?.isCorrect == false
    //             ? AnswerSubmittedType.showWrongAnswerOptions
    //             : dayTableModel.currentSelectedTask?.taskType ==
    //                         TaskType.textOnly &&
    //                     getSelectedTaskForCurrentStudent()?.emoji_id != null
    //                 ? AnswerSubmittedType.showFullAnswerOptions
    //                 : null;
  }

  bool isPreviousQuestionButtonActive() {
    var currentIndex = getCurrentQuestionIndex();
    return currentIndex != null && currentIndex != 0;
  }
}
