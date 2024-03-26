import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:teachy_tec/models/Class.dart';
import 'package:teachy_tec/models/Student.dart';
import 'package:teachy_tec/screens/Students/SingleStudentForm.dart';
import 'package:teachy_tec/screens/Students/SingleStudentFormVM.dart';
import 'package:teachy_tec/screens/networking/AppNetworkProvider.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';

class StudentsScreenVM extends ChangeNotifier {
  bool isInitialized = false;
  ValueNotifier<bool> isClassesLoading = ValueNotifier(false);

  final Class? currentClass;
  List<Student> _studentsList = [];
  int get studentsCount => _studentsList.length;
  List<Class>? classesList;
  String? searchQuery;
  StudentsScreenVM({required this.currentClass}) {
    getStudentsList();
  }

  onSearch(String searchText) {
    searchQuery = searchText;
    return students;
  }

  List<Student> get students {
    var list = _studentsList;
    // Apply search
    if (searchQuery != null) {
      list = list
          .where((student) =>
              student.name.toLowerCase().contains(searchQuery!.toLowerCase()) ||
              (student.studentClass?.name ?? "")
                  .toLowerCase()
                  .contains(searchQuery!.toLowerCase()))
          .toList();
    }
    // Apply sort
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    return list;
  }

  void onUpdateStudent(List<Student> newStudentsList) {
    _studentsList = newStudentsList;
    notifyListeners();
  }

  Future<void> onTapAddNewStudent() async {
    UIRouter.showAppBottomDrawerWithCustomWidget(
        child: Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kMainPadding, vertical: kMainPadding),
      child: SingleStudentForm(
        addKeyboardHeight: true,
        model: currentClass == null
            ? SingleStudentFormVM(
                selectedClass: currentClass,
                onAddStudentCallback: (student) {
                  UIRouter.showEasyLoader();
                  getStudentsList();
                  EasyLoading.dismiss(animation: true);
                },
              )
            : SingleStudentFormVM.inClassScreen(
                selectedClass: currentClass,
                onAddStudentCallback: (student) {
                  UIRouter.showEasyLoader();
                  getStudentsList();
                  EasyLoading.dismiss(animation: true);
                },
              ),
      ),
    ));
  }

  Future<List<Class>> getClassesList({bool selectFirstClass = true}) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isClassesLoading.value = true;
    });
    classesList = await serviceLocator<AppNetworkProvider>().getClassesList();
    if (classesList == null) return [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isClassesLoading.value = false;
    });

    // notifyListeners();

    return classesList!;
  }

  Future<List<Student>> getStudentsList() async {
    UIRouter.showEasyLoader();

    if (currentClass != null) {
      _studentsList = await serviceLocator<AppNetworkProvider>()
          .getStudentsList(class_: currentClass!);
    } else {
      _studentsList =
          await serviceLocator<AppNetworkProvider>().getAllStudentsForTeacher();
    }
    isInitialized = true;

    notifyListeners();

    await EasyLoading.dismiss(animation: true);
    return _studentsList;
  }
}
