import 'package:flutter/material.dart';
import 'package:teachy_tec/models/SuperSection.dart';
import 'package:teachy_tec/screens/Grades/GradesFormVM.dart';
import 'package:teachy_tec/screens/Grades/SectionComponentVM.dart';
import 'package:teachy_tec/widgets/AutocompleteTextFieldComponent.dart';
import 'package:teachy_tec/widgets/FormParentClass.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

class SuperSectionFormVM extends ChangeNotifier with FormParentClass {
  final GradesFormVM gradesFormVM;
  String id = const Uuid().v4();
  String? name;
  int? colorhex;
  SuperSectionFormVM({required this.gradesFormVM});
  GlobalKey<AutocompleteTextFieldComponentState> sectionGlobalKey =
      GlobalKey<AutocompleteTextFieldComponentState>();
  List<SectionComponentVM> selectedSections = [];
  List<SectionComponentVM> getAllSections() {
    return gradesFormVM.sections
        .where((section) => !gradesFormVM.superSections.any((superSection) =>
            superSection.id != id &&
            superSection.selectedSections
                .any((element) => element.id == section.id)))
        .toList();
  }

  void onUpdateName(String? input) {
    name = input;
    gradesFormVM.notifyListeners_();
  }

  void onUpdateColor(int input) {
    colorhex = input;
    gradesFormVM.notifyListeners_();
  }

  void onSelectSection(String selectedSectionName) {
    var selectedSection = gradesFormVM.sections.firstWhereOrNull((element) =>
        element.name?.trim().toLowerCase() ==
        selectedSectionName.trim().toLowerCase());
    addToOrRemoveFromSelectedSection(selectedSection);
    gradesFormVM.notifyListeners_();
    // selectedSections.add(selectedSection);
    // notifyListeners();
  }

  SuperSection getSuperSectionModel() {
    return SuperSection(
        id: id,
        name: name!,
        colorHex: colorhex,
        sections: selectedSections.map((e) => e.getSectionModel()).toList());
  }

  bool validateForm_() {
    if (validateForm() &&
        (sectionGlobalKey.currentState?.onSubmitCalled() ?? true)) return true;
    return false;
  }

  void addToOrRemoveFromSelectedSection(SectionComponentVM? sectionToEdit) {
    if (sectionToEdit == null) return;
    if (selectedSections.any((element) => element.id == sectionToEdit.id)) {
      selectedSections.removeWhere((element) => element.id == sectionToEdit.id);
    } else {
      selectedSections.add(sectionToEdit);
    }
    gradesFormVM.notifyListeners_();
    notifyListeners();
  }
}
