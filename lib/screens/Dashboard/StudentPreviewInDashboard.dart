// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/models/Student.dart';
import 'package:teachy_tec/models/Task.dart';
import 'package:teachy_tec/screens/Dashboard/StudentPreviewDashboadVM.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/widgets/BoardEmojisSelector.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class StudentPreviewInDashboard extends StatelessWidget {
  const StudentPreviewInDashboard({
    required this.student,
    required this.model,
    required this.tasks,
    super.key,
  });

  final Student student;
  final StudentPreviewInDashboardVM model;
  final Map<int, List<Task>>? tasks;

  @override
  Widget build(BuildContext context) {
    String getAssetValue() {
      if (student.gender == Gender.male) {
        return 'assets/svg/male.svg';
      } else if (student.gender == Gender.female) {
        return 'assets/svg/female.svg';
      }
      return 'assets/svg/male.svg';
    }

    double getCurrentUserGrade() {
      double userGrades = 0;
      tasks?.values.forEach((listOfTasks) {
        for (var task in listOfTasks) {
          userGrades += task.grade_value ?? 0;
        }
      });

      return userGrades;
    }

    return ChangeNotifierProvider.value(
      value: model,
      child: Column(
        children: [
          InkWell(
            onTap: model.togglePreviewDetails,
            child: DefaultContainer(
              decoration: BoxDecoration(
                color: AppColors.primary50,
                border: Border.all(
                  color: AppColors.primary500,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(
                  vertical: 20, horizontal: kMainPadding),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(kBottomPadding),
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: AppColors.primary700),
                        shape: BoxShape.circle),
                    child: SvgPicture.asset(
                      getAssetValue(),
                    ),
                  ),
                  const SizedBox(width: kBottomPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.name,
                          style: TextStyles.InterGrey800S12W400,
                        ),
                        const SizedBox(height: kInternalPadding),
                        if (tasks != null)
                          Row(
                            children: [
                              Text(
                                AppLocale.view
                                    .getString(context)
                                    .capitalizeFirstLetter(),
                                style: TextStyles.InterYellow700S12W600,
                              ),
                              const SizedBox(width: 4),
                              SvgPicture.asset(
                                'assets/svg/arrowDown.svg',
                                height: 8,
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: kInternalPadding),
                  if (tasks != null)
                    Row(
                      children: [
                        Text(
                          AppUtility.removeDecimalZeroFormat(
                              getCurrentUserGrade()),
                          style: TextStyles.InterGrey900S14W500,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '/${tasks?.values.fold(0, (count, innerList) => count + innerList.length)}',
                          style: TextStyles.InterGrey900S14W900,
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
          if (tasks != null)
            Consumer<StudentPreviewInDashboardVM>(
              builder: (context, model, _) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                reverseDuration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: !model.isDetailsShown
                    ? Container()
                    : DefaultContainer(
                        margin: const EdgeInsets.symmetric(
                          horizontal: kMainPadding,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: kInternalPadding,
                          vertical: kHelpingPadding,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.05),
                            spreadRadius: 2,
                            blurRadius: 1.5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: kBottomPadding),
                          itemCount: tasks?.entries.toList().length ?? 0,
                          itemBuilder: (context, index) {
                            var currentItem = tasks?.entries.toList()[index];
                            return _TaskListPreviewInStudentPrviewInDashboard(
                              key: UniqueKey(),
                              timestamp: currentItem?.key == null
                                  ? null
                                  : currentItem!.key,
                              tasks: currentItem?.value ?? [],
                            );
                          },
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TaskListPreviewInStudentPrviewInDashboard extends StatelessWidget {
  const _TaskListPreviewInStudentPrviewInDashboard(
      {required this.timestamp, required this.tasks, super.key});
  final int? timestamp;
  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var currentItem = tasks[index];
        return _TaskPreviewInStudentPrviewInDashboard(
          key: UniqueKey(),
          task: currentItem,
          timestamp: index == 0 ? timestamp : null,
          isLastItem: index == tasks.length - 1,
        );
      },
      // separatorBuilder: (context, index) => const SizedBox(height: 55),
      itemCount: tasks.length,
    );
  }
}

class _TaskPreviewInStudentPrviewInDashboard extends StatelessWidget {
  _TaskPreviewInStudentPrviewInDashboard(
      {this.timestamp, this.isLastItem = false, required this.task, super.key});
  final Task task;
  Emoji? emoji;
  final int? timestamp;
  final bool isLastItem;
  @override
  Widget build(BuildContext context) {
    emoji = task.emoji_id != null ? getEmojiById(task.emoji_id) : null;
    return Column(
      children: [
        if (timestamp != null)
          DefaultContainer(
            color: AppColors.primary300,
            boxShadow: kListShadowsArray,
            borderRadiusValue: 8,
            margin: const EdgeInsets.only(bottom: kBottomPadding),
            padding: const EdgeInsets.all(kHelpingPadding),
            child: Row(
              children: [
                Text(
                  AppUtility.appTimeFormat(
                      DateTime.fromMillisecondsSinceEpoch(timestamp!)),
                  style: TextStyles.InterGrey900S14W400,
                ),
              ],
            ),
          ),
        Container(
          decoration: const BoxDecoration(
            border: BorderDirectional(
              start: BorderSide(
                color: AppColors.primary700,
                width: 4.0,
              ),
            ),
          ),
          // margin: const EdgeInsets.only(left: kMainPadding),
          padding: EdgeInsets.only(
              top: timestamp == null ? 0 : kInternalPadding,
              bottom: isLastItem ? 0 : kInternalPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: kInternalPadding),
              Expanded(
                child: Text(
                  task.task,
                  style: TextStyles.InterBlackS14W400,
                ),
              ),
              if (emoji != null) ...[
                Image.asset(
                  emoji!.emojiPath.iconPath,
                  height: 40,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
