import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:teachy_tec/models/Section.dart';
import 'package:teachy_tec/models/Sector.dart';
import 'package:teachy_tec/screens/Grades/SectorFormVM.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/widgets/FormParentClass.dart';
import 'package:teachy_tec/widgets/showSpecificNotifications.dart';
import 'package:uuid/uuid.dart';

class SectionComponentVM extends ChangeNotifier with FormParentClass {
  String? name;
  String? id;
  ValueNotifier<num?> totalGrade = ValueNotifier(null);
  ValueNotifier<num> sectorCumulativeGrade = ValueNotifier(0);
  int? colorhex;
  var uuid = const Uuid();
  num? currentRemainingGrade;
  List<SectorFormVM> sectors = [];
  bool isCumulativeMoreThanTotalGrade = false;
  num Function({String? id}) getCumulativeGradesLeft;
  VoidCallback notifySectionComponentsToUpdateTheirRemainingGradesFromParent;
  SectionComponentVM({
    required this.getCumulativeGradesLeft,
    required this.notifySectionComponentsToUpdateTheirRemainingGradesFromParent,
  }) {
    id = uuid.v1();
    currentRemainingGrade = 100 - getCumulativeGradesLeft(id: id);
  }

  void updateTotalGrade(String input) {
    totalGrade.value = input.trim().isEmpty
        ? null
        : AppUtility.doubleWithoutDecimalToInt(double.tryParse(input)!);

    notifySectionComponentsToUpdateTheirRemainingGradesFromParent();
    onSectorRealWeightUpdate();
    callValidateSectorForms();
  }

  onUpdateSectionsGrade() {
    currentRemainingGrade = (totalGrade.value ?? 0) -
        getCumulativeSectorGradesAfterRemovingTheSectorThatsCallingThisFunction(
            id: id);
    // onRealWeightUpdate(realWeight?.toString());
    // if (sectionVM.totalGrade.value == null ||
    //     sectionVM.totalGrade.value == 0 ||
    //     sectionVM.isCumulativeMoreThanTotalGrade) {
    //   isDisabled = true;
    //   percentageWeight = 0;
    //   notifyListeners();
    // } else if (isDisabled == true) {
    //   isDisabled = false;
    //   notifyListeners();
    // }
  }

  List<Sector> getSectorsModels() {
    List<Sector> currentSectors = [];
    for (var element in sectors) {
      currentSectors.add(element.getSectorModel());
    }
    return currentSectors;
  }

  Section getSectionModel() {
    return Section(
        id: id!,
        name: name!,
        totalGrade: totalGrade.value!,
        colorHex: colorhex,
        sectors: getSectorsModels());
  }

  void onAddNewSector() {
    if (sectorCumulativeGrade.value == totalGrade.value) {
      showSpecificNotificaiton(
          notifcationDetails:
              AppNotifcationsItems.thereAreNoMoreGradesLeftFromThisSection);
      return;
    }
    if (validateForm() &&
        validateAllSectorForms() &&
        !isCumulativeMoreThanTotalGrade) {
      sectors.add(
        SectorFormVM(sectionVM: this),
      );
      notifyListeners();
    }
  }

  bool validateAllSectorForms() {
    bool textWasAddedBefore = false;
    for (int i = 0; i < sectors.length; i++) {
      for (int j = i + 1; j < sectors.length; j++) {
        if (sectors[i].name?.isNotEmpty == true &&
            sectors[j].name?.isNotEmpty == true &&
            sectors[i].name?.trim().toLowerCase() ==
                sectors[j].name?.trim().toLowerCase()) {
          textWasAddedBefore = true;
          break;
        }
      }
    }

    if (textWasAddedBefore) {
      showSpecificNotificaiton(
          notifcationDetails:
              AppNotifcationsItems.sectorNamesShouldBeDifferent);
      return false;
    }

    bool returnedvalue = sectors.any((element) {
      if (element.realWeight == 0) {
        showSpecificNotificaiton(
            notifcationDetails: AppNotifcationsItems.sectorGradeCantBeZero);
        // returnedvalue = true;
        return true;
      }
      if (!element.validateForm()) {
        // returnedvalue = true;
        return true;
      }
      return false;
    });

    return !returnedvalue;
  }

  void callValidateSectorForms() {
    for (var element in sectors) {
      // element.notifyListeners();
      element.onUpdateSectionGrade();
    }
  }

  num getCumulativeSectorGradesAfterRemovingTheSectorThatsCallingThisFunction(
      {String? id}) {
    num sectorGrade = 0;

    for (var element in sectors) {
      if (element.id != id) sectorGrade += element.realWeight ?? 0;
    }
    return sectorGrade;
  }

  void onSectorRealWeightUpdate() {
    sectorCumulativeGrade.value =
        getCumulativeSectorGradesAfterRemovingTheSectorThatsCallingThisFunction();
    // callValidateSectorForms();
    if (sectorCumulativeGrade.value > (totalGrade.value ?? 0)) {
      isCumulativeMoreThanTotalGrade = true;
    } else if (isCumulativeMoreThanTotalGrade == true) {
      isCumulativeMoreThanTotalGrade = false;
    }
    notifyListeners();
  }

  Future<void> onDeleteSector(int index) async {
    sectors.removeAt(index);
    onSectorRealWeightUpdate();
    notifyListeners();
  }

  void addListenerToTotalGrade(VoidCallback listenerCallBack) {
    totalGrade.addListener(listenerCallBack);
  }

  void removeListenerToTotalGrade(VoidCallback listenerCallBack) {
    totalGrade.removeListener(listenerCallBack);
  }
}
