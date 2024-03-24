import 'package:flutter/material.dart';
import 'package:teachy_tec/models/Class.dart';
import 'package:teachy_tec/models/Schema.dart';
import 'package:teachy_tec/models/Section.dart';
import 'package:teachy_tec/models/SuperSection.dart';
import 'package:teachy_tec/models/classSchema.dart';
import 'package:teachy_tec/screens/Grades/GradesFormSecondPage.dart';
import 'package:teachy_tec/screens/Grades/SectionComponentVM.dart';
import 'package:teachy_tec/screens/Grades/SuperSectionFormVM.dart';
import 'package:teachy_tec/screens/networking/AppNetworkProvider.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/utils/Routing/AppAnalyticsConstants.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';
import 'package:teachy_tec/widgets/AutocompleteTextFieldComponent.dart';
import 'package:teachy_tec/widgets/FormParentClass.dart';
import 'package:collection/collection.dart';
import 'package:teachy_tec/widgets/showSpecificNotifications.dart';

class GradesFormVM extends ChangeNotifier with FormParentClass {
  // Class? selectedClass;
  ValueNotifier<bool> isClassesLoading = ValueNotifier(false);

  String? name;
  List<Class>? classes;
  GlobalKey<AutocompleteTextFieldComponentState> classesGlobalKey =
      GlobalKey<AutocompleteTextFieldComponentState>();
  List<Class> selectedClasses = [];
  List<SectionComponentVM> sections = [];
  List<SuperSectionFormVM> superSections = [];
  GradesFormVM() {
    sections.add(SectionComponentVM(
        getCumulativeGradesLeft:
            getCumulativeSectionGradesAfterRemovingTheSectionThatsCallingThisFunction,
        notifySectionComponentsToUpdateTheirRemainingGradesFromParent:
            notifySectionComponentsToUpdateTheirRemainingGrades));
    if (classes == null) {
      getClassesList();
    }
  }

  List<Section> getSectionsForSubmitting() {
    List<Section> currentSections = [];
    for (var element in sections) {
      if (superSections.any((superSection) => superSection.selectedSections
          .any((section) => section.id == element.id))) {
        continue;
      }
      currentSections.add(element.getSectionModel());
    }
    return currentSections;
  }

  List<SuperSection> getSuperSectionsForSubmitting() {
    List<SuperSection> currentSuperSections = [];
    for (var element in superSections) {
      if (superSections.any((superSection) => superSection.selectedSections
          .any((section) => section.id == element.id))) {
        continue;
      }
      currentSuperSections.add(element.getSuperSectionModel());
    }
    return currentSuperSections;
  }

  bool checkIfFullSchemaGradesConsumed() {
    var cumulativeGrades = AppUtility.doubleWithoutDecimalToInt(double.tryParse(
        sections
            .fold<num>(0,
                (count, innerList) => count + (innerList.totalGrade.value ?? 0))
            .toStringAsFixed(2))!);
    var leftGrades = AppUtility.doubleWithoutDecimalToInt(
        double.tryParse((100 - cumulativeGrades).toStringAsFixed(2))!);
    if (cumulativeGrades == 100) {
      return true;
    } else if (cumulativeGrades > 100) {
      debugPrint('Heikal - cumulative Grades > 100');

      showSpecificNotificaiton(
          notifcationDetails: AppNotifcationsItems.yourTotalGradesExceed100);
      return false;
    } else /* if (cumulativeGrades < 100) */ {
      debugPrint('Heikal - cumulative Grades < 100');

      showSpecificNotificaiton(
          notifcationDetails:
              AppNotifcationsItems.yourTotalGradesBelow100(leftGrades));
      return false;
    }
    // return true;
  }

  bool checkIfMoreGradesLeftToAddNewSection() {
    var cumulativeGrades = AppUtility.doubleWithoutDecimalToInt(double.tryParse(
        sections
            .fold<num>(0,
                (count, innerList) => count + (innerList.totalGrade.value ?? 0))
            .toStringAsFixed(2))!);
    // var leftGrades = AppUtility.doubleWithoutDecimalToInt(
    //     double.tryParse((100 - cumulativeGrades).toStringAsFixed(2))!);
    if (cumulativeGrades == 100) {
      showSpecificNotificaiton(
          notifcationDetails: AppNotifcationsItems
              .allgradeAllocationsAreCompleteNoAdditionalSectionsAreRequired);
      return false;
    } else if (cumulativeGrades > 100) {
      debugPrint('Heikal - cumulative Grades > 100');

      showSpecificNotificaiton(
          notifcationDetails: AppNotifcationsItems.yourTotalGradesExceed100);
      return false;
    } else {
      return true;
    }
  }

  void notifySectionComponentsToUpdateTheirRemainingGrades() {
    for (var element in sections) {
      element.currentRemainingGrade = 100 -
          getCumulativeSectionGradesAfterRemovingTheSectionThatsCallingThisFunction(
              id: element.id);
    }
  }

  void onSubmittingFirstPage() {
    if (validateFirstPage()) {
      UIRouter.pushScreen(GradesFormSecondPage(model: this),
          pageName: AppAnalyticsConstants.GradesFormSecondScreen);
    }
  }

  bool validateFirstPage() {
    return validateForm() &&
        (classesGlobalKey.currentState?.onSubmitCalled() ?? true) &&
        validateAllSecionForms() &&
        validateAllSectionSectors() &&
        checkIfFullSchemaGradesConsumed();
  }

  num getCumulativeSectionGradesAfterRemovingTheSectionThatsCallingThisFunction(
      {String? id}) {
    num sectionGrades = 0;

    for (var element in sections) {
      if (element.id != id) sectionGrades += element.totalGrade.value ?? 0;
    }
    return sectionGrades;
  }

  void notifyListeners_() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
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
    if (validateForm() &&
        validateAllSecionForms() &&
        validateAllSectionSectors() &&
        checkIfMoreGradesLeftToAddNewSection()) {
      sections.add(SectionComponentVM(
          getCumulativeGradesLeft:
              getCumulativeSectionGradesAfterRemovingTheSectionThatsCallingThisFunction,
          notifySectionComponentsToUpdateTheirRemainingGradesFromParent:
              notifySectionComponentsToUpdateTheirRemainingGrades));
      notifyListeners();
    }
  }

  bool validateAllSectionSectors() {
    if (sections
        .any((element) => (!checkIfFullSectionGradesConsumed(element)))) {
      return false;
    }
    return true;
  }

  bool checkIfFullSectionGradesConsumed(SectionComponentVM currentSection) {
    var cumulativeGrades = AppUtility.doubleWithoutDecimalToInt(double.tryParse(
        currentSection.sectors
            .fold<num>(
                0, (count, innerList) => count + (innerList.realWeight ?? 0))
            .toStringAsFixed(2))!);

    var leftGrades = AppUtility.doubleWithoutDecimalToInt(double.tryParse(
        ((currentSection.totalGrade.value ?? 0) - cumulativeGrades)
            .toStringAsFixed(2))!);

    if (currentSection.sectors.isEmpty) return true;
    if (cumulativeGrades == currentSection.totalGrade.value) {
      return true;
    } else if (cumulativeGrades < (currentSection.totalGrade.value ?? 0)) {
      debugPrint('Heikal - cumulative Grades < 100');

      showSpecificNotificaiton(
          notifcationDetails: AppNotifcationsItems.yourSectionTotalGradesBelow(
              currentSection.totalGrade.value ?? 0, leftGrades));
      return false;
    } else {
      debugPrint('Heikal - cumulative Grades > 100');
      showSpecificNotificaiton(
          notifcationDetails: AppNotifcationsItems.yourTotalGradesExceed100);
      return false;
    }
  }

  void onAddSuperSectionSection() {
    if (validateSuperSectionsForm()) {
      superSections.add(SuperSectionFormVM(gradesFormVM: this));
      notifyListeners();
    }
  }

  void onDeleteSuperSection(int index) {
    superSections.removeAt(index);
    notifyListeners();
  }

  bool validateAllSecionForms() {
    bool textWasAddedBefore = false;
    for (int i = 0; i < sections.length; i++) {
      for (int j = i + 1; j < sections.length; j++) {
        if (sections[i].name?.isNotEmpty == true &&
            sections[j].name?.isNotEmpty == true &&
            sections[i].name?.trim().toLowerCase() ==
                sections[j].name?.trim().toLowerCase()) {
          textWasAddedBefore = true;
          break;
        }
      }
    }

    if (textWasAddedBefore) {
      showSpecificNotificaiton(
          notifcationDetails:
              AppNotifcationsItems.sectionNamesShouldBeDifferent);
      return false;
    }

    bool returnedvalue = sections.any((element) {
      if (element.totalGrade.value == 0) {
        showSpecificNotificaiton(
            notifcationDetails: AppNotifcationsItems.sectionGradeCantBeZero);
        return true;
      }
      if (!element.validateForm() ||
          !element.validateAllSectorForms() ||
          element.isCumulativeMoreThanTotalGrade) {
        return true;
      }
      return false;
    });

    return !returnedvalue;
  }

  // bool validateOptionsForm(/* {bool isLastElement = false} */) {
  //   bool textWasAddedBefore = false;
  //   for (int i = 0; i < options.length; i++) {
  //     for (int j = i + 1; j < options.length; j++) {
  //       if (options[i].optionString?.isNotEmpty == true &&
  //           options[j].optionString?.isNotEmpty == true &&
  //           options[i].optionString?.trim().toLowerCase() ==
  //               options[j].optionString?.trim().toLowerCase()) {
  //         textWasAddedBefore = true;
  //         break;
  //       }
  //     }
  //   }

  //   if (options.any((element) => !element.validate())) {
  //     return false;
  //   } else if (textWasAddedBefore) {
  //     showSpecificNotificaiton(
  //         notifcationDetails:
  //             AppNotifcationsItems.customQuestionOptionDuplicated);
  //     return false;
  //   }
  //   return true;
  // }

  bool validateSuperSectionsForm({bool isToSubmitForm = false}) {
    bool textWasAddedBefore = false;
    for (int i = 0; i < superSections.length; i++) {
      for (int j = i + 1; j < superSections.length; j++) {
        if (superSections[i].name?.isNotEmpty == true &&
            superSections[j].name?.isNotEmpty == true &&
            superSections[i].name?.trim().toLowerCase() ==
                superSections[j].name?.trim().toLowerCase()) {
          textWasAddedBefore = true;
          break;
        }
      }
    }

    if (textWasAddedBefore) {
      showSpecificNotificaiton(
          notifcationDetails:
              AppNotifcationsItems.supersectionNamesShouldBeDifferent);
      return false;
    }

    if (superSections.any((element) => !element.validateForm_()) ||
        (!isToSubmitForm && isAllSectionsSelectedInOtherSuperSectionForms())) {
      return false;
    }
    return true;
  }

  bool isAllSectionsSelectedInOtherSuperSectionForms() {
    var selectedSectionsFromOtherSuperSections = superSections.fold(
        0,
        (previousValue, innerList) =>
            previousValue + innerList.selectedSections.length);
    var returnedValue =
        selectedSectionsFromOtherSuperSections == sections.length;
    if (returnedValue) {
      showSpecificNotificaiton(
          notifcationDetails: AppNotifcationsItems
              .allSectionsHaveBeenChosenAdjustOtherSupersectionToCreateNewOne);
    }
    return returnedValue;
  }

  void onDeleteSection(int index) {
    sections.removeAt(index);
    notifyListeners();
  }

  void onSubmitForm() async {
    if (validateForm() && validateSuperSectionsForm(isToSubmitForm: true)) {
      List<classSchema> classesSchemas = selectedClasses
          .map((class_) => classSchema(
              id: class_.id,
              name: class_.name,
              department: class_.department,
              grade_level: class_.grade_level,
              isActive: true,
              schemaId: "",
              lastEditTimestamp: DateTime.now().millisecondsSinceEpoch))
          .toList();

      var currentSchema = Schema(
        id: '',
        name: name!,
        classes: classesSchemas,
        sections: getSectionsForSubmitting(),
        superSections: getSuperSectionsForSubmitting(),
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      debugPrint('Heikal - currentSchema Hopa');

      var returnedSchema = await serviceLocator<AppNetworkProvider>()
          .addNewSchema(currentSchema);

      UIRouter.popScreen(argumentReturned: returnedSchema);
      UIRouter.popScreen(argumentReturned: returnedSchema);
    }
  }
}
