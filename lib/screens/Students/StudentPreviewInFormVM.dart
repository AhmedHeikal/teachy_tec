import 'package:flutter/material.dart';
import 'package:teachy_tec/models/Student.dart';
import 'package:teachy_tec/screens/Students/StudentFormVM.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/widgets/FormParentClass.dart';

class StudentPreviewInFormVM extends ChangeNotifier with FormParentClass {
  Student currentStudent;
  final VoidCallback onEditTapped;
  final VoidCallback onDeleteTapped;
  final Function(Student, bool) onFinishTapped;
  final Function(Gender) changeGeneralGenderSettings;
  bool isInEditMode;
  final Gender gender;
  bool isPreview;
  late StudentFormVM studentFormVM;

  StudentPreviewInFormVM({
    /// Remove the contol buttons
    this.isPreview = false,
    required this.currentStudent,
    required this.isInEditMode,
    required this.onEditTapped,
    required this.onFinishTapped,
    required this.gender,
    required this.changeGeneralGenderSettings,
    required this.onDeleteTapped,
  }) {
    studentFormVM = StudentFormVM.edit(
      changeGeneralGenderSettings: changeGeneralGenderSettings,
      oldStudent: currentStudent,
      gender: gender,
      onFinishEditingStudent: (newStudent, addNewStudent) {
        isInEditMode = false;
        onFinishTapped(newStudent, addNewStudent);
        notifyListeners();
      },
      onDeleteStudent: onDeleteTapped,
    );
  }

  void onEditTappedInForm() {
    onEditTapped();
    isInEditMode = true;
    notifyListeners();
  }
}
