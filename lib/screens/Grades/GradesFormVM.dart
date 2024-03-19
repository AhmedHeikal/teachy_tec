import 'package:flutter/material.dart';
import 'package:teachy_tec/models/Class.dart';
import 'package:teachy_tec/screens/Grades/SectionComponentVM.dart';
import 'package:teachy_tec/screens/networking/AppNetworkProvider.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';
import 'package:teachy_tec/widgets/FormParentClass.dart';
import 'package:collection/collection.dart';

class GradesFormVM extends ChangeNotifier with FormParentClass {
  // Class? selectedClass;
  ValueNotifier<bool> isClassesLoading = ValueNotifier(false);
  List<Class>? classes;

  List<Class> selectedClasses = [];
  List<SectionComponentVM> sections = [];
  GradesFormVM() {
    if (classes == null) {
      getClassesList();
    }
  }

  Future<List<Class>> getClassesList({bool selectFirstClass = false}) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isClassesLoading.value = true;
    });
    classes = await serviceLocator<AppNetworkProvider>().getClassesList();
    if (classes == null) return [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isClassesLoading.value = false;
    });
    if (selectFirstClass && classes!.isNotEmpty) {
      addToOrRemoveFromSelectedClasses(classes!.first);
    }
    notifyListeners();

    return classes!;
  }

  void addToOrRemoveFromSelectedClasses(Class? classToEdit) {
    if (classToEdit == null) return;
    if (selectedClasses.any((element) => element.id == classToEdit.id)) {
      selectedClasses.removeWhere((element) => element.id == classToEdit.id);
    } else {
      selectedClasses.add(classToEdit);
    }
    notifyListeners();
  }

  void onSelectClass(String selectedClassName) {
    var selectedClass = classes?.firstWhereOrNull((element) =>
        element.name.trim().toLowerCase() ==
        selectedClassName.trim().toLowerCase());
    addToOrRemoveFromSelectedClasses(selectedClass);
  }

  void onAddSection() {
    sections.add(SectionComponentVM());
    notifyListeners();
  }

  void onDeleteSection(int index) {
    sections.removeAt(index);
    notifyListeners();
  }
}
