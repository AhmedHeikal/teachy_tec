import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:teachy_tec/models/Class.dart';
import 'package:teachy_tec/screens/Students/StudentsComponentVM.dart';
import 'package:teachy_tec/screens/networking/AppNetworkProvider.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';
import 'package:teachy_tec/widgets/FormParentClass.dart';

class ClassFormVM extends ChangeNotifier with FormParentClass {
  String? className;
  String? gradeLevel;
  String? department;
  late StudentsComponentVM studentsComponentVM;
  Class? oldClass;
  List<Class> currentClasses = [];
  ClassFormVM.edit({
    required this.oldClass,
  }) {
    if (oldClass != null) {
      className = oldClass!.name;
      gradeLevel = oldClass!.grade_level;
      department = oldClass!.department;
    }
    studentsComponentVM = StudentsComponentVM.preview(
      currentClass: oldClass,
    );
  }

  ClassFormVM() {
    studentsComponentVM = StudentsComponentVM();
    getClassesList();
  }

  void getClassesList() async {
    currentClasses =
        await serviceLocator<AppNetworkProvider>().getClassesList();
    notifyListeners();
  }

  Future<void> addNewClassToTeacher() async {
    if (!validateForm()) return;
    UIRouter.showEasyLoader();
    var currentStudents = studentsComponentVM.getStudentsList();
    var newClass = serviceLocator<AppNetworkProvider>().onAddNewClass(
        currentStudents: currentStudents,
        currentClass: Class(
            id: null,
            name: className ?? "",
            department: department,
            grade_level: gradeLevel));
    EasyLoading.dismiss(animation: true);
    UIRouter.popScreen(rootNavigator: true, argumentReturned: newClass);
  }

  Future<void> editClassToTeacher() async {
    if (!validateForm()) return;
    UIRouter.showEasyLoader();
    var classVar = Class(
      id: oldClass!.id,
      name: className ?? oldClass!.name,
      department: department,
      grade_level: gradeLevel ?? oldClass!.grade_level,
    );

    await serviceLocator<AppNetworkProvider>().updateClass(classVar);
    EasyLoading.dismiss(animation: true);
    UIRouter.popScreen(rootNavigator: true, argumentReturned: classVar);
  }

  Future<void> deleteClassToTeacher() async {
    await serviceLocator<AppNetworkProvider>()
        .deleteClass(classId: oldClass!.id!);
    UIRouter.popScreen(rootNavigator: true, argumentReturned: null);
  }
}
