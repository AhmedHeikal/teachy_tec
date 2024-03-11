import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:teachy_tec/hive/controllers/activityStudentsController.dart';
import 'package:teachy_tec/models/Class.dart';
import 'package:teachy_tec/models/Student.dart';
import 'package:teachy_tec/models/Task.dart';
import 'package:teachy_tec/screens/networking/AppNetworkProvider.dart';
import 'package:teachy_tec/utils/UIRouter.dart';

import 'package:teachy_tec/utils/serviceLocator.dart';
import 'package:collection/collection.dart';

class GradesScreenVM extends ChangeNotifier {
  GradesScreenVM() {
    getClassesList(
      selectFirstClass: false,
    );
  }

  Map<Student, Map<int, List<Task>>?> currentlyItem = {};
  DateTime? currentDateTime;
  DateTime? startDate;
  DateTime? endDate;
  ValueNotifier<bool> isClassesLoading = ValueNotifier(false);
  Class? selectedClass;
  List<Class> classes = [];

  Future<List<Class>> getClassesList({bool selectFirstClass = true}) async {
    isClassesLoading.value = true;
    classes = [];
    classes = await serviceLocator<AppNetworkProvider>().getClassesList();
    isClassesLoading.value = false;
    if (selectFirstClass) {
      selectedClass = classes.isNotEmpty ? classes.first : null;
    }

    return classes;
  }

  void onSelectClass(
    String? selectedClassName,
  ) async {
    UIRouter.showEasyLoader();
    selectedClass = classes.firstWhereOrNull((element) =>
        element.name.trim().toLowerCase() ==
        selectedClassName?.trim().toLowerCase());
    // If no classes found -> for example for the placeholder
    //     ->     return null and refresh the settings
    if (selectedClass == null) {
      EasyLoading.dismiss(animation: true);
      currentlyItem = {};
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      return;
    }

    currentlyItem.clear();
    currentlyItem = await ActivityStudentsController().getDayGradesForClass(
      selectedClass!.id!,
      currentDateTime,
    );
    EasyLoading.dismiss(animation: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void onSelectDate(DateTime? currentDateTime) async {
    if (selectedClass == null) return;
    UIRouter.showEasyLoader();

    this.currentDateTime = currentDateTime;
    currentlyItem.clear();
    currentlyItem = await ActivityStudentsController().getDayGradesForClass(
      selectedClass!.id!,
      currentDateTime,
    );
    EasyLoading.dismiss(animation: true);
    notifyListeners();
  }

  void onSelectDateRange(DateTime startDate, DateTime endDate) async {
    if (selectedClass == null) return;
    UIRouter.showEasyLoader();
    this.startDate = startDate;
    this.endDate = endDate;
    currentlyItem.clear();
    currentlyItem = await ActivityStudentsController()
        .getDayGradesForClassWithDateRange(
            selectedClass!.id!, startDate, endDate);
    EasyLoading.dismiss(animation: true);
    notifyListeners();
  }
}
