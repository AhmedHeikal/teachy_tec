import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teachy_tec/hive/controllers/activityController.dart';
import 'package:teachy_tec/hive/controllers/activityStudentsController.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/models/Activity.dart';
import 'package:teachy_tec/models/Class.dart';
import 'package:teachy_tec/models/Task.dart';
import 'package:teachy_tec/screens/Activity/ActivityForm.dart';
import 'package:teachy_tec/screens/Activity/ActivityFormVM.dart';
import 'package:teachy_tec/screens/Activity/DayTable.dart';
import 'package:teachy_tec/screens/Activity/DayTableVM.dart';
import 'package:teachy_tec/screens/Classes/ClassForm.dart';
import 'package:teachy_tec/screens/Classes/ClassFormVM.dart';
import 'package:teachy_tec/screens/networking/AppNetworkProvider.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/utils/Routing/AppAnalyticsConstants.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';
import 'package:teachy_tec/widgets/Popups/CreateClassForDashboradRequest.dart';
import 'package:teachy_tec/widgets/Popups/DeleteItemPopup.dart';
import 'package:teachy_tec/widgets/showSpecificNotifications.dart';

class ActivityScreenVM extends ChangeNotifier {
  List<Activity> activitiesList = [];
  ActivityScreenVM() {
    getActivities();
    ActivityStudentsController().saveLocalUnsavedActivityStudentsToServer();
  }

  DateTime selectedDay = AppUtility.removeTime(DateTime.now());
  DateTime startDay = AppUtility.removeTime(
      DateTime.now().toUtc().subtract(const Duration(days: 4)));
  DateTime endDay = AppUtility.removeTime(DateTime.now().toUtc());
  bool isMultiDaySelectionActive = true;
  bool isInitialized = false;

  void onToggleDaySelection(bool newValue) {
    if (newValue == isMultiDaySelectionActive) return;
    isMultiDaySelectionActive = newValue;
    getActivities();
    notifyListeners();
  }

  void onSelectDate(DateTime selectedDay) async {
    this.selectedDay = selectedDay;
    getActivities();
  }

  void onSelectDateRange(DateTime? startDate, DateTime? endDate) async {
    if (startDate == null || endDate == null) return;
    startDay = startDate;
    endDay = endDate;
    _getActivitiesInDateRange();
  }

  Future<Class?> onCreateNewClass() async {
    var acceptedToCreateClass =
        await UIRouter.showAppBottomDrawerWithCustomWidget(
            child: const CreateClassForDashboardRequest());

    if (acceptedToCreateClass == true) {
      var createdClass = await UIRouter.pushScreen(
          ClassForm(model: ClassFormVM()),
          pageName: AppAnalyticsConstants.ClassFormScreen);
      if (createdClass is Class) return createdClass;
    }
    return null;
  }

  Future<void> onAddActivityTapped() async {
    var classes = await serviceLocator<AppNetworkProvider>().getClassesList();
    if (classes.isEmpty) {
      var createdClass = await onCreateNewClass();
      if (createdClass is! Class) return;

      classes = [createdClass];
    }
    void addNewActivityCallback(Activity newActivity) {
      activitiesList.add(newActivity);
      isInitialized = true;
      notifyListeners();
    }

    var newActivity = await UIRouter.pushScreen(
        ActivityForm(
            model: ActivityFormVM(
                onAddNewActivity: addNewActivityCallback,
                pageDate:
                    DateUtils.dateOnly(selectedDay).millisecondsSinceEpoch)),
        pageName: AppAnalyticsConstants.ActivityForm);
    if (newActivity != null) {
      activitiesList.add(newActivity);
      isInitialized = true;
      notifyListeners();
    }
  }

  // Future<List<Class>> getClassesList() async {
  //   var classes = await serviceLocator<AppNetworkProvider>().getClassesList();

  //   return classes;
  // }

  Future<void> getActivities() async {
    if (isMultiDaySelectionActive) {
      _getActivitiesInDateRange();
    } else {
      _getActivities();
    }
  }

  Future<void> onDeleteActivity(Activity activity, bool is24HoursFormat) async {
    return await UIRouter.showAppBottomDrawerWithCustomWidget(
      bottomPadding: 0,
      child: DeleteItemPopup(
        onDeleteCallback: () async {
          UIRouter.popScreen(rootNavigator: true);
          UIRouter.showEasyLoader();

          await serviceLocator<AppNetworkProvider>().deleteActivity(
            activityId: activity.id,
            classId: activity.currentClass!.id!,
            pageDate: activity.timestamp,
          );

          await serviceLocator<AppNetworkProvider>().deleteFolderFromStorage(
              '${serviceLocator<FirebaseAuth>().currentUser!.uid}/Activities/${activity.id}');
          await ActivityController().deleteActivity(activity);
          await ActivityStudentsController().deleteActivity(activity);
          showSpecificNotificaiton(
              notifcationDetails:
                  AppNotifcationsItems.activityDeletedSuccessfully);
          getActivities();
          EasyLoading.dismiss(animation: true);
        },
        deleteMessage:
            "${AppLocale.areYouSureYouWantToDelete.getString(UIRouter.getCurrentContext()).capitalizeFirstLetter()} ${AppLocale.activity.getString(UIRouter.getCurrentContext()).toLowerCase()}${AppLocale.questionMark.getString(UIRouter.getCurrentContext())}",
        dangerAdviceText: AppLocale
            .deletingActivityPageWillResultInIrreversibleLossOfStudentsDegrees
            .getString(UIRouter.getCurrentContext())
            .capitalizeFirstLetter(),
        customWidget: Container(
          margin: const EdgeInsets.symmetric(horizontal: kMainPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  '${AppLocale.classVar.getString(UIRouter.getCurrentContext()).capitalizeFirstLetter()} ${activity.currentClass!.name}',
                  style: TextStyles.InterGrey500S16W600),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kMainPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/calendar.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColors.grey600,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                        AppUtility.appTimeFormat(
                            DateTime.fromMillisecondsSinceEpoch(
                                activity.timestamp)),
                        style: TextStyles.InterGrey700S14W400),
                    const Spacer(),
                    SvgPicture.asset(
                      'assets/svg/clock.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColors.grey600,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                        is24HoursFormat
                            ? AppUtility.getTwentyFourTimeFromSeconds(
                                activity.time,
                                inUtc: true,
                              )
                            : AppUtility.getAMPMTimeFromSeconds(
                                activity.time,
                                inUtc: true,
                              ),
                        style: TextStyles.InterGrey700S14W400),
                  ],
                ),
              ),
              const SizedBox(height: kBottomPadding),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onDuplicateActivity(Activity activity) async {
    UIRouter.pushScreen(
        ActivityForm(
            model: ActivityFormVM.duplicate(
                pageDate: activity.timestamp, model: activity)),
        pageName: AppAnalyticsConstants.ActivityForm);
  }

  Future<List<Activity>> _getActivities() async {
    UIRouter.showEasyLoader();

    activitiesList =
        await ActivityController().getActivitiesForCertainDate(selectedDay) ??
            [];

    await EasyLoading.dismiss(animation: true);
    isInitialized = true;
    notifyListeners();

    return activitiesList;
  }

  Future<List<Activity>> _getActivitiesInDateRange() async {
    UIRouter.showEasyLoader();

    activitiesList = await ActivityController()
            .getActivitiesForDateRange(startDay, endDay) ??
        [];

    await EasyLoading.dismiss(animation: true);
    isInitialized = true;
    notifyListeners();

    return activitiesList;
  }

  onOpenActivity(Activity currentActivity) async {
    UIRouter.showEasyLoader();
    if (currentActivity.students == null || currentActivity.students!.isEmpty) {
      var studentsInClass = await serviceLocator<AppNetworkProvider>()
          .getStudentsInClass(classId: currentActivity.currentClass?.id ?? '');
      currentActivity.students = studentsInClass;
    }

    var currentStudentActivity =
        await ActivityStudentsController().getSingleActivityStudents(
      activityId: currentActivity.id,
    );

    Map<String, List<Task>> studentsToTaskMap = {};
    currentStudentActivity?.studentTasks.forEach((key, value) {
      studentsToTaskMap[key] = value;
    });

    EasyLoading.dismiss(animation: true);
    await UIRouter.pushScreen(
      DayTable(
        model: DayTableVM(
          currentActivity: currentActivity,
          studentsToTaskMap: studentsToTaskMap,
        ),
      ),
      pageName: AppAnalyticsConstants.DayTableScreen,
    );
    getActivities();
  }
}
