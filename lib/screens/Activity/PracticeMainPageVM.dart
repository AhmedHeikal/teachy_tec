import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teachy_tec/models/CustomQuestionOptionModel.dart';
import 'package:teachy_tec/models/Student.dart';
import 'package:teachy_tec/models/Task.dart';
import 'package:teachy_tec/screens/Activity/DayTableVM.dart';
import 'package:teachy_tec/utils/SoundService.dart';
import 'package:collection/collection.dart';
import 'package:teachy_tec/widgets/BoardEmojisSelector.dart';

class PracticeMainPageVM extends ChangeNotifier {
  DayTableVM dayTableModel;
  CustomQuestionOptionModel? currentSelectedOption;
  PracticeMainPageVM({required this.dayTableModel}) {
    updateSelectedOptionOnPageStart();
    dayTableModel.selectedShuffledStudent
        .addListener(updateSelectedOptionOnPageStart);
  }

  ValueNotifier<bool> isFeedBackShown = ValueNotifier(false);

  void updateSelectedOptionOnPageStart() {
    var currentTaskForThisStudent = dayTableModel
        .studentsToTask[dayTableModel.selectedShuffledStudent.value?.id]
        ?.firstWhereOrNull(
            (task_) => task_.task == dayTableModel.currentSelectedTask!.task);
    if (currentTaskForThisStudent?.selectedOption == currentSelectedOption) {
      return;
    }
    currentSelectedOption = currentTaskForThisStudent?.selectedOption;

    if (currentSelectedOption != null) {
      if (currentTaskForThisStudent?.emoji_id != null) {
        dayTableModel.selectedEmoji =
            getEmojiById(currentTaskForThisStudent?.emoji_id);
      }
      notifyListeners();
    }
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
        ));

    await dayTableModel.updateCommentForStudet(
        student: student, task: task, comment: null);

    notifyListeners();
  }

  void onSelectOption(CustomQuestionOptionModel? newlySelectedOption) async {
    currentSelectedOption = newlySelectedOption;

    await Future.delayed(const Duration(milliseconds: 500), () async {
      isFeedBackShown.value = true;

      notifyListeners();
      await Future.delayed(const Duration(seconds: 2), () {
        isFeedBackShown.value = false;
        notifyListeners();
      });
      if (dayTableModel.selectedShuffledStudent.value == null) return;
      var returnedEmoji = await dayTableModel.showEmojisPicker(
          isCorrectAnswerChosenInPracticePage: newlySelectedOption?.isCorrect);
      setEmojiForCurrentTaskAndCurrentUser(returnedEmoji);
      // }
    });

    // Future.delayed(Duration(seconds: 2), () {
    //   Timer(const Duration(milliseconds: 500), () {
    //     isFeedBackShown.value = false; // Set the flag to hide the item
    //   });
    // });
  }

  void setEmojiForCurrentTaskAndCurrentUser(Emoji? returnedEmoji) {
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
          selectedOption: currentSelectedOption,
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

    // notifyListeners();
  }

  void goToreviousQuestion() {
    if (!isPreviousQuestionButtonActive()) {
      return;
    }
    dayTableModel.onSelectQuestion(
        selectedTask: dayTableModel
            .currentActivity.tasks![(getCurrentQuestionIndex()!) - 1]);
    updateSelectedOptionOnPageStart();

    // notifyListeners();
  }

  bool isNextQuestionButtonActive() {
    var currentIndex = getCurrentQuestionIndex();
    return currentIndex != null &&
        (currentIndex + 1) < (dayTableModel.currentActivity.tasks?.length ?? 0);
  }

  bool isPreviousQuestionButtonActive() {
    var currentIndex = getCurrentQuestionIndex();
    return currentIndex != null && currentIndex != 0;
  }
}
