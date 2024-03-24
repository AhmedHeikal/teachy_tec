import 'package:flutter/foundation.dart';
import 'package:teachy_tec/models/Sector.dart';
import 'package:teachy_tec/screens/Grades/SectionComponentVM.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/widgets/FormParentClass.dart';
import 'package:uuid/uuid.dart';

class SectorFormVM extends ChangeNotifier with FormParentClass {
  SectorFormVM({
    required this.sectionVM,
  }) {
    id = uuid.v1();
    currentRemainingGrade = (sectionVM.totalGrade.value ?? 0) -
        sectionVM
            .getCumulativeSectorGradesAfterRemovingTheSectorThatsCallingThisFunction(
                id: id);
    sectionVM.addListenerToTotalGrade(onUpdateSectionGrade);
  }

  String? id;
  var uuid = const Uuid();
  String? name;
  num? realWeight;
  num? percentageWeight;
  SectionComponentVM sectionVM;
  bool? isDisabled;
  num? currentRemainingGrade;

  onUpdateSectionGrade() {
    currentRemainingGrade = (sectionVM.totalGrade.value ?? 0) -
        sectionVM
            .getCumulativeSectorGradesAfterRemovingTheSectorThatsCallingThisFunction(
                id: id);
    onRealWeightUpdate(realWeight?.toString());
    if (sectionVM.totalGrade.value == null ||
        sectionVM.totalGrade.value == 0 ||
        sectionVM.isCumulativeMoreThanTotalGrade) {
      isDisabled = true;
      percentageWeight = 0;
      notifyListeners();
    } else if (isDisabled == true) {
      isDisabled = false;
      notifyListeners();
    }
  }

  void onRealWeightUpdate(String? realWeightValue /* , num totalGrade */) {
    if (realWeightValue == null) return;
    realWeight = num.tryParse(realWeightValue);

    if (realWeight == null) return;

    realWeight = AppUtility.doubleWithoutDecimalToInt(realWeight!);
    // if ((realWeight ?? 0) > (currentTotalGradeOfSection ?? 0)) {
    //   realWeight = currentTotalGradeOfSection;
    // }
    sectionVM.onSectorRealWeightUpdate();

    percentageWeight = AppUtility.doubleWithoutDecimalToInt(num.tryParse(
            ((realWeight! /
                        (sectionVM.totalGrade.value ?? 1) /* / totalGrade */) *
                    100)
                .toStringAsFixed(2)) ??
        0);
    notifyListeners();
  }

  Sector getSectorModel() {
    return Sector(
        id: id!,
        name: name!,
        percentageWeight: percentageWeight ?? 0,
        realWeight: realWeight ?? 0);
  }

  void onPercentageWeight(String? percentageValue /* , num totalGrade */) {
    if (percentageValue == null) return;
    percentageWeight = double.tryParse(percentageValue);
    if (percentageWeight == null) return;
    percentageWeight = AppUtility.doubleWithoutDecimalToInt(percentageWeight!);
    realWeight = AppUtility.doubleWithoutDecimalToInt(num.tryParse(
            ((percentageWeight! *
                        (sectionVM.totalGrade.value ?? 1) /* * totalGrade */) /
                    100)
                .toStringAsFixed(2)) ??
        0);

    notifyListeners();
  }
}
