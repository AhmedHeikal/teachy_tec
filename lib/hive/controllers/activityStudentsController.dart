import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:teachy_tec/Services/hiveStore.dart';
import 'package:teachy_tec/models/Activity.dart';
import 'package:teachy_tec/models/ActivityStudents.dart';
import 'package:teachy_tec/models/Student.dart';
import 'package:teachy_tec/models/Task.dart';
import 'package:collection/collection.dart';
import 'package:teachy_tec/screens/networking/AppNetworkProvider.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';

class ActivityStudentsController {
  late final Store store;

  ActivityStudentsController() {
    store = serviceLocator<Store>();
  }

  Future<List<ActivityStudents>?> getActivityStudents() async {
    var currentItems = (await store.getValue(
          Store.activityStudentsBoxName,
          Store.activityStudentsList,
          defaultValue: [],
        ) ??
        []);
    if (kDebugMode) {
      print('Heikal - returned items from getActivities Hive $currentItems');
    }
    return List<ActivityStudents>.from(currentItems as List);
  }

  Future<ActivityStudents?> getSingleActivityStudents(
      {required String activityId}) async {
    var currentItems = (await getActivityStudents().then((value) =>
        value?.firstWhereOrNull((activity) => activity.id == activityId)));
    if (kDebugMode) {
      print('Heikal - returned items from getActivities Hive $currentItems');
    }
    return currentItems;
  }

  Future<void> updateTasksForStudentInActivityStudents({
    required String activityId,
    required String classId,
    required String studentId,
    required int timestamp,
    required List<Task> studentUpdatedTasks,
  }) async {
    var currentActivity =
        await getSingleActivityStudents(activityId: activityId);

    if (currentActivity == null) {
      currentActivity ??= ActivityStudents(
          id: activityId,
          classId: classId,
          timestamp: timestamp,
          studentTasks: {studentId: studentUpdatedTasks});
    } else {
      currentActivity.studentTasks[studentId] = studentUpdatedTasks;
    }

    updateSingleActivtyStudents(singleActivityStudent: currentActivity);
    return;
  }

  Future<void> updateSingleActivtyStudents(
      {required ActivityStudents singleActivityStudent}) async {
    List<ActivityStudents> currentActivities =
        await getActivityStudents() ?? [];

    var currentIndex = currentActivities
        .indexWhere((activity) => activity.id == singleActivityStudent.id);

    if (currentIndex == -1) {
      await addActivityStudents(singleActivityStudent);
    } else {
      currentActivities[currentIndex] = singleActivityStudent;
      await store.setValue(Store.activityStudentsBoxName,
          Store.activityStudentsList, currentActivities);
    }
  }

  Future<void> addActivityStudents(
      ActivityStudents singleActivityStudent) async {
    List<ActivityStudents> activityStudents = List<ActivityStudents>.from(
        await store.getValue(
                Store.activityStudentsBoxName, Store.activityStudentsList,
                defaultValue: []) ??
            []);

    activityStudents.add(singleActivityStudent);
    await store.setValue(Store.activityStudentsBoxName,
        Store.activityStudentsList, activityStudents);
  }

  Future<void> deleteActivity(Activity activity) async {
    final List<ActivityStudents> activities = List<ActivityStudents>.from(
        await store.getValue(
                Store.activityStudentsBoxName, Store.activityStudentsList,
                defaultValue: []) ??
            []);

    activities
        .removeWhere((activityStudents) => activityStudents.id == activity.id);
    await store.setValue(
        Store.activityStudentsBoxName, Store.activityStudentsList, activities);
  }

  Future<void> saveLocalUnsavedActivityStudentsToServer() async {
    var activitesSavedLocally = await getActivityStudents() ?? [];

    List<ActivityStudents> notUploadedStudents = activitesSavedLocally
        .where((activity) => activity.lastTimeUploadedToServer == null)
        .toList();

    await serviceLocator<AppNetworkProvider>()
        .saveActivityStudents(notUploadedStudents);

    var currentTimeStamp = DateTime.now().millisecondsSinceEpoch;

    for (var activity in notUploadedStudents) {
      activity.lastTimeUploadedToServer = currentTimeStamp;
      int index = activitesSavedLocally.indexOf(activity);
      activitesSavedLocally[index] = activity;
    }

    await store.setValue(
      Store.activityStudentsBoxName,
      Store.activityStudentsList,
      activitesSavedLocally,
    );
  }

  Future<void> updateSingleStudentActivityToServer(
      {required String activityId}) async {
    var currentActivity =
        await getSingleActivityStudents(activityId: activityId);
    if (currentActivity == null) return;
    await serviceLocator<AppNetworkProvider>()
        .saveActivityStudents([currentActivity]);

    var currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
    currentActivity.lastTimeUploadedToServer = currentTimeStamp;

    await updateSingleActivtyStudents(singleActivityStudent: currentActivity);
  }

  Future<Map<Student, Map<int, List<Task>>?>> getDayGradesForClass(
      String classId, DateTime? currentDate) async {
    Map<Student, Map<int, List<Task>>?> studentsToTasksList = {};

    // var allActivityStudents = await getActivityStudents();

    List<ActivityStudents>? currentItems = [];
    var returnedList = await getActivityStudents();

    currentItems = returnedList
        ?.where((activity) =>
            activity.classId == classId &&
            (currentDate == null ||
                activity.timestamp ==
                    DateUtils.dateOnly(currentDate).millisecondsSinceEpoch ~/
                        1000))
        .toList();

    // TODO: create a new Structure to save the students locally
    // get the students for the class
    var studentsList = await serviceLocator<AppNetworkProvider>()
        .getStudentsInClass(classId: classId);
    // Iterate on each Student for each Activity Item
    studentsToTasksList = {for (var e in studentsList) e: null};

    currentItems?.forEach(
      (activityStudents) {
        activityStudents.studentTasks.forEach((key, value) {
          var currentStudent =
              studentsList.firstWhereOrNull((student) => student.id == key);
          if (currentStudent == null) return;
          if (studentsToTasksList[currentStudent] == null) {
            studentsToTasksList[currentStudent] = {
              activityStudents.timestamp: value
            };
          } else if (studentsToTasksList[currentStudent]
                  ?[activityStudents.timestamp] ==
              null) {
            studentsToTasksList[currentStudent]![activityStudents.timestamp] =
                value;
          } else {
            studentsToTasksList[currentStudent]?[activityStudents.timestamp]
                ?.addAll(value);
          }
        });
      },
    );

    // Add the value which each student id represents to the main map
    if (kDebugMode) {
      print(
          'Heikal - returned items from getActivitiesForCertainDate Hive $currentItems');
    }
    // return List<Activity>.from(currentItems as List);
    return studentsToTasksList;
  }

  Future<Map<Student, Map<int, List<Task>>?>> getStudentGrades(
      String classId, Student currentStudent) async {
    Map<Student, Map<int, List<Task>>?> studentsToTasksList = {};

    // var allActivityStudents = await getActivityStudents();

    List<ActivityStudents>? currentItems = [];
    var returnedList = await getActivityStudents();

    currentItems =
        returnedList?.where((activity) => activity.classId == classId).toList();

    // TODO: create a new Structure to save the students locally
    // get the students for the class
    // var studentsList = await serviceLocator<AppNetworkProvider>()
    //     .getStudentsInClass(classId: classId);
    // // Iterate on each Student for each Activity Item
    // studentsToTasksList = {for (var e in studentsList) e: null};

    currentItems?.forEach(
      (activityStudents) {
        var currentTasks =
            activityStudents.studentTasks[currentStudent.id!] ?? [];

// studentsToTasksList[currentStudent] =
        if (studentsToTasksList[currentStudent] == null) {
          studentsToTasksList[currentStudent] = {
            activityStudents.timestamp: currentTasks
          };
        } else if (studentsToTasksList[currentStudent]
                ?[activityStudents.timestamp] ==
            null) {
          studentsToTasksList[currentStudent]![activityStudents.timestamp] =
              currentTasks;
        } else {
          studentsToTasksList[currentStudent]?[activityStudents.timestamp]
              ?.addAll(currentTasks);
        }
      },
    );

    // Add the value which each student id represents to the main map
    if (kDebugMode) {
      print(
          'Heikal - returned items from getActivitiesForCertainDate Hive $currentItems');
    }
    // return List<Activity>.from(currentItems as List);
    return studentsToTasksList;
  }

  Future<Map<Student, Map<int, List<Task>>?>> getDayGradesForClassWithDateRange(
      String classId, DateTime startDate, DateTime endDate) async {
    Map<Student, Map<int, List<Task>>?> studentsToTasksList = {};

    // var allActivityStudents = await getActivityStudents();

    List<ActivityStudents>? currentItems = [];
    var returnedList = await getActivityStudents();

    currentItems = returnedList
        ?.where((activity) =>
            activity.classId == classId &&
            ((activity.timestamp >=
                    DateUtils.dateOnly(startDate).millisecondsSinceEpoch ~/
                        1000) &&
                activity.timestamp <=
                    DateUtils.dateOnly(endDate).millisecondsSinceEpoch))
        .toList();

    // TODO: create a new Structure to save the students locally
    // get the students for the class
    var studentsList = await serviceLocator<AppNetworkProvider>()
        .getStudentsInClass(classId: classId);
    // Iterate on each Student for each Activity Item
    studentsToTasksList = {for (var e in studentsList) e: null};

    currentItems?.forEach(
      (activityStudents) {
        activityStudents.studentTasks.forEach((key, value) {
          var currentStudent =
              studentsList.firstWhereOrNull((student) => student.id == key);
          if (currentStudent == null) return;
          if (studentsToTasksList[currentStudent] == null) {
            studentsToTasksList[currentStudent] = {
              activityStudents.timestamp: value
            };
          } else if (studentsToTasksList[currentStudent]
                  ?[activityStudents.timestamp] ==
              null) {
            studentsToTasksList[currentStudent]![activityStudents.timestamp] =
                value;
          } else {
            studentsToTasksList[currentStudent]?[activityStudents.timestamp]
                ?.addAll(value);
          }
        });
      },
    );

    // Add the value which each student id represents to the main map
    if (kDebugMode) {
      print(
          'Heikal - returned items from getActivitiesForCertainDate Hive $currentItems');
    }
    // return List<Activity>.from(currentItems as List);
    return studentsToTasksList;
  }
}
