import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Dashboard/StudentPreviewDashboadVM.dart';
import 'package:teachy_tec/screens/Dashboard/StudentPreviewInDashboard.dart';
import 'package:teachy_tec/screens/Students/SingleStudentForm.dart';
import 'package:teachy_tec/screens/Students/SingleStudentFormVM.dart';
import 'package:teachy_tec/screens/Students/studentDetailsScreenVM.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/widgets/Appbar.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class StudentDetailsScreen extends StatelessWidget {
  const StudentDetailsScreen({required this.model, super.key});
  final StudentDetailsScreenVM model;

  @override
  Widget build(BuildContext context) {
    double getCurrentUserGrade() {
      double userGrades = 0;
      var tasks = model.currentlyItem.entries.toList().isNotEmpty &&
              model.currentlyItem.entries.first.value?.values != null
          ? model.currentlyItem.entries.first.value!.values
          : null;

      tasks?.forEach((listOfTasks) {
        for (var task in listOfTasks) {
          userGrades += task.grade_value ?? 0;
        }
      });

      var allGrades =
          tasks?.fold(0, (count, innerList) => count + innerList.length) ?? 1;
      if (allGrades == 0) allGrades = 1;
      return (userGrades / allGrades) * 100;
    }

    String getAssetValue() {
      if (model.currentStudent.gender == Gender.male) {
        return 'assets/svg/male.svg';
      } else if (model.currentStudent.gender == Gender.female) {
        return 'assets/svg/female.svg';
      }
      return 'assets/svg/male.svg';
    }

    return ChangeNotifierProvider.value(
      value: model,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: CustomAppBar(
            screenName:
                AppLocale.studentDetails.getString(context).capitalizeAllWord(),
          ),
          body: Consumer<StudentDetailsScreenVM>(
            builder: (context, model, _) => SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: kMainPadding),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(kMainPadding),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primary700,
                          ),
                          shape: BoxShape.circle),
                      child: SvgPicture.asset(
                        getAssetValue(),
                        height: 60,
                      ),
                    ),
                  ),
                  // const SizedBox(height: 2),
                  DefaultContainer(
                    borderRadiusValue: 8,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                    color: AppColors.primary300,
                    child: Text(
                      model.currentStudent.gender == Gender.male
                          ? AppLocale.male
                              .getString(context)
                              .capitalizeFirstLetter()
                          : AppLocale.female
                              .getString(context)
                              .capitalizeFirstLetter(),
                      style: TextStyles.InterGrey900S10W500,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kMainPadding),
                    child: SingleStudentForm(
                      model: SingleStudentFormVM.preview(
                          studentModel: model.currentStudent,
                          // currentClass: model.,
                          onDeleteStudentCallback: model.onDeleteStudent,
                          onUpdateStudentCallback:
                              model.onUpdateStudentCallback),
                    ),
                  ),
                  const SizedBox(height: kMainPadding),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kMainPadding),
                    child: DottedBorder(
                        color: AppColors.grey300,
                        radius: const Radius.circular(12),
                        borderType: BorderType.RRect,
                        dashPattern: const <double>[6, 4],
                        strokeWidth: 2,
                        padding: const EdgeInsets.symmetric(
                            vertical: kMainPadding, horizontal: kMainPadding),
                        child: Row(
                          textDirection: AppUtility.getTextDirectionality(),
                          mainAxisAlignment: MainAxisAlignment.start,
                          // shrinkWrap: true,
                          // scrollDirection: Axis.vertical,
                          // reverse: AppUtility.isDirectionalitionalityLTR(),
                          children: [
                            Text(
                              AppLocale.myGrades
                                  .getString(context)
                                  .capitalizeFirstLetter(),
                              style: TextStyles.InterYellow700S16W500,
                              textAlign: TextAlign.start,
                            ),
                            const Spacer(),
                            Text(
                              AppLocale.accGrade
                                  .getString(context)
                                  .capitalizeFirstLetter(),
                              style: TextStyles.InterGrey900S14W700,
                            ),
                            const Text(
                              " :",
                              style: TextStyles.InterGrey900S14W700,
                            ),
                            const SizedBox(width: kInternalPadding),
                            Text(
                              "${getCurrentUserGrade().toStringAsFixed(1)}%",
                              style: TextStyles.InterGrey500S16W500,
                            )
                          ],
                        )

                        // Padding(
                        //   padding: const EdgeInsets.all(kBottomPadding),
                        //   child: Text(
                        //     'sdfa',
                        //     style: const TextStyle(
                        //       color: AppColors.grey200,
                        //     ),
                        //   ),
                        // ),
                        ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        vertical: kMainPadding, horizontal: kMainPadding),
                    itemBuilder: (context, index) {
                      var currentItem =
                          model.currentlyItem.entries.toList()[index];
                      return StudentPreviewInDashboard(
                        key: UniqueKey(),
                        model:
                            StudentPreviewInDashboardVM(isDetailsShown: true),
                        student: currentItem.key,
                        tasks: currentItem.value,
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: model.currentlyItem.entries.toList().length,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
