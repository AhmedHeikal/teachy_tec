import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Activity/ActivityFormVM.dart';
import 'package:teachy_tec/screens/Activity/CustomQuestionComponent.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/widgets/AdviceContainer.dart';
import 'package:teachy_tec/widgets/AppButtons.dart';
import 'package:teachy_tec/widgets/AppPickers.dart';
import 'package:teachy_tec/widgets/Appbar.dart';
import 'package:teachy_tec/widgets/CustomizedDropdown.dart';
import 'package:teachy_tec/widgets/InputTitle.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';
// import 'package:teachy_tec/widgets/RoundedTextField.dart';

class ActivityForm extends StatelessWidget {
  const ActivityForm({required this.model, super.key});
  final ActivityFormVM model;
  @override
  Widget build(BuildContext context) {
    // var keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    bool is24HoursFormat = MediaQuery.alwaysUse24HourFormatOf(context);

    return ChangeNotifierProvider.value(
      value: model,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.grey50,
          appBar: CustomAppBar(
            screenName:
                AppLocale.newBoard.getString(context).capitalizeFirstLetter(),
          ),
          bottomNavigationBar: AppBottomNavCustomWidget(
            child: BottomPageButton(
              onTap: model.oldModel != null
                  ? model.onEditModel
                  : model.addNewActivityToTeacher,
              text: model.oldModel != null
                  ? AppLocale.save.getString(context).capitalizeFirstLetter()
                  : AppLocale.create.getString(context).capitalizeFirstLetter(),
            ),
          ),
          body: SafeArea(
            child: Form(
              key: model.formKey,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: kMainPadding),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: kBottomPadding),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InputTitle(
                                  title: AppLocale.className
                                      .getString(context)
                                      .capitalizeFirstLetter(),
                                ),
                                const SizedBox(height: 2),
                                Consumer<ActivityFormVM>(
                                  builder: (context, model, _) {
                                    return ValueListenableBuilder<bool>(
                                      valueListenable: model.isClassesLoading,
                                      builder: (context, isLoading, child) {
                                        return CustomizedDropdown(
                                          isEnabled: model.oldModel == null,
                                          emptyChoiceText: AppLocale.loading
                                              .getString(context)
                                              .capitalizeFirstLetter(),
                                          emptyChoiceChosenText: AppLocale
                                              .loading
                                              .getString(context)
                                              .capitalizeFirstLetter(),
                                          chosenItem: model.selectedClass?.name,
                                          items: (model.classes ?? [])
                                              .map((e) => e.name)
                                              .toList(),
                                          onChange: (name, index) {
                                            model.onSelectClass(name);
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: kBottomPadding),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InputTitle(
                                  title: AppLocale.time
                                      .getString(context)
                                      .capitalizeFirstLetter(),
                                ),
                                const SizedBox(height: 2),
                                Consumer<ActivityFormVM>(
                                  builder: (context, model, _) => InkWell(
                                    onTap: () async {
                                      await UIRouter
                                          .showAppBottomDrawerWithCustomWidget(
                                        child: is24HoursFormat
                                            ? twentyFourTimePicker(
                                                initialValue:
                                                    model.selectedTimeInLocal,
                                                callbackFunction:
                                                    model.onSelectTime,
                                                isUTCSameAsLocalTime: false,
                                                title: AppLocale.time
                                                    .getString(context)
                                                    .capitalizeFirstLetter(),
                                              )
                                            : AmPmDayTimePicker(
                                                initialValue:
                                                    model.selectedTimeInLocal,
                                                isUTCSameAsLocalTime: false,
                                                callbackFunction:
                                                    model.onSelectTime,
                                                title: AppLocale.time
                                                    .getString(context)
                                                    .capitalizeFirstLetter(),
                                              ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kHelpingPadding,
                                          vertical: 10),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: AppColors.white,
                                          border: Border.all(
                                              color: AppColors.grey200),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(
                                        is24HoursFormat
                                            ? AppUtility
                                                .getTwentyFourTimeFromSeconds(
                                                model.selectedTimeInLocal,
                                                inUtc: true,
                                              )
                                            : AppUtility.getAMPMTimeFromSeconds(
                                                model.selectedTimeInLocal,
                                                inUtc: true,
                                              ),
                                        style: model.pageDate == 0
                                            ? TextStyles.InterGrey400S14W400
                                            : TextStyles.InterGrey700S14W400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: kHelpingPadding),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InputTitle(
                                  title: AppLocale.date
                                      .getString(context)
                                      .capitalizeFirstLetter(),
                                ),
                                const SizedBox(height: 2),
                                Consumer<ActivityFormVM>(
                                  builder: (context, model, _) => InkWell(
                                    onTap: () async {
                                      return await UIRouter
                                          .showAppBottomDrawerWithCustomWidget(
                                        child: DatePickerBottomDrawer(
                                          drawerTile: AppLocale.currentDate
                                              .getString(context)
                                              .capitalizeFirstLetter(),
                                          //  'Birthday',
                                          saveFunction: model.setPageDate,
                                          initialValue: model.pageDate == 0 ||
                                                  (model.pageDate) < 0
                                              ? DateTime.now()
                                              : DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      model.pageDate),
                                          firstDate: DateTime
                                              .fromMillisecondsSinceEpoch(0),
                                          lastDate: DateTime
                                              .now() /* .subtract(Duration()) */,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kHelpingPadding,
                                          vertical: 10),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: AppColors.white,
                                          border: Border.all(
                                              color: AppColors.grey200),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(
                                        model.pageDate == 0
                                            ? "Mm d, YYYY"
                                            : AppUtility.appTimeFormat(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    model.pageDate)),
                                        style: model.pageDate == 0
                                            ? TextStyles.InterGrey400S14W400
                                            : TextStyles.InterGrey700S14W400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: kBottomPadding),
                      DefaultContainer(
                        height: 30,
                        borderRadiusValue: 8,
                        width: double.infinity,
                        color: AppColors.grey50,
                        child: Center(
                          child: Container(
                            width: 50,
                            height: 4,
                            color: AppColors.grey300,
                          ),
                        ),
                      ),
                      Consumer<ActivityFormVM>(
                        builder: (context, model, _) => model
                                        .isTasksReadOnlyInEditMode ==
                                    true &&
                                model.oldModel != null
                            ? DefaultContainer(
                                margin:
                                    const EdgeInsets.only(top: kMainPadding),
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    AdviceText(
                                      text: AppLocale
                                          .youCantEditTasksAsThereAreGradesAssignedToThoseTasks
                                          .getString(context)
                                          .capitalizeFirstLetter(),
                                      additionalWidgetInTheBottomOfAdvice:
                                          Column(
                                        children: [
                                          const SizedBox(height: 20),
                                          Text(
                                            AppLocale
                                                .youCanClearAllGradesByPressingTheButtonBelow
                                                .getString(context)
                                                .capitalizeFirstLetter(),
                                          ),
                                          const SizedBox(
                                              height: kHelpingPadding),
                                          Container(
                                            margin: const EdgeInsetsDirectional
                                                .only(end: kMainPadding),
                                            child: BottomPageButton(
                                              onTap: model
                                                  .onClearCurrentStudentTasks,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 10,
                                                horizontal: kMainPadding,
                                              ),
                                              textStyle: TextStyles
                                                  .InterYellow700S14W500,
                                              text: AppLocale
                                                  .deleteStudentGrades
                                                  .getString(context)
                                                  .capitalizeFirstLetter(),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ),
                      // const SizedBox(height: kBottomPadding),
                      Consumer<ActivityFormVM>(
                        builder: (context, model, _) => CustomQuestionComponent(
                          model: model.customQuestionVM,
                        ),
                      ),
                      // CustomQuestionForm(model: model.optionsModel),
                      const SizedBox(height: kBottomPadding),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
