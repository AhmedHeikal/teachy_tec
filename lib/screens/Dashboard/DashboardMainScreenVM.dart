import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Activity/ActivityScreenVM.dart';
import 'package:teachy_tec/screens/Dashboard/GradesScreenVM.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/utils/UIRouter.dart';

class DashboardMainScreenVM extends ChangeNotifier {
  String firstPageName = AppLocale.myGrades
      .getString(UIRouter.getCurrentContext())
      .capitalizeAllWord();
  String secondPageName = AppLocale.myActivities
      .getString(UIRouter.getCurrentContext())
      .capitalizeAllWord();
  late String currentPageName;
  bool isFirstPageChoosen = true;
  bool isMultiDaySelectionActive = true;
  GradesScreenVM gradesScreenVM = GradesScreenVM();
  ActivityScreenVM activityScreenVM = ActivityScreenVM();
  DateTime selectedDay = AppUtility.removeTime(DateTime.now());
  DateTime startDay =
      AppUtility.removeTime(DateTime.now().subtract(const Duration(days: 4)));
  DateTime endDay = AppUtility.removeTime(DateTime.now());

  DashboardMainScreenVM() {
    currentPageName = firstPageName;
  }

  void toggleSelectedButton(bool isFirstPage) {
    if ((isFirstPageChoosen && isFirstPage) ||
        (!isFirstPageChoosen && !isFirstPage)) return;
    isFirstPageChoosen = !isFirstPageChoosen;
    currentPageName = isFirstPageChoosen ? firstPageName : secondPageName;

    // Check if multi day active to load the page content directly
    if (isMultiDaySelectionActive) {
      if (currentPageName == firstPageName) {
        // For first Page (Grades)
        gradesScreenVM.onSelectDateRange(startDay, endDay);
      } else {
        // For second Page (Activity)
        activityScreenVM.onSelectDateRange(startDay, endDay);
      }
    } else {
      if (currentPageName == firstPageName) {
        // For first Page (Grades)
        gradesScreenVM.onSelectDate(selectedDay);
      } else {
        // For second Page (Activity)
        activityScreenVM.onSelectDate(selectedDay);
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void onChangeMultiDaySelectionCallback(bool multiDaySelectionValue) {
    isMultiDaySelectionActive = multiDaySelectionValue;
  }

  void onSelectDay(DateTime selectedDay) async {
    this.selectedDay = selectedDay;

    if (currentPageName == firstPageName) {
      gradesScreenVM.onSelectDate(selectedDay);
    } else {
      activityScreenVM.onSelectDate(selectedDay);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void onSelecDateRange(DateTime? startDay, DateTime? endDay) async {
    if (startDay == null || endDay == null) return;

    if (currentPageName == firstPageName) {
      gradesScreenVM.onSelectDateRange(startDay, endDay);
    } else {
      activityScreenVM.onSelectDateRange(startDay, endDay);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
