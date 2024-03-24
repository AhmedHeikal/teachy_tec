import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:teachy_tec/hive/controllers/activityController.dart';
import 'package:teachy_tec/hive/controllers/activityStudentsController.dart';
import 'package:teachy_tec/models/Activity.dart';
import 'package:teachy_tec/models/ActivityStudents.dart';
import 'package:teachy_tec/models/Class.dart';
import 'package:teachy_tec/models/CustomQuestionOptionModel.dart';
import 'package:teachy_tec/models/Student.dart';
import 'package:teachy_tec/models/TaskViewModel.dart';
import 'package:teachy_tec/screens/Activity/CustomQuestionComponentVM.dart';
import 'package:teachy_tec/screens/Activity/DayTable.dart';
import 'package:teachy_tec/screens/Activity/DayTableVM.dart';
import 'package:teachy_tec/screens/networking/AppNetworkProvider.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/utils/Routing/AppAnalyticsConstants.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';
import 'package:teachy_tec/widgets/FormParentClass.dart';
import 'package:collection/collection.dart';
import 'package:teachy_tec/widgets/Popups/ClearStudentGradesRequest.dart';

class ActivityFormVM extends ChangeNotifier with FormParentClass {
  int pageDate;
  Class? selectedClass;
  ValueNotifier<bool> isClassesLoading = ValueNotifier(false);
  List<Class>? classes;
  // var optionsModel = CustomQuestionFormVM.add();

  CustomQuestionComponentVM customQuestionVM = CustomQuestionComponentVM();

  VoidCallback? onClearStudentGradesCallBack;

  late int selectedTimeInLocal;
  late int selectedTimeInUTC;
  void Function(Activity)? onAddNewActivity;
  List<CustomQuestionOptionModel> oldTasks = [];
  Activity? oldModel;
  bool isInDuplicateMood = false;
  ActivityFormVM(
      {required this.pageDate, this.classes, required this.onAddNewActivity}) {
    if (classes == null) {
      getClassesList();
    }

    selectedTimeInLocal = 37800;
    selectedTimeInUTC = selectedTimeInLocal;
  }

  bool? isTasksReadOnlyInEditMode;
  ActivityFormVM.edit(
      {required this.pageDate,
      required this.oldModel,
      required this.onClearStudentGradesCallBack}) {
    getClassesList(selectFirstClass: false).then((value) {
      onSelectClass(oldModel!.currentClass?.name ?? value.first.name);
    });

    selectedTimeInLocal = oldModel!.time;
    selectedTimeInUTC = selectedTimeInLocal;
    // gradeLevel = oldModel!.gradeLevel;
    // department = oldModel!.department;
    // selectedClass = oldModel!.currentClass;

    validateIsQuestionsReadOnlyInEditMode().then((value) {
      if ((oldModel!.tasks?.length ?? 0) > 0) {
        customQuestionVM.initialQuestionsListFromOldModel(oldModel!.tasks);
        notifyListeners();
      }
    });
  }

  ActivityFormVM.duplicate({required this.pageDate, required Activity model}) {
    getClassesList(selectFirstClass: false).then((value) {
      onSelectClass(model.currentClass?.name ?? value.first.name);
    });

    isInDuplicateMood = true;
    selectedTimeInLocal = model.time;
    selectedTimeInUTC = selectedTimeInLocal;
    // gradeLevel = oldModel!.gradeLevel;
    // department = oldModel!.department;
    // selectedClass = oldModel!.currentClass;

    if ((model.tasks?.length ?? 0) > 0) {
      customQuestionVM.initialQuestionsListFromOldModel(model.tasks);
      notifyListeners();
    }
  }

  Future<void> validateIsQuestionsReadOnlyInEditMode() async {
    var currentactivityStudents = await ActivityStudentsController()
        .getSingleActivityStudents(activityId: oldModel!.id);
    if (currentactivityStudents?.studentTasks.values.any(
            (element) => element.any((element) => element.emoji_id != null)) ??
        false) {
      isTasksReadOnlyInEditMode = true;
      customQuestionVM
          .updateTasksReadOnlyInEditMode(isTasksReadOnlyInEditMode!);
      notifyListeners();
      return;
    }
  }

  onSelectTime(int seconds, int secondsInLocalTime) {
    selectedTimeInUTC = seconds;
    selectedTimeInLocal = secondsInLocalTime;
    notifyListeners();
  }

  Future<void> addNewClassToTeacher() async {
    final newClass = <String, String?>{
      // FirestoreConstants.gradeLevel: gradeLevel,
      // FirestoreConstants.department: department,
    };

    await serviceLocator<FirebaseFirestore>()
        .collection(FirestoreConstants.classes)
        .doc()
        .set(newClass)
        .onError((e, _) => debugPrint("Error writing document: $e"));

    await serviceLocator<FirebaseFirestore>()
        .collection(FirestoreConstants.teacherClasses)
        .doc(serviceLocator<FirebaseAuth>().currentUser!.uid)
        .set({
      FirestoreConstants.classes: FieldValue.arrayUnion([newClass]),
    }, SetOptions(merge: true)).onError(
            (e, _) => debugPrint("Error writing document: $e"));
  }

  void onSelectClass(String selectedClassName) {
    selectedClass = classes?.firstWhereOrNull((element) =>
        element.name.trim().toLowerCase() ==
        selectedClassName.trim().toLowerCase());
    notifyListeners();
  }

  void setPageDate(DateTime pageDate) {
    this.pageDate = DateUtils.dateOnly(pageDate).millisecondsSinceEpoch;
    notifyListeners();
  }

  Future<List<Class>> getClassesList({bool selectFirstClass = true}) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isClassesLoading.value = true;
    });
    classes = await serviceLocator<AppNetworkProvider>().getClassesList();
    if (classes == null) return [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isClassesLoading.value = false;
    });
    if (selectFirstClass) {
      selectedClass = classes!.isNotEmpty ? classes!.first : null;
    }
    notifyListeners();

    return classes!;
  }

  Future<void> addNewActivityToTeacher() async {
    if (!validateForm() || !customQuestionVM.validateAllForms()) return;
    UIRouter.showEasyLoader();
    // Step 1: Prepare data for the new activity

    DocumentReference activityDocRef = FirebaseFirestore.instance
        .collection(FirestoreConstants.activity)
        .doc(serviceLocator<FirebaseAuth>().currentUser!.uid)
        .collection(FirestoreConstants.activities)
        .doc();

    var questionEvaluations = [];
    var studentsData = {};

    // TODO change for newTask details
    var tasks = customQuestionVM.submitForms();

    // var questionEvaluations = [];
    var tasksIndex = 0;
    for (var task in tasks) {
      Map<String, dynamic> taskData = {
        FirestoreConstants.id: task.id,
        FirestoreConstants.task: task.task,
        FirestoreConstants.taskType: task.taskType?.jsonValue,
        // Add other task data here if needed
      };

      // Upload media file associated with option, if any
      if (task.imagePathLocally != null) {
        String optionMediaUrl = await serviceLocator<AppNetworkProvider>()
            .uploadActivityFile(activityDocRef.id, 'tasks${task.id}$tasksIndex',
                File(task.imagePathLocally!));
        taskData[FirestoreConstants.downloadUrl] = optionMediaUrl;
        task.downloadUrl = optionMediaUrl;
      } else if (isInDuplicateMood && task.downloadUrl != null) {
        String optionMediaUrl = await serviceLocator<AppNetworkProvider>()
            .uploadActivityFileWithURL(activityDocRef.id,
                'tasks${task.id}$tasksIndex', task.downloadUrl!);
        taskData[FirestoreConstants.downloadUrl] = optionMediaUrl;
        task.downloadUrl = optionMediaUrl;
      }

      // Store options data
      var optionsData = [];
      var optionIndex = 0;
      for (CustomQuestionOptionModel option in task.options ?? []) {
        var optionData = {
          FirestoreConstants.name: option.name,
          FirestoreConstants.isCorrect: option.isCorrect,
          FirestoreConstants.id: option.id,
          // Add other option data here if needed
        };

        // Upload media file associated with option, if any
        if (option.filePathLocally != null) {
          String optionMediaUrl = await serviceLocator<AppNetworkProvider>()
              .uploadActivityFile(
                  activityDocRef.id,
                  'options${task.id}$optionIndex',
                  File(option.filePathLocally!));
          optionData[FirestoreConstants.downloadUrl] = optionMediaUrl;
          option.downloadUrl = optionMediaUrl;
        } else if (isInDuplicateMood && option.downloadUrl != null) {
          String optionMediaUrl = await serviceLocator<AppNetworkProvider>()
              .uploadActivityFileWithURL(activityDocRef.id,
                  'options${task.id}$optionIndex', option.downloadUrl!);
          optionData[FirestoreConstants.downloadUrl] = optionMediaUrl;
          option.downloadUrl = optionMediaUrl;
        }

        optionsData.add(optionData);
        optionIndex++;
      }

      taskData[FirestoreConstants.options] = optionsData;
      questionEvaluations.add(taskData);
      tasksIndex++;
    }

    var newActivity = {
      FirestoreConstants.id: activityDocRef.id,
      FirestoreConstants.Kclass: selectedClass?.toJson(),
      FirestoreConstants.timestamp:
          DateTime.fromMillisecondsSinceEpoch(pageDate).toString(),
      FirestoreConstants.time: selectedTimeInUTC,
      FirestoreConstants.tasks: questionEvaluations,
    };

    List<Map<String, dynamic>> studentsQuestionEvaluations = [];
    // TODO change for newTask details
    for (var task in tasks) {
      studentsQuestionEvaluations.add({
        FirestoreConstants.id: task.id,
        FirestoreConstants.task: task.task,
        FirestoreConstants.taskType: task.taskType?.jsonValue,
        FirestoreConstants.selectedOption: '',
        FirestoreConstants.gradeValue: '',
        FirestoreConstants.emojId: '',
        FirestoreConstants.comment: '',
      });
    }

    var studentsInClass = await serviceLocator<AppNetworkProvider>()
        .getStudentsInClass(classId: selectedClass?.id ?? '');

    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Step 2: Add the new activity to the 'activity' collection
      batch.set(activityDocRef, newActivity);
      // Add the activity ID to newActivity
      newActivity = newActivity
        ..addAll({FirestoreConstants.id: activityDocRef.id});

      DocumentReference classActivityDocRef = FirebaseFirestore.instance
          .collection(FirestoreConstants.classActivities)
          .doc(selectedClass!.id)
          .collection(FirestoreConstants.activities)
          .doc(activityDocRef.id);
      // Step 3: Add the activity to the 'classActivities' collection
      batch.set(classActivityDocRef, newActivity);

      // Get a reference to the Firestore document
      DocumentReference teacherActivitiesDocRef = FirebaseFirestore.instance
          .collection(FirestoreConstants.teacherActivities)
          .doc(serviceLocator<FirebaseAuth>().currentUser!.uid);

      // Create a reference to the new collection inside the document
      // CollectionReference newCollection =
      //     teacherActivitiesDocRef.collection(((pageDate) ~/ 1000).toString());
      CollectionReference newCollection =
          teacherActivitiesDocRef.collection(((pageDate)).toString());

      // Add documents to the new collection
      batch.set(newCollection.doc(activityDocRef.id),
          {activityDocRef.id: newActivity});

      // Step 4: Add student-specific data to 'activityStudents' collection
      for (Student student in studentsInClass) {
        studentsData[student.id!] = studentsQuestionEvaluations;
      }

      var activityStudentsDocRef = FirebaseFirestore.instance
          .collection(FirestoreConstants.activityStudents)
          .doc(activityDocRef.id);

      batch.set(
        activityStudentsDocRef,
        {
          FirestoreConstants.activityId: activityDocRef.id,
          FirestoreConstants.students: FieldValue.arrayUnion([studentsData]),
          FirestoreConstants.classId: selectedClass?.id,
          FirestoreConstants.timestamp: pageDate,
        },
        SetOptions(merge: true),
      );
      // Commit the batched write
      await batch.commit().then((_) async {
        debugPrint('Batch write successful');

        var activity = Activity(
          id: activityDocRef.id,
          tasks: tasks,
          students: studentsInClass,
          currentClass: selectedClass,
          timestamp: pageDate,
          time: selectedTimeInUTC,
        );

        ActivityController activityController = ActivityController();
        await activityController.updateSingleActivty(singleActivity: activity);
        if (onAddNewActivity != null) onAddNewActivity!(activity);
        UIRouter.pushReplacementScreen(
          DayTable(model: DayTableVM(currentActivity: activity)),
          pageName: AppAnalyticsConstants.DayTableScreen,
        );
      }).catchError((error) {
        debugPrint('Error during batch write: $error');
        FirebaseCrashlytics.instance.recordError(error, null,
            fatal: false,
            reason:
                "Heikal - addNewActivityToTeacher failed in ActivityFormVM \ncurrentUID ${serviceLocator<FirebaseAuth>().currentUser?.uid} ");
      });

      debugPrint(
          'New activity and related data added to Firestore successfully');
    } catch (e) {
      debugPrint('Error occurred while adding new activity and data: $e');

      FirebaseCrashlytics.instance.recordError(e, null,
          fatal: false,
          reason:
              "Heikal - addNewActivityToTeacher failed in ActivityFormVM \ncurrentUID ${serviceLocator<FirebaseAuth>().currentUser?.uid} ");
    } finally {
      EasyLoading.dismiss(animation: true);
    }
  }

  onClearCurrentStudentTasks() async {
    if (oldModel != null) {
      // oldModel!.
      // var currentActivityStudents = await ActivityStudentsController()
      //     .getSingleActivityStudents(activityId: oldModel!.id);
      var argumentReturned = await UIRouter.showAppBottomDrawerWithCustomWidget(
          child: const ClearStudentGradesRequest());

      if (argumentReturned == true) {
        var newActivityStudents = ActivityStudents(
          id: oldModel!.id,
          classId: oldModel!.currentClass!.id!,
          timestamp: pageDate,
          studentTasks: {},
        );

        await ActivityStudentsController().updateSingleActivtyStudents(
            singleActivityStudent: newActivityStudents);
        isTasksReadOnlyInEditMode = false;
        customQuestionVM.updateTasksReadOnlyInEditMode(false);
        if (onClearStudentGradesCallBack != null) {
          onClearStudentGradesCallBack!();
        }
        notifyListeners();
      }
    }
  }

  Future<void> onEditModel() async {
    if (!validateForm() || !customQuestionVM.validateAllForms()) return;
    UIRouter.showEasyLoader();
    try {
      // Step 1: Prepare data for the updated activity
      List<Map<String, dynamic>> questionEvaluations = [];
      var studentsData = {};
      var tasks = customQuestionVM.submitForms();
      var updatedActivity = {
        FirestoreConstants.Kclass: selectedClass?.toJson(),
        FirestoreConstants.timestamp:
            DateTime.fromMillisecondsSinceEpoch(pageDate).toString(),
        FirestoreConstants.time: selectedTimeInUTC,
        // FirestoreConstants.tasks: questionEvaluations,
      };

      // List<Task> updatedTasks = [];
      int tasksIndex = 0;
      for (var task in tasks) {
        Map<String, dynamic> taskData = {
          FirestoreConstants.id: task.id,
          FirestoreConstants.task: task.task,
          FirestoreConstants.taskType: task.taskType?.jsonValue,
          // Add other task data here if needed
        };

        // Upload media file associated with option, if any
        if (task.imagePathLocally != null) {
          String optionMediaUrl = await serviceLocator<AppNetworkProvider>()
              .uploadActivityFile(oldModel!.id, 'tasks${task.id}$tasksIndex',
                  File(task.imagePathLocally!));
          taskData[FirestoreConstants.downloadUrl] = optionMediaUrl;
          task.downloadUrl = optionMediaUrl;
        } else if (task.downloadUrl != null) {
          taskData[FirestoreConstants.downloadUrl] = task.downloadUrl!;
        }

        // Map<String, String?> currentTaskEvaluation = {};
        var optionsData = [];
        var optionIndex = 0;

        for (CustomQuestionOptionModel option in task.options ?? []) {
          Map<String, dynamic> optionData = {
            FirestoreConstants.id: option.id,
            FirestoreConstants.name: option.name,
            FirestoreConstants.isCorrect: option.isCorrect,
            FirestoreConstants.questionId: task.id,
          };

          // Upload media file associated with option, if any
          if (option.filePathLocally != null &&
              option.filePathLocally != null) {
            String optionMediaUrl = await serviceLocator<AppNetworkProvider>()
                .uploadActivityFile(
                    oldModel!.id,
                    'options${task.id}$optionIndex',
                    File(option.filePathLocally!));
            optionData[FirestoreConstants.downloadUrl] = optionMediaUrl;
          } else if (option.downloadUrl != null) {
            optionData[FirestoreConstants.downloadUrl] = option.downloadUrl!;
          }

          // optionData[FirestoreConstants.selectedOption] = {
          //   FirestoreConstants.id: currentOldOption.selectedOption!.id,
          //   FirestoreConstants.isCorrect:
          //       currentOldOption.selectedOption!.isCorrect,
          //   FirestoreConstants.name: currentOldOption.selectedOption!.name,
          //   FirestoreConstants.questionId:
          //       currentOldOption.selectedOption!.questionId,
          //   FirestoreConstants.gradeValue: currentOldOption.grade_value,
          //   FirestoreConstants.emojId: currentOldOption.emoji_id,
          //   FirestoreConstants.comment: currentOldOption.comment
          // };
          // }
          // }
          optionsData.add(optionData);
          optionIndex++;
        }
        taskData[FirestoreConstants.options] = optionsData;
        questionEvaluations.add(taskData);
        tasksIndex++;
      }
      updatedActivity[FirestoreConstants.tasks] = questionEvaluations;

      WriteBatch batch = FirebaseFirestore.instance.batch();

      batch.set(
        FirebaseFirestore.instance
            .collection(FirestoreConstants.activity)
            .doc(serviceLocator<FirebaseAuth>().currentUser!.uid)
            .collection(FirestoreConstants.activities)
            .doc(oldModel!.id),
        updatedActivity,
      );

      // batch.update(
      //   FirebaseFirestore.instance
      //       .collection(FirestoreConstants.classActivities)
      //       .doc(selectedClass!.id),
      //   {
      //     '${FirestoreConstants.activities}.${oldModel!.id}': updatedActivity,
      //   },
      // );

      DocumentReference classActivityDocRef = FirebaseFirestore.instance
          .collection(FirestoreConstants.classActivities)
          .doc(selectedClass!.id)
          .collection(FirestoreConstants.activities)
          .doc(oldModel!.id);
      // Step 3: Add the activity to the 'classActivities' collection
      batch.set(classActivityDocRef, updatedActivity);

      // batch.set(
      //   FirebaseFirestore.instance
      //       .collection(FirestoreConstants.classActivities)
      //       .doc(selectedClass!.id),
      //   {
      //     '${FirestoreConstants.activities}.${oldModel!.id}': updatedActivity,
      //   },
      //   SetOptions(
      //       merge:
      //           true), // Merge option ensures that existing data isn't overwritten
      // );

      DocumentReference teacherActivitiesDocRef = FirebaseFirestore.instance
          .collection(FirestoreConstants.teacherActivities)
          .doc(serviceLocator<FirebaseAuth>().currentUser!.uid);

      CollectionReference newCollection =
          teacherActivitiesDocRef.collection(((pageDate)).toString());

      batch.set(
        newCollection.doc(oldModel!.id),
        {oldModel!.id: updatedActivity},
        SetOptions(
            merge:
                true), // Merge option ensures that existing data isn't overwritten
      );

      var currentActivityStudents = await ActivityStudentsController()
          .getSingleActivityStudents(activityId: oldModel!.id);
      var studentsInClass = await serviceLocator<AppNetworkProvider>()
          .getStudentsInClass(classId: selectedClass?.id ?? '');

      var newActivityStudents = ActivityStudents(
        id: oldModel!.id,
        classId: oldModel!.currentClass!.id!,
        timestamp: pageDate,
        studentTasks: isTasksReadOnlyInEditMode == false
            ? {}
            : currentActivityStudents?.studentTasks ?? {},
      );

      if (isTasksReadOnlyInEditMode == false) {
        for (Student student in studentsInClass) {
          // var currentStudentGrade =
          //     currentActivityStudents?.studentTasks[student.id!];
          // List<Task> newTasks = [];
          // int tasksIndex = 0;
          for (var task in questionEvaluations) {
            studentsData[student.id] = {
              ...task,
              FirestoreConstants.selectedOption: null,
              FirestoreConstants.gradeValue: null,
              FirestoreConstants.emojId: null,
              FirestoreConstants.comment: null,
            };
          }
        }

        var activityStudentsDocRef = FirebaseFirestore.instance
            .collection(FirestoreConstants.activityStudents)
            .doc(oldModel!.id);

        batch.set(
          activityStudentsDocRef,
          {
            FirestoreConstants.activityId: oldModel!.id,
            FirestoreConstants.students: studentsData,
            FirestoreConstants.classId: selectedClass?.id,
            FirestoreConstants.timestamp: pageDate,
          },
          SetOptions(merge: true),
        );
      }
      await batch.commit().then((_) async {
        debugPrint('Batch write successful');

        var activity = Activity(
          id: oldModel!.id,
          tasks: questionEvaluations
              .map((task) => TaskViewModel(
                    id: task[FirestoreConstants.id],
                    task: task[FirestoreConstants.task],
                    taskType: task[FirestoreConstants.taskType] != null
                        ? TaskType.getTaskTypeFromInt(
                            task[FirestoreConstants.taskType] as int)
                        : null,
                    downloadUrl: task[FirestoreConstants.downloadUrl],
                    options:
                        (task[FirestoreConstants.options] as List<dynamic>?)
                            ?.map((option) => CustomQuestionOptionModel(
                                  option[FirestoreConstants.id],
                                  option[FirestoreConstants.name],
                                  option[FirestoreConstants.questionId],
                                  option[FirestoreConstants.isCorrect],
                                  option[FirestoreConstants.downloadUrl],
                                  null,
                                ))
                            .toList(),
                  ))
              .toList(),
          students: studentsInClass,
          currentClass: selectedClass,
          timestamp: pageDate,
          time: selectedTimeInUTC,
        );

        ActivityController activityController = ActivityController();
        await activityController.updateSingleActivty(singleActivity: activity);

        if (onAddNewActivity != null) onAddNewActivity!(activity);

        if (oldModel == null) {
          UIRouter.pushReplacementScreen(
            DayTable(model: DayTableVM(currentActivity: activity)),
            pageName: AppAnalyticsConstants.DayTableScreen,
          );
        } else {
          UIRouter.popScreen(argumentReturned: [activity, newActivityStudents]);
        }
      }).catchError((error) {
        debugPrint('Error during batch write: $error');
      });

      debugPrint(
          'Existing activity and related data updated in Firestore successfully');
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, null,
          fatal: false,
          reason:
              "Heikal - onEditModel (EditActivity) failed in ActivityFormVM \ncurrentUID ${serviceLocator<FirebaseAuth>().currentUser?.uid} ");
      debugPrint(
          'Error occurred while updating existing activity and data: $e');
    } finally {
      EasyLoading.dismiss(animation: true);
    }
  }
}
