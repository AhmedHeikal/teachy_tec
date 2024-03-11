import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:teachy_tec/hive/controllers/activityController.dart';
import 'package:teachy_tec/hive/controllers/activityStudentsController.dart';
import 'package:teachy_tec/models/Activity.dart';
import 'package:teachy_tec/models/ActivityStudents.dart';
import 'package:teachy_tec/models/Student.dart';
import 'package:teachy_tec/models/Task.dart';
import 'package:teachy_tec/models/TaskViewModel.dart';
import 'package:teachy_tec/screens/Activity/ActivityForm.dart';
import 'package:teachy_tec/screens/Activity/ActivityFormVM.dart';
import 'package:teachy_tec/screens/Activity/AddNewItemToDayTable.dart';
import 'package:teachy_tec/screens/Activity/AddNewItemToDayTableVM.dart';
import 'package:teachy_tec/screens/Activity/DayTable.dart';
import 'package:teachy_tec/screens/Activity/NoteFormForCellInDayTable.dart';
import 'package:teachy_tec/screens/Activity/NoteFormForCellInDayTableVM.dart';
import 'package:teachy_tec/screens/Activity/PracticeMainPage.dart';
import 'package:teachy_tec/screens/Activity/PracticeMainPageVM.dart';
import 'package:teachy_tec/screens/networking/AppNetworkProvider.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/utils/Routing/AppAnalyticsConstants.dart';
import 'package:teachy_tec/utils/SoundService.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';
import 'package:teachy_tec/widgets/BoardEmojisSelector.dart';
import 'package:teachy_tec/widgets/Popups/restartShuffledStudentsPopup.dart';
import 'package:vibration/vibration.dart';

class DayTableVM extends ChangeNotifier {
  bool isLoading = true;
  bool isScheduleOpen = false;
  bool isCreatingNewShift = false;
  ValueNotifier<int> currentTimerValue = ValueNotifier(120);
  int latestTimerSetValue = 120;
  Timer? _timer;
  Emoji? selectedEmoji;
  ValueNotifier<bool> isTimerOpen = ValueNotifier(false);
  ValueNotifier<bool> isTimerActive = ValueNotifier(false);
  ValueNotifier<bool> showActivityInfo = ValueNotifier(false);
  ValueNotifier<bool> showFortuneWheel = ValueNotifier(false);
  Activity currentActivity;
  Offset? position;
  Map<String, List<Task>> studentsToTask = {};
  ValueNotifier<Student?> selectedShuffledStudent = ValueNotifier(null);
  List<Student> shuffledStudents = [];
  ScrollController rowsScrollController = ScrollController();
  ScrollController columnsScrollController = ScrollController();
  ScrollController mainAxisController = ScrollController();
  // String? selectedQuestion;
  int? currentStudentIndex;
  final player = AudioPlayer();
  final emojisPlayer = AudioPlayer();

  TaskViewModel? currentSelectedTask;

  // to track if it was in the practice page
  bool isInPracticePage = false;

// fastTimer boolean -> set it on the last period of timer and toggle it when timer finishes
  bool isFastTimerSoundRunning = false;
  DayTableVM(
      {required this.currentActivity,
      Map<String, List<Task>>? studentsToTaskMap}) {
    studentsToTask = studentsToTaskMap ?? {};
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   // player.pause();
  //   // player.dispose();
  //   // TODO: implement dispose
  // }

  void editComment({required Student student, required Task? task}) async {
    var returnedNote = await UIRouter.showAppBottomDrawerWithCustomWidget(
      child: NoteFormForCellInDayTable(
        model: NoteFormForCellInDayTableVM.edit(oldModel: task),
        onDeleteTapped: () async {
          UIRouter.showEasyLoader();
          await updateCommentForStudet(
              student: student, task: task!, comment: null);
          UIRouter.popScreen(rootNavigator: true);

          EasyLoading.dismiss(animation: true);
        },
      ),
    );

    if (returnedNote == null) return;
    await updateCommentForStudet(student: student, task: task!, comment: null);

    // if (studentsToTask[student.id] == null) {
    //   studentsToTask[student.id!] = [];
    // }

    // var currentIndex = studentsToTask[student.id]!
    //     .indexWhere((task_) => task?.task == task_.task);

    // if (currentIndex == -1) {
    //   studentsToTask[student.id]!.add(task?.comment = returnedNote);
    // } else {
    //   var currentTask = studentsToTask[student.id]![currentIndex]
    //     ..comment = returnedNote;
    //   studentsToTask[student.id]![currentIndex] = currentTask;
    // }
    // notifyListeners();
  }

  void toggleActivityInfo() {
    showActivityInfo.value = !showActivityInfo.value;
  }

  // void controlQuestionPreview(String? selectedTask) {
  //   selectedQuestion = selectedTask;
  //   notifyListeners();
  // }

  void onSelectQuestion({required TaskViewModel selectedTask}) async {
    currentSelectedTask = selectedTask;
    notifyListeners();
  }

  void onTaskTap({required TaskViewModel selectedTask}) async {
    isInPracticePage = true;
    onSelectQuestion(selectedTask: selectedTask);

    await UIRouter.pushScreen(
            PracticeMainPage(
              model: PracticeMainPageVM(dayTableModel: this),
            ),
            pageName: AppAnalyticsConstants.PracticeMainPage)
        .then((value) {
      isInPracticePage = false;
      notifyListeners();
    });
  }

  List<Student> getStudentsToShuffle() {
    List<Student> newList = [...currentActivity.students ?? []];
    newList.removeWhere((element) => shuffledStudents.contains(element));
    return newList;
  }

  Future<void> onEditTapped() async {
    var currentItem = await UIRouter.pushScreen(
      ActivityForm(
        model: ActivityFormVM.edit(
            pageDate: currentActivity.timestamp,
            oldModel: currentActivity,
            onClearStudentGradesCallBack: () async {
              var currentStudentActivity =
                  await ActivityStudentsController().getSingleActivityStudents(
                activityId: currentActivity.id,
              );

              Map<String, List<Task>> studentsToTaskMap = {};
              currentStudentActivity?.studentTasks.forEach((key, value) {
                studentsToTaskMap[key] = value;
              });

              studentsToTask = studentsToTaskMap;
              notifyListeners();
            }),
      ),
      pageName: AppAnalyticsConstants.ActivityForm,
    );

    if (currentItem != null) {
      currentActivity = currentItem[0] as Activity;
      studentsToTask = (currentItem[1] as ActivityStudents).studentTasks;
      ActivityStudentsController().updateSingleActivtyStudents(
          singleActivityStudent: currentItem[1] as ActivityStudents);
      notifyListeners();
    }
  }

  void setWidgetOffset(Offset offset) {
    position = offset;
    notifyListeners();
  }

  void removeEmojiFromCell(
      {required Student student, required Task task}) async {
    if (studentsToTask[student.id] == null) return;
    // studentsToTask[student.name]!
    //     .removeWhere((task_) => task.task == task_.task);
    var currentIndex = studentsToTask[student.id]!
        .indexWhere((task_) => task.task == task_.task);

    studentsToTask[student.id]![currentIndex]
      ..emoji_id = null
      ..grade_value = null;
    // studentsToTask[student.name]![currentIndex] = currentTask;
    await updateStudentTasksInDb(
        student: student, tasks: studentsToTask[student.id] ?? []);

    notifyListeners();
  }
//   function (){print("Heikal");}
// thisIsFunction () => print("Heikal");

  Student? getRandomStudent() {
    if (currentActivity.students?.length == shuffledStudents.length) {
      // Add a message to start over
      return null;
    }
    // generates a new Random object
    final random = Random();

    var newStudentsList = [];
    currentActivity.students?.forEach(
      (element) {
        if (!shuffledStudents.contains(element)) {
          newStudentsList.add(element);
        }
      },
    );

    // generate a random index based on the list length
    // and use it to retrieve the element
    var selectedStudent =
        newStudentsList[random.nextInt(newStudentsList.length)];

    // shuffledStudents.add(selectedStudent);
    return selectedStudent;
  }

  void restartShuffling() {
    shuffledStudents = [];
    notifyListeners();
  }

  void onSelectShuffledStudent({Student? selectedStudentFromWheel}) {
    if (currentActivity.students == null) return;

    Student? selectedStudent;
    if (selectedStudentFromWheel == null) {
      selectedStudent = getRandomStudent();
    } else {
      selectedStudent = selectedStudentFromWheel;
    }

    if (selectedStudent == null) return;
    shuffledStudents.add(selectedStudent);
    selectedShuffledStudent.value = selectedStudent;

    currentStudentIndex = currentActivity.students!.indexWhere(
        (element) => element.name == selectedShuffledStudent.value?.name);

    mainAxisController.jumpTo(currentStudentIndex! * (containerFullHeight));

    showFortuneWheel.value = true;
    notifyListeners();
  }

  // bool _mPlayerIsInited = false;

  void emojiVibartion({required VibrationItem vb}) {
    Vibration.vibrate(
      duration: vb.duration,
      intensities: vb.intensities,
      repeat: vb.repeat,
      amplitude: vb.amplitude,
    );
    // You can adjust the duration as needed
  }

  void correctEmojiSound() async {
    if (emojisPlayer.state == PlayerState.playing) {
      await stopEmojisPlayer();
    }

    var currentSound =
        AppUtility.selectRandomItem<SoundItem>(SoundService.correctSounds);
    emojiVibartion(vb: currentSound.vibration);
    await emojisPlayer.play(AssetSource(currentSound.path));
  }

  void wrongEmojiSound() async {
    if (emojisPlayer.state == PlayerState.playing) {
      await stopEmojisPlayer();
    }
    var currentSound =
        AppUtility.selectRandomItem<SoundItem>(SoundService.wrongSounds);

    emojiVibartion(vb: currentSound.vibration);
    await player.play(AssetSource(currentSound.path));
  }

  void eraserEmojiSound() async {
    if (player.state == PlayerState.playing) {
      await stopEmojisPlayer();
    }

    var currentSound = SoundService.eraser();
    emojiVibartion(vb: currentSound.vibration);
    await emojisPlayer.play(AssetSource(currentSound.path));
    // setState(() {});
  }

  void noteEmojiSound() async {
    var currentSound = SoundService.note();
    emojiVibartion(vb: currentSound.vibration);
    await emojisPlayer.play(AssetSource(currentSound.path));
  }

  Future<void> stopEmojisPlayer() async {
    await emojisPlayer.stop();
  }

  // RegisterListenerOnStudentChange(Function() func) {
  //   _draftedChecklists.removeListener(func);
  //   _draftedChecklists.addListener(func);
  // }

  void showShuffleOverlay() {
    var currentStudentsToShuffle = getStudentsToShuffle();
    // if (currentStudentsToShuffle.isEmpty) {
    //   UIRouter.showAppBottomDrawerWithCustomWidget(
    //       child: RestartShuffledStudentsPopup(onConfirmTapped: () {
    //     restartShuffling();
    //     UIRouter.popScreen();
    //     showShuffleOverlay();
    //   }));
    //   return;
    // } else

    if (currentStudentsToShuffle.length == 1) {
      UIRouter.showAppBottomDrawerWithCustomWidget(
          child: RestartShuffledStudentsPopup(onConfirmTapped: () {
        restartShuffling();
        UIRouter.popScreen();
        showShuffleOverlay();
      }));
      return;

      // resetTimer();
      // // startRollerSound();
      // onSelectShuffledStudent(
      //     selectedStudentFromWheel: currentStudentsToShuffle.first);
      // notifyListeners();
      // return;
    }
    resetTimer();
    startRollerSound();
    showFortuneWheel.value = true;
    notifyListeners();
  }

  void removeShuffledStudentAndExitShuffle() {
    selectedShuffledStudent.value = null;
    notifyListeners();
  }

  void removeShuffle() {
    stopPlayer();
    showFortuneWheel.value = false;
  }

  Future<void> addNewItem() async {
    var currentArgumentReturned =
        await UIRouter.showAppBottomDrawerWithCustomWidget(
      child: AddNewItemToDayTable(
        model: AddNewItemToDayTableVM(),
      ),
    );
    if (currentArgumentReturned is Student) {
      currentActivity.students == null
          ? currentActivity.students = [currentArgumentReturned]
          : currentActivity.students!.add(currentArgumentReturned);

      await serviceLocator<AppNetworkProvider>().addStudents(
          students: [currentArgumentReturned],
          classId: currentActivity.currentClass!.id ?? '');

      ActivityController().updateSingleActivty(singleActivity: currentActivity);
      notifyListeners();
    } else if (currentArgumentReturned is TaskViewModel) {
      try {
        UIRouter.showEasyLoader();

        var updatedTask =
            await serviceLocator<AppNetworkProvider>().addNewTaskToActivity(
          activityId: currentActivity.id,
          classId: currentActivity.currentClass!.id ?? '',
          task: currentArgumentReturned,
          taskIndex: (currentActivity.tasks?.length ?? 1) - 1,
        );

        if (updatedTask == null) {
          EasyLoading.dismiss(animation: true);
          return;
        }
        currentActivity.tasks == null
            ? currentActivity.tasks = [updatedTask]
            : currentActivity.tasks!.add(updatedTask);

        // currentActivity.students ??= [];
        // currentActivity.students?.addAll(addedStudents);
        ActivityController()
            .updateSingleActivty(singleActivity: currentActivity);
      } finally {
        EasyLoading.dismiss(animation: true);
        notifyListeners();
      }
    } else {
      return;
    }
  }

  Future<void> addNotes({required Student student, required Task task}) async {
    var returnedNote = await UIRouter.showAppBottomDrawerWithCustomWidget(
      child: NoteFormForCellInDayTable(
        model: NoteFormForCellInDayTableVM(),
        onDeleteTapped: () async {
          UIRouter.showEasyLoader();
          await updateCommentForStudet(
              student: student, task: task, comment: null);
          UIRouter.popScreen(rootNavigator: true);
          EasyLoading.dismiss(animation: true);
        },
      ),
    );

    if (returnedNote == null) return;
    updateCommentForStudet(student: student, task: task, comment: returnedNote);
  }

  Future<void> updateCommentForStudet(
      {required Student student,
      required Task task,
      required String? comment}) async {
    if (studentsToTask[student.id] == null) {
      studentsToTask[student.id!] = [];
    }

    var currentIndex = studentsToTask[student.id]!
        .indexWhere((task_) => task.task == task_.task);

    if (currentIndex == -1) {
      studentsToTask[student.id]!.add(task..comment = comment);
    } else {
      var currentTask = studentsToTask[student.id]![currentIndex]
        ..comment = comment;
      studentsToTask[student.id]![currentIndex] = currentTask;
    }

    await updateStudentTasksInDb(
        student: student, tasks: studentsToTask[student.id] ?? []);
    notifyListeners();
  }

  Future<void> updateStudentTasksInDb(
      {required Student student, required List<Task> tasks}) async {
    await ActivityStudentsController().updateTasksForStudentInActivityStudents(
      activityId: currentActivity.id,
      classId: currentActivity.currentClass!.id!,
      timestamp: currentActivity.timestamp,
      studentId: student.id ?? '0',
      studentUpdatedTasks: tasks,
    );
  }

  void setEmojisToCell({required Student student, required Task task}) async {
    if (studentsToTask[student.id] == null) {
      studentsToTask[student.id!] = [];
    }

    var currentIndex = studentsToTask[student.id]!
        .indexWhere((task_) => task.task == task_.task);

    if (currentIndex == -1) {
      studentsToTask[student.id]!.add(task);
    } else {
      // var currentTask = studentsToTask[student.name]![currentIndex]
      //   ..comment = returnedNote;
      studentsToTask[student.id]![currentIndex] = task
        ..comment = studentsToTask[student.id]![currentIndex].comment;
    }
    await updateStudentTasksInDb(
        student: student, tasks: studentsToTask[student.id] ?? []);
    notifyListeners();
  }

  void toggleSchedule({bool? scheduleInfoState}) {
    if (scheduleInfoState != null && scheduleInfoState == isScheduleOpen) {
      return;
    }

    if (scheduleInfoState != null) {
      isScheduleOpen = scheduleInfoState;
    } else {
      isScheduleOpen = !isScheduleOpen;
    }
    notifyListeners();
  }

  Future<Emoji?> showEmojisPicker({
    bool? isCorrectAnswerChosenInPracticePage,
    Function(Emoji)? onEmojiSelected,
  }) async {
    Emoji? returnedEmoji;
    await UIRouter.showAppBottomDrawerWithCustomWidget(
      child: BoardEmojisSelector(
        isCorrectAnswerChosenInPracticePage:
            isCorrectAnswerChosenInPracticePage,
        onSelectEmoji: (selectedEmoji) {
          this.selectedEmoji = selectedEmoji;
          if (onEmojiSelected != null) {
            onEmojiSelected(selectedEmoji);
          }
          // We created new variable and not return the variable that exists in this model
          // as if there was an emoji that was already chosen to not be returned;
          returnedEmoji = selectedEmoji;
          UIRouter.popScreen(rootNavigator: true);
          notifyListeners();
        },
      ),
    );
    return returnedEmoji;
  }

  void toggleTimerOpen({bool? isTimerOpen}) {
    this.isTimerOpen.value = isTimerOpen ?? !this.isTimerOpen.value;
  }

  void resetTimer() {
    _timer?.cancel();
    currentTimerValue.value = latestTimerSetValue;
    isTimerActive.value = false;
    stopPlayer();
  }

  void setTimerValue(int timervalue) {
    _timer?.cancel();
    latestTimerSetValue = timervalue;
    currentTimerValue.value = timervalue;
  }

  void startTimer() {
    isTimerActive.value = true;
    startTimerSound();
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (currentTimerValue.value <= 6 && currentTimerValue.value > 1) {
          startFastTimerSound();
        }
        if (currentTimerValue.value == 1) {
          timerEndsSound();
        }

        if (currentTimerValue.value == 0) {
          resetTimer();
          // stopPlayer();
        } else {
          --currentTimerValue.value;
        }
      },
    );
  }

  Future<void> stopPlayer() async {
    await player.stop();
    isFastTimerSoundRunning = false;
  }

  void startTimerSound() async {
    if (player.state == PlayerState.playing) {
      await stopPlayer();
    }
    player.setReleaseMode(ReleaseMode.loop);

    var currentSound = SoundItem(
        path: 'sounds/tickingTimer.mp3',
        type: SoundType.correct,
        vibration: VibrationItem(duration: 50));
    // emojiVibartion(vb: currentSound.vibration);
    await player.play(AssetSource(currentSound.path));
  }

  void startRollerSound() async {
    if (player.state == PlayerState.playing) {
      await stopPlayer();
    }
    player.setReleaseMode(ReleaseMode.stop);

    var currentSound = SoundItem(
      path: 'sounds/fortuneWheelSound.mp3',
      type: SoundType.correct,
      vibration: VibrationItem(duration: 50),
    );
    await player.play(AssetSource(currentSound.path));
  }

  void startFastTimerSound() async {
    if (isFastTimerSoundRunning == true) return;
    if (player.state == PlayerState.playing) {
      await stopPlayer();
    }
    player.setReleaseMode(ReleaseMode.loop);
    isFastTimerSoundRunning = true;
    var currentSound = SoundItem(
        path: 'sounds/fastTimerSound.mp3',
        type: SoundType.correct,
        vibration: VibrationItem(duration: 50));
    // emojiVibartion(vb: currentSound.vibration);
    await player.play(AssetSource(currentSound.path));
  }

  void timerEndsSound() async {
    // if (isFastTimerSoundRunning == true) return;
    if (player.state == PlayerState.playing) {
      await stopPlayer();
    }
    player.setReleaseMode(ReleaseMode.stop);
    isFastTimerSoundRunning = true;
    var currentSound = SoundItem(
        path: 'sounds/timerEnds.mp3',
        type: SoundType.correct,
        vibration: VibrationItem(duration: 50));
    // emojiVibartion(vb: currentSound.vibration);
    await player.play(AssetSource(currentSound.path));
  }

  // void stopPlayerSound() async {
  //   if (player.state == PlayerState.playing) {
  //     await stopPlayer();
  //   }
  //   // player.setReleaseMode(ReleaseMode.loop);
  // }

  void toggleTimer() async {
    // currentTimerValue.value = 120;
    if (_timer?.isActive ?? false) {
      await stopPlayer();

      _timer?.cancel();
      isTimerActive.value = false;
    } else {
      startTimer();
    }
  }
}
