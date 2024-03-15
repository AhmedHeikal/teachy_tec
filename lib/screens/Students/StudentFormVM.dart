import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/models/Student.dart';
import 'package:teachy_tec/screens/Students/StudentsComponentVM.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/widgets/FormParentClass.dart';
import 'package:teachy_tec/widgets/showSpecificNotifications.dart';

class StudentFormVM extends ChangeNotifier with FormParentClass {
  String? name;
  late Gender gender;
  Student? oldStudent;
  Function(Gender) changeGeneralGenderSettings;
  Function(Student, bool) onFinishEditingStudent;
  VoidCallback onDeleteStudent;
  bool? isPlain;

  StudentFormVM.edit({
    required this.changeGeneralGenderSettings,
    required this.oldStudent,
    required this.onFinishEditingStudent,
    required this.onDeleteStudent,
    required this.gender,
  }) {
    gender = oldStudent!.gender ?? gender;
    name = oldStudent!.name;
  }
  StudentFormVM({
    required this.gender,
    required this.changeGeneralGenderSettings,
    required this.onFinishEditingStudent,
    required this.onDeleteStudent,
  });
  StudentFormVM.plain({
    required this.gender,
    required this.changeGeneralGenderSettings,
    required this.onFinishEditingStudent,
    required this.onDeleteStudent,
  }) {
    isPlain = true;
  }

  void onGenderChange(Gender newGender) {
    changeGeneralGenderSettings(newGender);
    if (gender == newGender) return;
    gender = newGender;
    notifyListeners();
  }

  bool onCompleteButtonTapped({BuildContext? context}) {
    if (!validateForm()) return false;
    if (context != null) {
      var studentsComponent =
          Provider.of<StudentsComponentVM>(context, listen: false);

      if (studentsComponent.studentsList.any((student) =>
          student.currentStudent.name.trim().toLowerCase() ==
              name?.trim().toLowerCase() &&
          student.currentStudent.id != oldStudent?.id)) {
        showSpecificNotificaiton(
            notifcationDetails: AppNotifcationsItems.studentNamesDuplicated);
        return false;
      }
    }
    Student studentToReturn =
        Student(id: null, name: name ?? '', gender: gender);
    if (oldStudent != null) {
      studentToReturn = studentToReturn..id = oldStudent!.id;
    }
    onFinishEditingStudent(studentToReturn, false);
    return true;
  }

  Student? onAddNewStudentButtonTapped({BuildContext? context}) {
    if (!validateForm()) return null;
    if (context != null) {
      var studentsComponent =
          Provider.of<StudentsComponentVM>(context, listen: false);

      if (studentsComponent.studentsList.any((student) =>
          student.currentStudent.name.trim().toLowerCase() ==
              name?.trim().toLowerCase() &&
          student.currentStudent.id != oldStudent?.id)) {
        showSpecificNotificaiton(
          notifcationDetails: AppNotifcationsItems.studentNamesDuplicated,
        );
        return null;
      }
    }

    Student studentToReturn =
        Student(id: null, name: name ?? '', gender: gender);
    if (oldStudent != null) {
      studentToReturn = studentToReturn..id = oldStudent!.id;
    }
    onFinishEditingStudent(studentToReturn, true);
    return studentToReturn;
  }

  bool onDeleteStudentButtonTapped({BuildContext? context}) {
    if (!validateForm()) return false;

    Student studentToReturn =
        Student(id: null, name: name ?? '', gender: gender);
    if (oldStudent != null) {
      studentToReturn = studentToReturn..id = oldStudent!.id;
    }
    onFinishEditingStudent(studentToReturn, true);
    return true;
  }
}
