import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:teachy_tec/hive/controllers/activityController.dart';
import 'package:teachy_tec/hive/controllers/activityStudentsController.dart';
import 'package:teachy_tec/models/Activity.dart';
import 'package:teachy_tec/models/ActivityStudents.dart';
import 'package:teachy_tec/models/AppConfiguration.dart';
import 'package:teachy_tec/models/Class.dart';
import 'package:teachy_tec/models/CustomQuestionOptionModel.dart';
import 'package:teachy_tec/models/Student.dart';
import 'package:teachy_tec/models/Task.dart';
import 'package:teachy_tec/models/TaskViewModel.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';
import 'package:firebase_storage/firebase_storage.dart' as FS;
import 'dart:typed_data';

import 'package:http/http.dart';

class AppNetworkProvider {
  Future<Uint8List?> GetImage(
      {required String? imageId,
      required int height,
      required int width}) async {
    // debugPrint("Riad - GetImage called");
    if (imageId == null) {
      return null;
    } else {
      try {
        final storageRef = FS.FirebaseStorage.instance.ref();
        final Uint8List? data = await storageRef.child(imageId).getData();
        return data;
      } catch (e) {
        // debugPrint("$e");
      } finally {
        // await EasyLoading.dismiss(animation: true);
      }
    }
    return null;
  }

  Future<List<Student>> getStudentsList({required Class class_}) async {
    List<Student> studentsList = [];

    var studentsJson = await serviceLocator<FirebaseFirestore>()
        .collection(FirestoreConstants.classesStudents)
        .doc(class_.id)
        .get();

    studentsList = ((studentsJson.data()?.values.first ?? []) as List)
        .map((e) => Student.fromJson((e as Map<String, dynamic>))
          ..studentClass = class_)
        .toList();

    return studentsList;
  }

  Future<AppConfiguration?> getAppConfiguration() async {
    try {
      var studentsJson = await serviceLocator<FirebaseFirestore>()
          .collection(FirestoreConstants.applicationConfiguration)
          .doc(serviceLocator<FirebaseAuth>().currentUser!.uid)
          .get();
      var currentAppConfiguration = AppConfiguration.fromJson(
          (studentsJson.data() as Map<String, dynamic>));
      return currentAppConfiguration;
    } catch (e) {
      var appConfiguration = AppConfiguration(
          closeApp: false, resetCache: false, updateRequired: false);
      await UpdateAppConfiguration(appConfiguration);
      return appConfiguration;
    }
    // return null;
  }

  Future<AppConfiguration?> UpdateAppConfiguration(
      AppConfiguration currentAppConfiguration) async {
    try {
      final newAppConfiguration = <String, bool?>{
        FirestoreConstants.closeApp: currentAppConfiguration.closeApp,
        FirestoreConstants.resetCache: currentAppConfiguration.resetCache,
        FirestoreConstants.updateRequired:
            currentAppConfiguration.updateRequired,
      };

      await serviceLocator<FirebaseFirestore>()
          .collection(FirestoreConstants.applicationConfiguration)
          .doc(serviceLocator<FirebaseAuth>().currentUser!.uid)
          .set(newAppConfiguration)
          .onError((e, _) => debugPrint("Error writing document: $e"));

      return currentAppConfiguration;
    } catch (e) {}
    return null;
  }

  Future<Class> onAddNewClass(
      {required List<Student> currentStudents,
      required Class currentClass}) async {
    var newClass = <String, String?>{
      FirestoreConstants.name: currentClass.name,
      FirestoreConstants.gradeLevel: currentClass.grade_level,
      FirestoreConstants.department: currentClass.department,
    };

    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Step 1: Add the new class and get its document reference
      DocumentReference classDocRef = FirebaseFirestore.instance
          .collection(FirestoreConstants.classes)
          .doc();
      batch.set(classDocRef, newClass);

      // Add the class ID to newClass
      newClass = newClass..addAll({FirestoreConstants.id: classDocRef.id});
      currentClass.id = classDocRef.id;
      // Step 2: Update the teacher's classes with the new class
      batch.set(
        FirebaseFirestore.instance
            .collection(FirestoreConstants.teacherClasses)
            .doc(serviceLocator<FirebaseAuth>().currentUser!.uid),
        {
          FirestoreConstants.classes: FieldValue.arrayUnion([newClass]),
        },
        SetOptions(merge: true),
      );

      // Step 3: Save each student individually and update the class document
      if (currentStudents.isNotEmpty) {
        List<Map<String, dynamic>> studentsData = [];
        List<String> studentIds = [];

        for (var student in currentStudents) {
          // Create a reference to the students collection
          DocumentReference studentDocRef = FirebaseFirestore.instance
              .collection(FirestoreConstants.students)
              .doc();

          // Save the student in the students collection
          batch.set(studentDocRef, student.toJson());
          // Update the student id
          student.id = studentDocRef.id;
          // Add the student details to the list
          studentsData.add(student.toJson());
          // Add the student ID to the list
          studentIds.add(studentDocRef.id);
        }

        // Update the class document with the array of student details and IDs
        batch.set(
          FirebaseFirestore.instance
              .collection(FirestoreConstants.classesStudents)
              .doc(classDocRef.id),
          {
            FirestoreConstants.students: FieldValue.arrayUnion(studentsData),
          },
          SetOptions(merge: true),
        );
      }

      // Commit the batched write
      await batch.commit();

      debugPrint('New class and students added to Firestore successfully');
    } catch (e) {
      debugPrint('Error occurred while adding new class and students: $e');
    }
    return currentClass;
  }

  Future<void> updateClassDetails({
    required String classId,
    required String teacherId,
    required Class updatedClass,
  }) async {
    await ActivityController()
        .updateClassDetailsInActivities(updatedClass: updatedClass);

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    WriteBatch batch = firestore.batch();

    // Reference to the "classes" collection
    DocumentReference classDocRef =
        firestore.collection(FirestoreConstants.classes).doc(classId);

    // Update the class details in the "classes" collection
    batch.update(classDocRef, {
      FirestoreConstants.name: updatedClass.name,
      FirestoreConstants.gradeLevel: updatedClass.grade_level,
      FirestoreConstants.department: updatedClass.department,
    });

    // Reference to the "class_activities" collection
    CollectionReference classActivitiesCollection =
        firestore.collection(FirestoreConstants.classActivities);

    // Update the class details in the "class_activities" collection
    QuerySnapshot classActivitiesSnapshot = await classActivitiesCollection
        .where('class.id', isEqualTo: classId)
        .get();

    for (var activityDoc in classActivitiesSnapshot.docs) {
      batch.update(activityDoc.reference, {
        'class': {
          'id': updatedClass.id,
          'name': updatedClass.name,
          'grade_level': updatedClass.grade_level,
          'department': updatedClass.department,
        },
      });
    }

    // Reference to the "teacher_classes" collection
    DocumentReference teacherClassesDocRef =
        firestore.collection(FirestoreConstants.teacherClasses).doc(teacherId);

    // Get the current list of classes for the teacher
    DocumentSnapshot teacherClassesSnapshot = await teacherClassesDocRef.get();

    List<dynamic> teacherClasses = List.from((teacherClassesSnapshot.data()
            as Map<String, dynamic>)[FirestoreConstants.classes] ??
        []);

    // Find the index of the class to be updated
    int indexOfUpdatedClass = teacherClasses
        .indexWhere((classItem) => classItem[FirestoreConstants.id] == classId);

    // If the class is found, update it
    if (indexOfUpdatedClass != -1) {
      teacherClasses[indexOfUpdatedClass] = {
        'id': updatedClass.id,
        'name': updatedClass.name,
        'grade_level': updatedClass.grade_level,
        'department': updatedClass.department,
      };

      // Update the entire list of classes for the teacher in Firestore
      batch.update(teacherClassesDocRef, {
        'classes': teacherClasses,
      });
    }

    // Commit the batch
    await batch.commit();
  }

  Future<void> updateClass(
    Class classVar,
  ) async {
    await ActivityController()
        .updateClassDetailsInActivities(updatedClass: classVar);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    WriteBatch batch = firestore.batch();
    // Update class details in the "class" schema
    DocumentReference classRef =
        firestore.collection(FirestoreConstants.classes).doc(classVar.id);

    batch.update(classRef, {
      FirestoreConstants.name: classVar.name,
      FirestoreConstants.gradeLevel: classVar.grade_level,
      FirestoreConstants.department: classVar.department,
    });

    // Update class activities details in the "class" schema
    // Reference to the "teacher_classes" collection
    DocumentReference classActivitiesDocRef = firestore
        .collection(FirestoreConstants.classActivities)
        .doc(classVar.id);

    // Get the current list of classes for the teacher
    DocumentSnapshot classActivitiesSnapshot =
        await classActivitiesDocRef.get();
    if (classActivitiesSnapshot.data() != null) {
      List<dynamic> activities = (classActivitiesSnapshot.data()
          as Map<String, dynamic>)[FirestoreConstants.activities] as List;
      // Find the index of the class to be updated
      int indexOfActivities = activities.indexWhere((activity) =>
          activity[FirestoreConstants.class_][FirestoreConstants.id] ==
          classVar.id);

      // If the class is found, update it
      if (indexOfActivities != -1) {
        Map<String, dynamic> currentActivity = activities[indexOfActivities];
        currentActivity[FirestoreConstants.class_] = {
          FirestoreConstants.id: classVar.id,
          FirestoreConstants.name: classVar.name,
          FirestoreConstants.gradeLevel: classVar.grade_level,
          FirestoreConstants.department: classVar.department,
        };
        activities[indexOfActivities] = currentActivity;

        // Update the entire list of classes for the teacher in Firestore
        batch.update(classActivitiesDocRef, {
          FirestoreConstants.activities: activities,
        });
      }
    }
    // Update class activities details in the "class" schema
    // Reference to the "teacher_classes" collection
    DocumentReference teacherClassesDocRef = firestore
        .collection(FirestoreConstants.teacherClasses)
        .doc(serviceLocator<FirebaseAuth>().currentUser!.uid);

    // Get the current list of classes for the teacher
    DocumentSnapshot teacherClassesSnapshot = await teacherClassesDocRef.get();

    List<dynamic> classes = (teacherClassesSnapshot.data()
        as Map<String, dynamic>)[FirestoreConstants.classes] as List;
    // Find the index of the class to be updated
    int indexOfClasses = classes
        .indexWhere((class_) => class_[FirestoreConstants.id] == classVar.id);

    // If the class is found, update it
    if (indexOfClasses != -1) {
      classes[indexOfClasses] = {
        FirestoreConstants.id: classVar.id,
        FirestoreConstants.name: classVar.name,
        FirestoreConstants.gradeLevel: classVar.grade_level,
        FirestoreConstants.department: classVar.department,
      };

      // Update the entire list of classes for the teacher in Firestore
      batch.update(teacherClassesDocRef, {
        FirestoreConstants.classes: classes,
      });
    }

    // Commit the batch
    await batch.commit();
  }

  Future<List<Student>> getStudentsInClass({required String classId}) async {
    var studentsJson = await serviceLocator<FirebaseFirestore>()
        .collection(FirestoreConstants.classesStudents)
        .doc(classId)
        .get();

    var students = ((studentsJson.data()?.values.first ?? []) as List)
        .map((e) => Student.fromJson((e as Map<String, dynamic>)))
        .toList();

    return students;
  }

  // Future<List<Student>> getStudentsList({required String classId}) async {
  //   List<Student> studentsList = [];

  //   var studentsJson = await serviceLocator<FirebaseFirestore>()
  //       .collection(FirestoreConstants.classesStudents)
  //       .doc(classId)
  //       .get();

  //   studentsList = ((studentsJson.data()?.values.first ?? []) as List)
  //       .map((e) => Student.fromJson((e as Map<String, dynamic>)))
  //       .toList();

  //   return studentsList;
  // }

  Future<List<Student>> getAllStudentsForTeacher() async {
    List<Student> allStudents = [];
    try {
      await FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        // Step 1: Get the list of classes for the teacher
        DocumentSnapshot teacherClassesSnapshot = await transaction.get(
          FirebaseFirestore.instance
              .collection(FirestoreConstants.teacherClasses)
              .doc(serviceLocator<FirebaseAuth>().currentUser!.uid),
        );

        // List<Class> classes = [];
        List<Class> classes = [];
        // List<String>.from(teacherClassesSnapshot['classes']);

        classes = ((teacherClassesSnapshot[FirestoreConstants.classes]) as List)
            .map((e) {
          return Class.fromJson((e as Map<String, dynamic>));
        }).toList();

        // Step 2: Retrieve students for each class
        for (var classVar in classes) {
          DocumentSnapshot studentsSnapshot = await transaction.get(
            FirebaseFirestore.instance
                .collection(FirestoreConstants.classesStudents)
                .doc(classVar.id),
          );

          // print(
          //     'Heikal - StudensSnapshot ${(studentsSnapshot.data()! as Map<String, dynamic>)[FirestoreConstants.students]}');

          List<dynamic> studentsData = (studentsSnapshot.data()!
              as Map<String, dynamic>)[FirestoreConstants.students];

          // Convert the data to a list of Student
          List<Student> students = (studentsData as List<dynamic>).map((item) {
            return Student.fromJson(item as Map<String, dynamic>)
              ..studentClass = classVar;
          }).toList();

          // Add the students to the overall list
          allStudents.addAll(students);
        }
      });
    } catch (e) {
      print('Error retrieving students: $e');
    }

    return allStudents;
  }

  // activity ID -> To add student to the id Directly
  Future<List<Student>> addStudents(
      {required List<Student> students,
      required String classId,
      String? activityId}) async {
    if (students.isNotEmpty) {
      await ActivityController()
          .addStudentInActivities(newStudent: students, classId: classId);

      WriteBatch batch = FirebaseFirestore.instance.batch();
      List<Map<String, dynamic>> studentsData = [];
      // List<String> studentIds = [];

      for (var student in students) {
        // Create a reference to the students collection
        DocumentReference studentDocRef = FirebaseFirestore.instance
            .collection(FirestoreConstants.students)
            .doc();

        // Save the student in the students collection
        batch.set(studentDocRef, student.toJson());
        // Update the student id
        student.id = studentDocRef.id;
        // Add the student details to the list
        studentsData.add(student.toJson());
      }

      // Update the class document with the array of student details and IDs
      batch.set(
        FirebaseFirestore.instance
            .collection(FirestoreConstants.classesStudents)
            .doc(classId),
        {
          FirestoreConstants.students: FieldValue.arrayUnion(studentsData),
        },
        SetOptions(merge: true),
      );

      if (activityId != null) {
        var activityStudentsDocRef = FirebaseFirestore.instance
            .collection(FirestoreConstants.activityStudents)
            .doc(activityId);

        batch.set(
          activityStudentsDocRef,
          {
            FirestoreConstants.students: FieldValue.arrayUnion([studentsData]),
          },
          SetOptions(merge: true),
        );
      }

      // Commit the batched write
      await batch.commit();

      // Return the list of updated students with their IDs
      return students;
    }

    // Return an empty list if no students were provided
    return [];
  }

  Future<void> deleteActivity({
    required Activity activity,
    required String classId,
  }) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Step 1: Delete the activity from the 'activity' collection
      batch.delete(
        FirebaseFirestore.instance
            .collection(FirestoreConstants.activity)
            .doc(serviceLocator<FirebaseAuth>().currentUser!.uid)
            .collection(FirestoreConstants.activities)
            .doc(activity.id),
      );

      // Step 2: Delete the activity from the 'classActivities' collection
      batch.update(
        FirebaseFirestore.instance
            .collection(FirestoreConstants.classActivities)
            .doc(classId),
        {
          FirestoreConstants.activities: FieldValue.arrayRemove([activity.id]),
        },
      );

      // Step 3: Delete the activity from the 'teacherActivities' collection
      DocumentReference teacherActivitiesDocRef = FirebaseFirestore.instance
          .collection(FirestoreConstants.teacherActivities)
          .doc(serviceLocator<FirebaseAuth>().currentUser!.uid);

      CollectionReference activityCollection =
          teacherActivitiesDocRef.collection((activity.timestamp).toString());
      batch.delete(activityCollection.doc(activity.id));

      // Step 4: Delete student-specific data from 'activityStudents' collection
      batch.delete(
        FirebaseFirestore.instance
            .collection(FirestoreConstants.activityStudents)
            .doc(activity.id),
      );

      // Commit the batched write
      await batch.commit().then((_) async {
        debugPrint('Activity and related data deleted successfully');
        await deleteFolderFromStorage(
            '${serviceLocator<FirebaseAuth>().currentUser!.uid}/Activities/${activity.id}');
        await ActivityController().deleteActivity(activity);
        await ActivityStudentsController().deleteActivity(activity);
      }).catchError((error) {
        debugPrint('Error during batch write: $error');
      });
    } catch (e) {
      debugPrint('Error occurred while deleting activity and data: $e');
    }
  }

  Future<void> deleteClass({required String classId}) async {
    try {
      var activitiesJson = await serviceLocator<FirebaseFirestore>()
          .collection(FirestoreConstants.classActivities)
          .doc(classId)
          .get();
      var activitiesData =
          (activitiesJson.data() as Map)[FirestoreConstants.activities];

      var activitiesList = ((activitiesData as List)).map((e) {
        return Activity.fromJson((e as Map<String, dynamic>));
      }).toList();
      // if (activitiesData == null) {
      //   return null;
      // }

      // activities = ((currentActivities)).map((e) {
      //   return Activity.fromJson((e as Map<String, dynamic>));
      // }).toList();
      // await ActivityController()
      //     .deleteClassDetailsInActivities(classId: classId);

      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Step 1: Delete the activity from the 'activity' collection
      batch.delete(
        FirebaseFirestore.instance
            .collection(FirestoreConstants.classes)
            .doc(classId),
      );

      // Step 2: Delete the class activities from the 'classActivities' collection
      batch.delete(
        FirebaseFirestore.instance
            .collection(FirestoreConstants.classActivities)
            .doc(classId),
      );

      // Step 3: Delete the class Students from the 'classesStudents' collection
      batch.delete(
        FirebaseFirestore.instance
            .collection(FirestoreConstants.classesStudents)
            .doc(classId),
      );

      // Step 4: Delete the teacher classes from the 'teacher_classes' collection
      DocumentReference teacherClassesDocRef = FirebaseFirestore.instance
          .collection(FirestoreConstants.teacherClasses)
          .doc(serviceLocator<FirebaseAuth>().currentUser!.uid);

      var teacherClassesSnapshot = await teacherClassesDocRef.get();
      var classes = (teacherClassesSnapshot.data()
          as Map<String, dynamic>)[FirestoreConstants.classes] as List;

      // Find the index of the student to be updated
      classes.removeWhere(
          (classVar) => classVar[FirestoreConstants.id] == classId);

      batch.update(teacherClassesDocRef, {
        FirestoreConstants.classes: classes,
      });

      for (var activityInfo in activitiesList) {
        String activityId = activityInfo.id;
        int pageDate = activityInfo.timestamp;

        // Step 1: Delete the activity from the 'activity' collection
        batch.delete(
          FirebaseFirestore.instance
              .collection(FirestoreConstants.activity)
              .doc(serviceLocator<FirebaseAuth>().currentUser!.uid)
              .collection(FirestoreConstants.activities)
              .doc(activityId),
        );

        // Step 2: Delete the activity from the 'teacherActivities' collection
        DocumentReference teacherActivitiesDocRef = FirebaseFirestore.instance
            .collection(FirestoreConstants.teacherActivities)
            .doc(serviceLocator<FirebaseAuth>().currentUser!.uid);

        CollectionReference activityCollection =
            teacherActivitiesDocRef.collection((pageDate).toString());
        batch.delete(activityCollection.doc(activityId));

        // Step 3: Delete student-specific data from 'activityStudents' collection
        batch.delete(
          FirebaseFirestore.instance
              .collection(FirestoreConstants.activityStudents)
              .doc(activityId),
        );
      }

      // Exception has occurred.
      // PlatformException (PlatformException(invalid-argument, Client specified an invalid argument. Note that this differs from failed-precondition. invalid-argument indicates arguments that are problematic regardless of the state of the system (e.g., an invalid field name)., {message: Client specified an invalid argument. Note that this differs from failed-precondition. invalid-argument indicates arguments that are problematic regardless of the state of the system (e.g., an invalid field name)., code: invalid-argument}, null))

      // Commit the batched write
      await batch.commit().then((_) async {
        debugPrint('Activity and related data deleted successfully');
        await ActivityController().deleteMultipleActivitis(activitiesList);
        await ActivityStudentsController()
            .deleteMultipleActivities(activitiesList);
        await Future.forEach(activitiesList, (activity) async {
          deleteFolderFromStorage(
              '${serviceLocator<FirebaseAuth>().currentUser!.uid}/Activities/${activity.id}');
        });
      }).catchError((error) {
        debugPrint('Error during batch write: $error');
      });
    } catch (e) {
      debugPrint('Error occurred while deleting activity and data: $e');
    }
  }

  Future<void> deleteActivities(
      List<Activity> activities, String classId_) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var activityInfo in activities) {
        String activityId = activityInfo.id;
        String classId = classId_;
        int pageDate = activityInfo.timestamp;

        // Step 1: Delete the activity from the 'activity' collection
        batch.delete(
          FirebaseFirestore.instance
              .collection(FirestoreConstants.activity)
              .doc(serviceLocator<FirebaseAuth>().currentUser!.uid)
              .collection(FirestoreConstants.activities)
              .doc(activityId),
        );

        // Step 2: Delete the activity from the 'classActivities' collection
        batch.update(
          FirebaseFirestore.instance
              .collection(FirestoreConstants.classActivities)
              .doc(classId),
          {
            FirestoreConstants.activities: FieldValue.arrayRemove([activityId]),
          },
        );

        // Step 3: Delete the activity from the 'teacherActivities' collection
        DocumentReference teacherActivitiesDocRef = FirebaseFirestore.instance
            .collection(FirestoreConstants.teacherActivities)
            .doc(serviceLocator<FirebaseAuth>().currentUser!.uid);

        CollectionReference activityCollection =
            teacherActivitiesDocRef.collection((pageDate).toString());
        batch.delete(activityCollection.doc(activityId));

        // Step 4: Delete student-specific data from 'activityStudents' collection
        batch.delete(
          FirebaseFirestore.instance
              .collection(FirestoreConstants.activityStudents)
              .doc(activityId),
        );
      }

      // Commit the batched write
      await batch.commit().then((_) {
        debugPrint('Activities and related data deleted successfully');
      }).catchError((error) {
        debugPrint('Error during batch write: $error');
      });
    } catch (e) {
      debugPrint('Error occurred while deleting activities and data: $e');
    }
  }

  Future<List<Class>> getClassesList() async {
    List<Class> classes = [];
    var classesJson = await serviceLocator<FirebaseFirestore>()
        .collection(FirestoreConstants.teacherClasses)
        .doc(serviceLocator<FirebaseAuth>().currentUser!.uid)
        .get();

    classes = ((classesJson.data()?.values.first ?? []) as List)
        .map((e) => Class.fromJson((e as Map<String, dynamic>)))
        .toList();

    return classes;
  }

  Future<TaskViewModel?> addNewTaskToActivity({
    required String activityId,
    required String classId,
    required TaskViewModel task,
    required int taskIndex,
  }) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Step 1: Get the current tasks from the 'activity' collection
      // DocumentSnapshot activitySnapshot = await FirebaseFirestore.instance
      //     .collection(FirestoreConstants.activity)
      //     .doc(activityId)
      //     .get();

      DocumentSnapshot activitySnapshot = await FirebaseFirestore.instance
          .collection(FirestoreConstants.activity)
          .doc(serviceLocator<FirebaseAuth>().currentUser!.uid)
          .collection(FirestoreConstants.activities)
          .doc(activityId)
          .get();

      List<Map<String, dynamic>> currentTasks =
          List.from(activitySnapshot[FirestoreConstants.tasks]);

      Map<String, dynamic> taskData = {
        FirestoreConstants.id: task.id,
        FirestoreConstants.task: task.task,
        FirestoreConstants.taskType: task.taskType?.jsonValue,
        // Add other task data here if needed
      };

      // Upload media file associated with option, if any
      if (task.imagePathLocally != null) {
        String optionMediaUrl = await serviceLocator<AppNetworkProvider>()
            .uploadActivityFile(activityId, 'tasks${task.id}$taskIndex',
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
        if (option.filePathLocally != null) {
          String optionMediaUrl = await serviceLocator<AppNetworkProvider>()
              .uploadActivityFile(activityId, 'options${task.id}$optionIndex',
                  File(option.filePathLocally!));
          optionData[FirestoreConstants.downloadUrl] = optionMediaUrl;
        } else if (option.downloadUrl != null) {
          optionData[FirestoreConstants.downloadUrl] = option.downloadUrl!;
        }

        optionsData.add(optionData);
        optionIndex++;
      }

      taskData[FirestoreConstants.options] = optionsData;

      // Add the new task to the list
      currentTasks.add(taskData);

      // Step 2: Update the tasks in the 'activity' collection
      batch.update(
        FirebaseFirestore.instance
            .collection(FirestoreConstants.activity)
            .doc(serviceLocator<FirebaseAuth>().currentUser!.uid)
            .collection(FirestoreConstants.activities)
            .doc(activityId),
        {
          FirestoreConstants.tasks: currentTasks,
        },
      );

      // Step 3: Update the tasks in the 'classActivities' collection
      batch.update(
        FirebaseFirestore.instance
            .collection(FirestoreConstants.classActivities)
            .doc(classId),
        {
          '${FirestoreConstants.activities}.${FirestoreConstants.tasks}':
              currentTasks,
        },
        // SetOptions(merge: true),
      );

      // Step 4: Update the tasks in the 'activityStudents' collection
      batch.update(
        FirebaseFirestore.instance
            .collection(FirestoreConstants.activityStudents)
            .doc(activityId),
        {
          '${FirestoreConstants.students}.${task.id}': {
            FirestoreConstants.task: taskData,
            FirestoreConstants.gradeValue: '',
            FirestoreConstants.selectedOption: null,
            FirestoreConstants.emojId: '',
            FirestoreConstants.comment: '',
          },
        },
        // SetOptions(merge: true),
      );

      // Commit the batched write
      await batch.commit().then((_) {
        debugPrint('New task added successfully');
      }).catchError((error) {
        debugPrint('Error during batch write: $error');
      });

      return TaskViewModel(
        id: taskData[FirestoreConstants.id],
        task: taskData[FirestoreConstants.task],
        taskType: (taskData[FirestoreConstants.taskType] != null
            ? TaskType.getTaskTypeFromInt(
                taskData[FirestoreConstants.taskType] as int)
            : null),
        //  taskData[FirestoreConstants.taskType],
        downloadUrl: taskData[FirestoreConstants.downloadUrl],
        options: (taskData[FirestoreConstants.options] as List<dynamic>?)
            ?.map((option) => CustomQuestionOptionModel(
                  option[FirestoreConstants.id],
                  option[FirestoreConstants.name],
                  option[FirestoreConstants.questionId],
                  option[FirestoreConstants.isCorrect],
                  option[FirestoreConstants.downloadUrl],
                  null,
                ))
            .toList(),
      );
    } catch (e) {
      debugPrint('Error occurred while adding new task: $e');
    }

    return null;
  }

  // Function to upload file to Firebase Storage
  Future<String> uploadActivityFile(
      String activityId, String filePath, File file) async {
    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      FS.Reference ref = FS.FirebaseStorage.instance.ref().child(
          '${serviceLocator<FirebaseAuth>().currentUser!.uid}/Activities/$activityId/$filePath');

      // Upload file to Firebase Storage
      FS.UploadTask uploadTask = ref.putFile(file);

      // Get download URL of the uploaded file
      String downloadUrl = await (await uploadTask).ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      // Handle errors here
      print('Error uploading file: $e');
      return '';
    }
  }

  // Function to upload file to Firebase Storage
  Future<String> uploadActivityFileWithURL(
      String activityId, String filePath, String downloadUrl) async {
    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      FS.Reference destinationRef = FS.FirebaseStorage.instance.ref().child(
          '${serviceLocator<FirebaseAuth>().currentUser!.uid}/Activities/$activityId/$filePath');

      Response response = await get(Uri.parse(downloadUrl));
      Uint8List fileData = response.bodyBytes;

      await destinationRef.putData(fileData);

      // Step 3: Get the download URL of the uploaded file
      String newDownloadUrl = await destinationRef.getDownloadURL();

      return newDownloadUrl;
    } catch (e) {
      // Handle errors here
      print('Error uploading file: $e');
      return '';
    }
  }

  Future<void> deleteFolderFromStorage(String folderPath) async {
    try {
      // Get a reference to the folder in Firebase Storage
      FS.Reference folderRef =
          FS.FirebaseStorage.instance.ref().child(folderPath);

      // List all items (files and subfolders) in the folder
      FS.ListResult listResult = await folderRef.listAll();

      // Delete all files in the folder
      await Future.forEach(listResult.items, (FS.Reference itemRef) async {
        await itemRef.delete();
      });

      // Delete all subfolders in the folder (recursively)
      await Future.forEach(listResult.prefixes, (FS.Reference prefixRef) async {
        await deleteFolderFromStorage(prefixRef.fullPath);
      });

      // Delete the folder itself
      // await folderRef.delete();

      if (kDebugMode) {
        print('Folder deleted successfully');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error deleting folder from storage: $error');
      }
    }
  }

  Future<List<Activity>> getAllActivitiesForCurrentTeacher() async {
    var activitiesJson = await serviceLocator<FirebaseFirestore>()
        .collection(FirestoreConstants.activity)
        .doc(serviceLocator<FirebaseAuth>().currentUser!.uid)
        .collection(FirestoreConstants.activities)
        .get();

    var activities = activitiesJson.docs.map((e) {
      var currentItem = e.data()..['id'] = e.id;
      return Activity.fromJson(currentItem);
    }).toList();

    return activities;
  }

  // Future<List<Activity>> getActivityScreensListInDateRange(
  //     {required DateTime startDate, required DateTime endDate}) async {
  //   List<Activity> activitiesToReturn = [];

  //   // String startId = "${startDate.toLocal()} (0)";
  //   // String endId = "${endDate.toLocal()} (ZZZZZZZZZZZZZ)";
  //   // Assuming ZZZZZZZZZZZZZ is the maximum value for your IDs

  //   var querySnapshot = await FirebaseFirestore.instance
  //       .collection(FirestoreConstants.teacherActivities)
  //       .doc(serviceLocator<FirebaseAuth>().currentUser!.uid)
  //       .get();

  //   List<Activity> ActivityList = [];

  //   // QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
  //   //     .instance
  //   //     .collection(FirestoreConstants.activity)
  //   //     .where(FieldPath.documentId, isGreaterThanOrEqualTo: startId)
  //   //     .where(FieldPath.documentId, isLessThan: endId)
  //   //     .get();

  //   // var ActivityJson = await serviceLocator<FirebaseFirestore>()
  //   //     .collection(FirestoreConstants.dailyMark)
  //   //     .doc(serviceLocator<FirebaseAuth>().currentUser!.uid).
  //   //     collection(date).
  //   //     doc(date)
  //   //     .where(FieldPath.documentId, isGreaterThanOrEqualTo: startId)
  //   //     .where(FieldPath.documentId, isLessThan: endId)
  //   //     .get();
  //   //     .doc(classId)
  //   //     .get();

  //   return activitiesToReturn;
  // }

  Future<ActivityStudents?> getActivityForStudents({
    required String activityId,
    required String classId,
    required int timestamp,
  }) async {
    var activitiesJson = await serviceLocator<FirebaseFirestore>()
        .collection(FirestoreConstants.activityStudents)
        .doc(activityId)
        .get();
    var activitiesData = activitiesJson.data();
    if (activitiesData == null) {
      return null;
    }

    var activitiesMap = activitiesData[FirestoreConstants.students];
    if (activitiesMap == null || activitiesMap is! Map) {
      // Handle invalid or missing data structure
      return null;
    }

    // Parse the data into the expected type
    Map<String, List<Task>> parsedActivities = {};
    activitiesMap.forEach((key, value) {
      if (value is List && value.every((element) => element is Map)) {
        parsedActivities[key] =
            value.map<Task>((json) => Task.fromJson(json)).toList();
      }
    });

    return ActivityStudents(
      id: activityId,
      classId: classId,
      timestamp: timestamp,
      studentTasks: parsedActivities,
    );
  }

  Future<List<ActivityStudents>?> getAllActivityStudentsForTeacher() async {
    // Create a list to store document snapshots
    // List<DocumentSnapshot> documentSnapshots = [];

    var activitiesJson = await serviceLocator<FirebaseFirestore>()
        .collection(FirestoreConstants.activity)
        .doc(serviceLocator<FirebaseAuth>().currentUser!.uid)
        .collection(FirestoreConstants.activities)
        .get();

    var currentActivities = activitiesJson.docs
        .cast()
        .map((e) => Map<String, dynamic>.from({"id": e.id, ...e.data()}))
        .toList();
    List<ActivityStudents> activityStudents = [];

    List<Activity> activities = [];
    // List<String>.from(teacherClassesSnapshot['classes']);
// List<Activity>.from(currentItems as List)
    activities = ((currentActivities)).map((e) {
      return Activity.fromJson((e as Map<String, dynamic>));
    }).toList();

    await Future.forEach(activities.toList(), (activity) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection(FirestoreConstants.activityStudents)
          .doc(activity.id);
      DocumentSnapshot snapshot = await documentReference.get();
      var activitiesData = snapshot.data() as Map?;
      var activitiesMap = activitiesData?[FirestoreConstants.students];
      // documentSnapshots.add(snapshot);

      if (activitiesData != null && activitiesMap is Map) {
        // Parse the data into the expected type
        Map<String, List<Task>> parsedActivities = {};
        activitiesMap.forEach((key, value) {
          if (value is List && value.every((element) => element is Map)) {
            parsedActivities[key] =
                value.map<Task>((json) => Task.fromJson(json)).toList();
          }
        });

        activityStudents.add(ActivityStudents(
          id: activity.id,
          classId: activity.currentClass?.id ?? "",
          timestamp: activity.timestamp,
          studentTasks: parsedActivities,
        ));
      }
    });

    debugPrint('Heikal - current Activities $activities');
    return activityStudents;
  }

  Future<void> saveActivityStudents(
      List<ActivityStudents> activityStudents) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (ActivityStudents activityStudent in activityStudents) {
        CollectionReference activityStudentsRef = FirebaseFirestore.instance
            .collection(FirestoreConstants.activityStudents);

        // Create a new document reference with the activity ID
        DocumentReference docRef = activityStudentsRef.doc(activityStudent.id);

        // Convert the map of students to a format that Firestore understands
        Map<String, dynamic> studentsData = {};
        activityStudent.studentTasks.forEach((studentId, tasks) {
          List<Map<String, dynamic>> tasksData =
              tasks.map((task) => task.toJson()).toList();
          studentsData[studentId] = tasksData;
        });

        // Set the data for the document
        batch.set(docRef, {'students': studentsData});
      }

      // Commit the batch
      await batch.commit();
      if (kDebugMode) {
        print('Heikal - Batch completed successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Heikal - an error occured $e');
      }
    } finally {
      if (kDebugMode) {
        print('Heikal - Batch completed');
      }
    }
  }

  Future<void> updateStudentInFirestoreAndClassStudents(
      {required String classId, required Student updatedStudent}) async {
    // Firestore instance

    await ActivityController().updateStudentInActivities(
        newStudent: updatedStudent, classId: classId);

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the "Student" collection
    CollectionReference studentCollection =
        firestore.collection(FirestoreConstants.students);

    // Reference to the "class_students" collection
    CollectionReference classStudentsCollection =
        firestore.collection(FirestoreConstants.classesStudents);

    // Create a Firestore batch
    WriteBatch batch = firestore.batch();

    // Update the student in the "Student" collection
    DocumentReference studentDocRef = studentCollection.doc(updatedStudent.id);
    batch.update(studentDocRef, {
      FirestoreConstants.name: updatedStudent.name,
      FirestoreConstants.gender: updatedStudent.gender?.jsonValue,
    });

    // Update the student in the "class_students" collection
    DocumentReference classDocRef = classStudentsCollection.doc(classId);

    // Get the current array
    DocumentSnapshot classDocSnapshot = await classDocRef.get();

    List<dynamic> studentsData = (classDocSnapshot.data()
        as Map<String, dynamic>)[FirestoreConstants.students];

// Find the index of the student to be updated
    int indexOfStudent = studentsData.indexWhere(
        (student) => student[FirestoreConstants.id] == updatedStudent.id);

// If the student is found, update it
    if (indexOfStudent != -1) {
      studentsData[indexOfStudent] = {
        FirestoreConstants.id: updatedStudent.id,
        FirestoreConstants.name: updatedStudent.name,
        FirestoreConstants.gender: updatedStudent.gender?.jsonValue,
      };

      // Update the entire array in Firestore
      batch.update(classDocRef, {
        FirestoreConstants.students: studentsData,
      });
    }

    // Commit the batch
    await batch.commit();
  }

  Future<void> deleteStudentClassStudentsAndActivityStudents(
      {required String classId, required Student updatedStudent}) async {
    try {
      await ActivityController().deleteStudentInActivities(
          newStudent: updatedStudent, classId: classId);
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      WriteBatch batch = firestore.batch();

      // Reference to the "Student" collection
      CollectionReference studentCollection =
          firestore.collection(FirestoreConstants.students);

      // Reference to the "class_students" collection
      CollectionReference classStudentsCollection =
          firestore.collection(FirestoreConstants.classesStudents);

      // Reference to the "class_activities" collection
      CollectionReference classActivitiesCollection =
          firestore.collection(FirestoreConstants.classActivities);

      // Reference to the "activity_students" collection
      CollectionReference activityStudentsCollection =
          firestore.collection(FirestoreConstants.activityStudents);

      // Update the student in the "Student" collection
      DocumentReference studentDocRef =
          studentCollection.doc(updatedStudent.id);
      batch.delete(studentDocRef);

      // Update the student in the "class_students" collection
      DocumentReference classDocRef = classStudentsCollection.doc(classId);
      DocumentReference classActivitiesDocRef =
          classActivitiesCollection.doc(classId);
      DocumentSnapshot classActivitiesDocSnapshot =
          await classActivitiesDocRef.get();
      DocumentSnapshot classDocSnapshot = await classDocRef.get();
      List<dynamic> studentsData = List.from((classDocSnapshot.data()
              as Map<String, dynamic>)[FirestoreConstants.students] ??
          []);

      // Remove the student from the "class_students" collection
      studentsData.removeWhere(
          (student) => student[FirestoreConstants.id] == updatedStudent.id);

      batch.update(classDocRef, {
        FirestoreConstants.students: studentsData,
      });

      // Get all activities attached to this class
      List<dynamic> classActivityRefs = List.from((classActivitiesDocSnapshot
              .data() as Map<String, dynamic>)[FirestoreConstants.activities] ??
          []);

      // Iterate through all activities from "class_activities" and remove the student from "activity_students"
      for (Map<String, dynamic> classActivityRef in classActivityRefs) {
        var currentActivityId = (classActivityRef)[FirestoreConstants.id];
        DocumentSnapshot activityStudents =
            await activityStudentsCollection.doc(currentActivityId).get();

        // Iterate through all activities from "activity_students" and remove the student
        if (activityStudents.data() != null) {
          var currentStudents = ((activityStudents.data()
                  as Map<String, dynamic>)[FirestoreConstants.students]
              as List<dynamic>);

          currentStudents[0]
              .removeWhere((key, value) => key == updatedStudent.id);

          batch.update(activityStudentsCollection.doc(currentActivityId), {
            FirestoreConstants.students: currentStudents,
          });
        }
      }

      // Commit the batch
      await batch.commit();
    } catch (e) {
      await EasyLoading.dismiss(animation: true);
    }
  }

  Future<void> deleteStudentInFirestoreAndClassStudentsAndActivityStudents(
      {required String classId, required Student updatedStudent}) async {
    // Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the "Student" collection
    CollectionReference studentCollection =
        firestore.collection(FirestoreConstants.students);

    // Reference to the "class_students" collection
    CollectionReference classStudentsCollection =
        firestore.collection(FirestoreConstants.classesStudents);

    // Create a Firestore batch
    WriteBatch batch = firestore.batch();

    // Update the student in the "Student" collection
    DocumentReference studentDocRef = studentCollection.doc(updatedStudent.id);
    batch.delete(studentDocRef);

    // Update the student in the "class_students" collection
    DocumentReference classDocRef = classStudentsCollection.doc(classId);

    // Get the current array
    DocumentSnapshot classDocSnapshot = await classDocRef.get();

    // Get the students list
    List<dynamic> studentsData = (classDocSnapshot.data()
        as Map<String, dynamic>)[FirestoreConstants.students];

    // Find the index of the student to be updated
    studentsData.removeWhere(
        (student) => student[FirestoreConstants.id] == updatedStudent.id);

    // Update the entire array in Firestore
    batch.update(classDocRef, {
      FirestoreConstants.students: studentsData,
    });

    // Commit the batch
    await batch.commit();
  }
}
