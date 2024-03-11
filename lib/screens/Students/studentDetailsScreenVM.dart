import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:teachy_tec/hive/controllers/activityStudentsController.dart';
import 'package:teachy_tec/models/Student.dart';
import 'package:teachy_tec/models/Task.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:collection/collection.dart';

class StudentDetailsScreenVM extends ChangeNotifier {
  StudentDetailsScreenVM({
    required this.currentStudent,
    required this.onDeleteStudent,
    required this.onUpdateStudent,
  }) {
    getStudentsGrades();
  }

  final VoidCallback onDeleteStudent;
  final void Function(Student) onUpdateStudent;

  Student currentStudent;
  Map<Student, Map<int, List<Task>>?> currentlyItem = {};

  void getStudentsGrades() async {
    UIRouter.showEasyLoader();

    currentlyItem.clear();
    currentlyItem = await ActivityStudentsController().getStudentGrades(
      currentStudent.studentClass?.id ?? '',
      currentStudent,
    );
    EasyLoading.dismiss(animation: true);
    notifyListeners();
  }

  void onUpdateStudentCallback(Student student) {
    currentStudent = student;
    var currentItem = currentlyItem.entries
        .firstWhereOrNull((element) => element.key.id == student.id);
    currentItem?.key.name = student.name;
    currentItem?.key.gender = student.gender;

    onUpdateStudent(student);
    notifyListeners();
  }
}
