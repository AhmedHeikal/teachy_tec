import 'package:hive/hive.dart';

class Store {
  static const activitiesBoxName = 'activitiesBox';
  static const activitiesList = 'activitiesList';
  static const activityStudentsBoxName = 'activityStudentsBox';
  static const activityStudentsList = 'activityStudentsList';
  late Box _activitiesBox;
  late Box _activityStudentsBox;

  Store() {
    // _activitiesBox = Hive.box(activitiesBoxName);
    // _activityStudentsBox = Hive.box(activityStudentsBoxName);

    _activitiesBox = Hive.box(activitiesBoxName);
    _activityStudentsBox = Hive.box(activityStudentsBoxName);
  }

  Future<void> openBoxSpecificBoxAfterClose(String boxName) async {
    await Hive.openBox(
      boxName.toLowerCase() == activitiesBoxName.toLowerCase()
          ? activitiesBoxName
          : activityStudentsBoxName,
    );

    if (boxName.toLowerCase() == activitiesBoxName.toLowerCase()) {
      _activitiesBox = Hive.box(activitiesBoxName);
    } else {
      _activityStudentsBox = Hive.box(activityStudentsBoxName);
    }
  }
  // Future<T?> getValue<T>(String boxName, Object key, {T? defaultValue}) async =>
  //     await _box.get(
  //       key,
  //       defaultValue: defaultValue,
  //     ) as T?;

  // Future<dynamic> getValue(String boxName, Object key,
  //     {dynamic defaultValue}) async {
  //   var currentBox = boxName.toLowerCase() == activitiesBoxName.toLowerCase()
  //       ? _activitiesBox
  //       : _activityStudentsBox;

  //   if (!currentBox.isOpen) await Hive.openBox(boxName);
  //   var returnedItem = await currentBox.get(
  //     key,
  //     defaultValue: defaultValue,
  //   );

  //   await currentBox.close();
  //   return returnedItem;
  // }
  Future<dynamic> getValue(String boxName, String key,
      {dynamic defaultValue}) async {
    var currentBox = boxName.toLowerCase() == activitiesBoxName.toLowerCase()
        ? _activitiesBox
        : _activityStudentsBox;

    try {
      if (!currentBox.isOpen) {
        await openBoxSpecificBoxAfterClose(boxName);
        currentBox = boxName.toLowerCase() == activitiesBoxName.toLowerCase()
            ? _activitiesBox
            : _activityStudentsBox;
      }

      var returnedItem = await currentBox.get(
        key,
        defaultValue: defaultValue,
      );

      return returnedItem;
    } finally {
      if (currentBox.isOpen) {
        await currentBox.close();
      }
    }
  }

  // Future<dynamic> getValue(String boxName, Object key,
  //     {dynamic defaultValue}) async {
  //   try {
  //     if (boxName.toLowerCase() == activitiesBoxName.toLowerCase()) {
  //       var currentItem = await _activitiesBox.get(
  //         key,
  //         defaultValue: defaultValue,
  //       );

  //       if (currentItem is T) {
  //         return currentItem as T;
  //       } else if (T is List<ActivityStudents>? && currentItem is List) {
  //         List<ActivityStudents>? activityStudentsList = currentItem
  //             ?.map((dynamic item) => item is ActivityStudents ? item : null)
  //             .toList() as List<ActivityStudents>?;
  //         return activityStudentsList as T?;
  //       } else {
  //         if (kDebugMode) {
  //           print(
  //               'Type mismatch in Hive data. Expected: $T, Actual: ${currentItem.runtimeType}');
  //         }
  //       }
  //     } else if (boxName.toLowerCase() ==
  //         activityStudentsBoxName.toLowerCase()) {
  //       var currentItem = await _activityStudentsBox.get(
  //         key,
  //         defaultValue: defaultValue,
  //       );

  //       if (currentItem is T) {
  //         return currentItem;
  //       } else if (T is List<Activity>? && currentItem is List) {
  //         List<Activity>? activityList = currentItem
  //             ?.map((dynamic item) => item is Activity ? item : null)
  //             .toList() as List<Activity>?;
  //         return activityList as T?;
  //       } else {
  //         if (kDebugMode) {
  //           print(
  //               'Type mismatch in Hive data. Expected: $T, Actual: ${currentItem.runtimeType}');
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('An error occurred in Hive parsing $e');
  //     }
  //   }

  //   return defaultValue;
  // }

  Future<void> setValue<T>(String boxName, Object key, dynamic value) async {
    var currentBox = boxName.toLowerCase() == activitiesBoxName.toLowerCase()
        ? _activitiesBox
        : _activityStudentsBox;

    try {
      if (!currentBox.isOpen) {
        await openBoxSpecificBoxAfterClose(boxName);
        currentBox = boxName.toLowerCase() == activitiesBoxName.toLowerCase()
            ? _activitiesBox
            : _activityStudentsBox;
      }
      await currentBox.put(key, value);
    } finally {
      if (currentBox.isOpen) {
        await currentBox.close();
      }
    }
  }
  // Future<void> setValue<T>(String boxName, Object key, T value) async =>
  //     await _box.put(key, value);

  Future<void> deleteValue<T>(String boxName, Object key) async {
    var currentBox = boxName.toLowerCase() == activitiesBoxName.toLowerCase()
        ? _activitiesBox
        : _activityStudentsBox;

    try {
      if (!currentBox.isOpen) {
        await openBoxSpecificBoxAfterClose(boxName);
        currentBox = boxName.toLowerCase() == activitiesBoxName.toLowerCase()
            ? _activitiesBox
            : _activityStudentsBox;
      }
      await currentBox.delete(key);
    } finally {
      if (currentBox.isOpen) {
        await currentBox.close();
      }
    }
  }

  // Future<void> deleteValue<T>(String boxName, Object key) async =>
  //     await _box.delete(key);

  Future<void> clearAll(String boxName) async =>
      boxName.toLowerCase() == activitiesBoxName.toLowerCase()
          ? await _activitiesBox.clear()
          : await _activityStudentsBox.clear();
  // Future<void> clearAll(String boxName) async => await _box.clear();
}
