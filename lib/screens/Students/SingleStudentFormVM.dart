import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/models/Class.dart';
import 'package:teachy_tec/models/Student.dart';
import 'package:teachy_tec/screens/networking/AppNetworkProvider.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';
import 'package:teachy_tec/widgets/FormParentClass.dart';
import 'package:teachy_tec/widgets/Popups/DeleteItemPopup.dart';

class SingleStudentFormVM extends ChangeNotifier with FormParentClass {
  String? name;
  Gender? gender;
  Student? studentModel;
  Class? selectedClass;
  ValueNotifier<bool> isClassesLoading = ValueNotifier(false);
  List<Class>? classes;
  // TODO: Make this form use enums for the types and remove all booleans for selection
  // boolean to set the class in class Name
  bool? isInClass;
  bool? isPreview;
  // Class? currentClass;
  void Function(Student)? onAddStudentCallback;
  void Function(Student)? onUpdateStudentCallback;
  final VoidCallback? onDeleteStudentCallback;
  late bool showActionButtons;
  bool isDeletingInProgress = false;

  SingleStudentFormVM(
      {required this.selectedClass,
      this.onAddStudentCallback,
      this.onDeleteStudentCallback}) {
    gender = Gender.male;
    showActionButtons = true;
    getClassesList(selectFirstClass: selectedClass == null ? true : false);
  }

  SingleStudentFormVM.inClassScreen(
      {required this.selectedClass,
      this.onAddStudentCallback,
      this.onDeleteStudentCallback}) {
    gender = Gender.male;
    showActionButtons = true;
    isInClass = true;
    // getClassesList(selectFirstClass: currentClass == null ? true : false);
  }

  SingleStudentFormVM.edit(
      {required this.studentModel,
      required this.selectedClass,
      this.onDeleteStudentCallback,
      this.onUpdateStudentCallback}) {
    if (studentModel != null) {
      gender = studentModel!.gender ?? Gender.male;
      name = studentModel!.name;
      selectedClass = studentModel!.studentClass;
    }
    showActionButtons = true;
    getClassesList(selectFirstClass: selectedClass == null ? true : false);
  }

  SingleStudentFormVM.preview(
      {required this.studentModel,
      // required this.currentClass,
      this.onDeleteStudentCallback,
      this.onUpdateStudentCallback}) {
    isPreview = true;
    showActionButtons = false;
    selectedClass = studentModel!.studentClass;
    if (studentModel != null) {
      gender = studentModel!.gender ?? Gender.male;
      name = studentModel!.name;
      selectedClass = studentModel!.studentClass;
    }
  }

  void onGenderChange(Gender newGender) {
    if (gender == newGender) return;
    gender = newGender;
    notifyListeners();
  }

  Future<List<Class>> getClassesList({bool selectFirstClass = true}) async {
    isClassesLoading.value = true;
    classes = await serviceLocator<AppNetworkProvider>().getClassesList();
    if (classes == null) return [];
    isClassesLoading.value = false;
    if (selectFirstClass) {
      selectedClass = classes!.isNotEmpty ? classes!.first : null;
    }
    notifyListeners();
    return classes!;
  }

  void onSelectClass(String selectedClassName) {
    selectedClass = classes?.firstWhere((element) =>
        element.name.trim().toLowerCase() ==
        selectedClassName.trim().toLowerCase());
    // currentClass = selectedClass;
    notifyListeners();
  }

  togglePreview({required bool isPreview}) {
    this.isPreview = isPreview;
    if (isPreview) {
      showActionButtons = false;
    } else {
      showActionButtons = true;
    }
    notifyListeners();
  }

  Future<void> addNewstudent() async {
    if (!validateForm()) return;
    try {
      UIRouter.showEasyLoader();
      var savedStudents = await serviceLocator<AppNetworkProvider>()
          .addStudents(
              students: [Student(id: null, name: name!, gender: gender)],
              classId: selectedClass?.id ?? '');

      if (onAddStudentCallback != null) {
        onAddStudentCallback!(savedStudents.first);
      }
      notifyListeners();
      UIRouter.popScreen(rootNavigator: true);
      EasyLoading.dismiss(animation: true);
    } catch (e) {
    } finally {
      EasyLoading.dismiss(animation: true);
    }
  }

  Future<void> editNewStudent() async {
    if (!validateForm() && studentModel == null) return;
    UIRouter.showEasyLoader();

    var currrentStudent = Student(
      id: studentModel!.id,
      name: name!,
      gender: gender,
      studentClass: selectedClass,
    );
    await serviceLocator<AppNetworkProvider>()
        .updateStudentInFirestoreAndClassStudents(
            updatedStudent: Student(
              id: studentModel!.id,
              name: name!,
              gender: gender,
              studentClass: selectedClass,
            ),
            classId: selectedClass!.id!);

    if (onUpdateStudentCallback != null) {
      onUpdateStudentCallback!(currrentStudent);
    }
    notifyListeners();
    EasyLoading.dismiss(animation: true);
  }

  Future<void> deleteStudent() async {
    return await UIRouter.showAppBottomDrawerWithCustomWidget(
      bottomPadding: 0,
      child: DeleteItemPopup(
          onDeleteCallback: () async {
            if (isDeletingInProgress) return;
            isDeletingInProgress = true;
            UIRouter.showEasyLoader();
            if (!validateForm() && studentModel == null) return;
            await serviceLocator<AppNetworkProvider>()
                .deleteStudentClassStudentsAndActivityStudents(
                    updatedStudent: Student(
                      id: studentModel!.id,
                      name: name!,
                      gender: gender,
                    ),
                    classId: selectedClass?.id ?? '');

            if (onDeleteStudentCallback != null) {
              onDeleteStudentCallback!();
            }
            EasyLoading.dismiss(animation: true);
            UIRouter.popScreen();
            UIRouter.popScreen();
          },
          deleteMessage:
              "${AppLocale.areYouSureYouWantToDelete.getString(UIRouter.getCurrentContext()).capitalizeFirstLetter()} ${AppLocale.student.getString(UIRouter.getCurrentContext()).toLowerCase()}${AppLocale.questionMark.getString(UIRouter.getCurrentContext())}",
          dangerAdviceText: AppLocale
              .deletingStudentWillResultInIrreversibleLossOfStudentDegrees
              .getString(UIRouter.getCurrentContext())
              .capitalizeFirstLetter()),
    );
  }
}
