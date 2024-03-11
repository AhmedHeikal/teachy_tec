import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:teachy_tec/Services/hiveStore.dart';
import 'package:teachy_tec/models/Activity.dart';
import 'package:teachy_tec/models/Class.dart';
import 'package:teachy_tec/models/Student.dart';
import 'package:teachy_tec/screens/networking/AppNetworkProvider.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';

class ActivityController {
  late final Store store;

  ActivityController() {
    store = serviceLocator<Store>();
  }

  bool didUpdateInThisSession = false;

  Future<List<Activity>?> getActivities() async {
    try {
      var currentItems = await store.getValue(
              Store.activitiesBoxName, Store.activitiesList,
              defaultValue: []) ??
          [];

      if (!didUpdateInThisSession &&
          (List<Activity>.from(currentItems as List)).isEmpty) {
        await updateAllActivitiesFromServer();
        didUpdateInThisSession = true;
        return getActivities();
      }

      if (kDebugMode) {
        print('Heikal - returned items from getActivities Hive $currentItems');
      }

      return List<Activity>.from(currentItems as List);
    } catch (e) {
      await updateAllActivitiesFromServer();
      didUpdateInThisSession = true;
      return getActivities();
    }
  }

  Future<List<Activity>?> getActivitiesForCertainDate(
      DateTime currentDate) async {
    try {
      var currentItems = await getActivities().then((value) => value
          ?.where((activity) =>
              AppUtility.removeTime(
                  DateTime.fromMillisecondsSinceEpoch(activity.timestamp)) ==
              AppUtility.removeTime(currentDate))
          .toList());

      // if (!didUpdateInThisSession &&
      //     (currentItems as List).isEmpty) {
      //   await updateAllActivitiesFromServer();
      //   didUpdateInThisSession = true;
      //   await getActivitiesForCertainDate(currentDate);
      // }
      if (kDebugMode) {
        print(
            'Heikal - returned items from getActivitiesForCertainDate Hive $currentItems');
      }
      return List<Activity>.from(currentItems as List);
    } catch (e) {
      await updateAllActivitiesFromServer();
      didUpdateInThisSession = true;
      await getActivitiesForCertainDate(currentDate);
    }
    return null;
  }

  // if (!didUpdateInThisSession &&
// 1708200000000
// 1707854400000
// 1708200000000
  Future<List<Activity>?> getActivitiesForDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      var currentItems = await getActivities();

      currentItems = currentItems
          ?.where((activity) => ((activity.timestamp >=
                  DateUtils.dateOnly(startDate).millisecondsSinceEpoch) &&
              activity.timestamp <=
                  DateUtils.dateOnly(endDate).millisecondsSinceEpoch))
          .toList();

      // if (!didUpdateInThisSession &&
      //     ((currentItems as List)).isEmpty) {
      //   await updateAllActivitiesFromServer();
      //   didUpdateInThisSession = true;
      //   return getActivitiesForDateRange(startDate, endDate);
      // }
      if (kDebugMode) {
        print(
            'Heikal - returned items from getActivitiesForCertainDate Hive $currentItems');
      }
      return List<Activity>.from(currentItems as List);
    } catch (e) {
      await updateAllActivitiesFromServer();
      didUpdateInThisSession = true;
      return getActivitiesForDateRange(startDate, endDate);
    }

    // return currentItems as List<Activity>?;
  }

  Future<void> addActivity(Activity activity) async {
    final List<Activity> activities = await getActivities() ?? [];
    if (activities.any((element) => element.id == activity.id)) {
      updateSingleActivty(singleActivity: activity);
    } else {
      activities.add(activity);
    }
    await store.setValue(
      Store.activitiesBoxName,
      Store.activitiesList,
      activities,
    );
  }

  Future<void> updateSingleActivty({required Activity singleActivity}) async {
    List<Activity> currentActivities = await getActivities() ?? [];

    var currentIndex = currentActivities
        .indexWhere((activity) => activity.id == singleActivity.id);

    if (currentIndex == -1) {
      await addActivity(singleActivity);
    } else {
      currentActivities[currentIndex] = singleActivity;
      await store.setValue(
          Store.activitiesBoxName, Store.activitiesList, currentActivities);
    }
  }

  Future<void> addStudentInActivities(
      {required List<Student> newStudent, required String classId}) async {
    List<Activity> currentActivities = await getActivities() ?? [];
    currentActivities
        .where((element) => element.currentClass?.id == classId)
        .forEach((element) {
      element.students?.addAll(newStudent);
    });

    await store.setValue(
        Store.activitiesBoxName, Store.activitiesList, currentActivities);
  }

  Future<void> updateStudentInActivities(
      {required Student newStudent, required String classId}) async {
    List<Activity> currentActivities = await getActivities() ?? [];
    currentActivities
        .where((element) => element.currentClass?.id == classId)
        .forEach((class_) {
      var currentStudentIndex =
          class_.students?.indexWhere((student) => student.id == newStudent.id);

      if (currentStudentIndex != null && currentStudentIndex != -1) {
        class_.students?[currentStudentIndex] = newStudent;
      }
    });

    await store.setValue(
        Store.activitiesBoxName, Store.activitiesList, currentActivities);
  }

  Future<void> updateClassDetailsInActivities(
      {required Class updatedClass}) async {
    List<Activity> currentActivities = await getActivities() ?? [];
    currentActivities
        .where((activity) => activity.currentClass?.id == updatedClass.id)
        .forEach((activity) {
      activity.currentClass = updatedClass;
    });

    await store.setValue(
        Store.activitiesBoxName, Store.activitiesList, currentActivities);
  }

  Future<void> deleteClassDetailsInActivities({required String classId}) async {
    List<Activity> currentActivities = await getActivities() ?? [];
    currentActivities
        .removeWhere((activity) => activity.currentClass?.id == classId);

    await store.setValue(
        Store.activitiesBoxName, Store.activitiesList, currentActivities);
  }

  Future<void> deleteStudentInActivities(
      {required Student newStudent, required String classId}) async {
    List<Activity> currentActivities = await getActivities() ?? [];
    currentActivities
        .where((element) => element.currentClass?.id == classId)
        .forEach((class_) {
      class_.students?.removeWhere((student) => student.id == newStudent.id);
    });

    await store.setValue(
        Store.activitiesBoxName, Store.activitiesList, currentActivities);
  }

  Future<void> updateAllActivitiesFromServer() async {
    List<Activity> currentActivities =
        await serviceLocator<AppNetworkProvider>()
            .getAllActivitiesForCurrentTeacher();

    await store.setValue(
        Store.activitiesBoxName, Store.activitiesList, currentActivities);
  }

  Future<void> deleteActivity(Activity activity) async {
    final List<Activity> activities = List<Activity>.from(await store.getValue(
            Store.activitiesBoxName, Store.activitiesList,
            defaultValue: []) ??
        []);
    activities.removeWhere((element) => element.id == activity.id);
    await store.setValue(
        Store.activitiesBoxName, Store.activitiesList, activities);
  }
}
