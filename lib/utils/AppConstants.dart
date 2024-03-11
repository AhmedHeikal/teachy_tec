import 'package:flutter/material.dart';
import 'package:teachy_tec/styles/AppColors.dart';

const double kInternalPadding = 6;
const double kHelpingPadding = 8;
const double kBottomPadding = 12;
const double kMainPadding = 16;

const int floatNumbersConstant = 8;

List<BoxShadow> kBoxShadowsArray = [
  BoxShadow(
    color: AppColors.grey400.withOpacity(0.1),
    spreadRadius: 2,
    blurRadius: 0,
    offset: const Offset(1, 1), // changes position of shadow
  ),
];

// ignore: non_constant_identifier_names
List<BoxShadow> KboxBlurredShadowsArray = [
  BoxShadow(
    color: AppColors.grey400.withOpacity(0.15),
    spreadRadius: 1,
    blurRadius: 20,
    offset: const Offset(0, 2), // changes position of shadow
  ),
];

BoxShadow kDropShadow = BoxShadow(
  color: AppColors.black.withOpacity(0.6),
  spreadRadius: 0,
  blurRadius: 1.28,
  offset: const Offset(0.64, 0.96), // changes position of shadow
);

BoxShadow KCardShadow = BoxShadow(
  color: AppColors.grey300.withOpacity(0.6),
  spreadRadius: 0,
  blurRadius: 1.28125,
  offset: const Offset(-0.256, -0.640625), // changes position of shadow
);
BoxShadow kUpperShadow = BoxShadow(
  color: AppColors.black.withOpacity(0.6),
  spreadRadius: 0,
  blurRadius: 1.28,
  offset: const Offset(-0.256, -0.64), // changes position of shadow
);

List<BoxShadow> kBoxBlurredShadowsArray = [
  BoxShadow(
    color: AppColors.grey400.withOpacity(0.15),
    spreadRadius: 1,
    blurRadius: 20,
    offset: const Offset(0, 2), // changes position of shadow
  ),
];
List<BoxShadow> kListShadowsArray = [
  BoxShadow(
    color: AppColors.black.withOpacity(0.25),
    spreadRadius: 0,
    blurRadius: 9,
    offset: const Offset(0, 3.6), // changes position of shadow
  ),
];
List<BoxShadow> KdefaultShadow = [
  BoxShadow(
    color: AppColors.grey400.withOpacity(0.1),
    spreadRadius: 2,
    blurRadius: 0,
    offset: const Offset(1, 1), // changes position of shadow
  ),
];

const List<String> kVideoExtensions = ["mov", "mp4", "quicktime"];

const List<String> kImageExtensions = ["bmp", "jpeg", "jpg", "pjpeg", "png"];

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

// classes
//     name: String
//     department: Maths

// teachers
//     name: String
//     gender: enum (0: M - 1: F)
//     email: String

// students
//     name: String
//     gender: enum (0: M - 1: F)

// classes_students
//     class_id -> String
//         Students: List<student>

// teacher_classes
//     "teacher_id" -> String
//         classes: List<class>

// daily_mark
//     "teacher_id" -> String
//         "date_id" -> String (7-1-2024-1)
//            "class_id" -> String
//                 "student_id" -> String
//                     List<Question_evaluation(Map)>

// ## class not included in schema
// Question_evaluation
//     question: String
//     grade_value: String -> Will have values for default evaluation criteria
//     grade_type: String -> either "emoji" or "text"
//     comment: String

// Firestore constanst
class FirestoreConstants {
  static const String classes = "classes";
  static const String teachers = "teachers";
  static const String students = "students";
  static const String classId = "classId";
  static const String applicationConfiguration = "application_configuration";
  static const String closeApp = "closeApp";
  static const String resetCache = "resetCache";
  static const String updateRequired = "updateRequired";
  static const String activityId = "activityId";
  static const String activity = "activity";
  static const String activities = "activities";
  static const String id = "id";
  static const String tasks = "tasks";
  static const String task = "task";
  static const String selectedOption = "selectedOption";
  static const String options = "options";
  static const String questionId = "questionId";
  static const String isCorrect = "isCorrect";
  static const String downloadUrl = "downloadUrl";
  static const String Kclass = "class";
  static const String classActivities = "class_activities";
  static const String activityStudents = "activity_students";
  static const String teacherActivities = "teacher_activities";
  static const String classesStudents = "class_students";
  static const String teacherClasses = "teacher_classes";
  static const String dailyMark = "daily_mark";
  static const String name = "name";
  static const String class_ = "class";
  static const String email = "email";
  static const String gender = "gender";
  static const String department = "department";
  static const String date = "date";
  static const String timestamp = "timestamp";
  static const String time = "time";
  static const String question = "question";
  static const String gradeValue = "grade_value";
  static const String gradeType = "grade_type";
  static const String emojId = "emoji_id";
  static const String gradeLevel = "grade_level";
  static const String comment = "comment";
}
