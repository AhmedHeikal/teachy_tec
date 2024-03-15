import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/models/TaskViewModel.dart';
import 'package:teachy_tec/screens/Activity/CustomQuestionFormVM.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:uuid/uuid.dart';

class CustomQuestionComponentVM extends ChangeNotifier {
  List<CustomQuestionFormVM> questions = [];
  var uuid = const Uuid();
  bool isTasksReadOnlyInEditMode = false;
  initialQuestionsListFromOldModel(
    List<TaskViewModel>? items,
  ) {
    items?.forEach((element) {
      questions.add(CustomQuestionFormVM.edit(
        questionVM: element,
        isReadOnly: isTasksReadOnlyInEditMode,
        taskType: element.taskType ?? TaskType.multipleOptions,
      ));
    });
    notifyListeners();
  }

  void updateTasksReadOnlyInEditMode(bool isTasksReadOnlyInEditMode) {
    this.isTasksReadOnlyInEditMode = isTasksReadOnlyInEditMode;
    for (var element in questions) {
      element.updateReadOnlyStatus(isTasksReadOnlyInEditMode);
    }
    notifyListeners();
  }

  onAddMultipleAnswersQuestion() {
    if (validateAllForms()) {
      UIRouter.showAppBottomDrawer(
        options: [
          InkWell(
            onTap: () async {
              UIRouter.popScreen(rootNavigator: true);
              questions
                  .add(CustomQuestionFormVM.add(taskType: TaskType.textOnly));
              notifyListeners();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: kMainPadding),
                SvgPicture.asset(
                  "assets/svg/textQuestion.svg",
                  color: AppColors.primary700,
                  height: 20,
                  width: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocale.textQuestion
                      .getString(UIRouter.getCurrentContext())
                      .capitalizeFirstLetter(),
                  style: TextStyles.InterBlackS16W400,
                )
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              UIRouter.popScreen(rootNavigator: true);
              questions.add(
                  CustomQuestionFormVM.add(taskType: TaskType.multipleOptions));
              notifyListeners();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: kMainPadding),
                SvgPicture.asset(
                  "assets/svg/multipleOptions.svg",
                  color: AppColors.primary700,
                  height: 24,
                  width: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocale.multipleOptionsQuestion
                      .getString(UIRouter.getCurrentContext())
                      .capitalizeFirstLetter(),
                  style: TextStyles.InterBlackS16W400,
                )
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              UIRouter.popScreen(rootNavigator: true);
              questions
                  .add(CustomQuestionFormVM.add(taskType: TaskType.trueFalse));
              notifyListeners();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: kMainPadding),
                SvgPicture.asset("assets/svg/trueFalse2.svg",
                    color: AppColors.primary700, height: 22, width: 22),
                const SizedBox(width: 8),
                Text(
                  AppLocale.trueFalseQuestion
                      .getString(UIRouter.getCurrentContext())
                      .capitalizeFirstLetter(),
                  style: TextStyles.InterBlackS16W400,
                )
              ],
            ),
          ),
        ],
      );
    }
  }

  void addFromExistingQuestionVM(TaskViewModel? questionVM) {
    questions.add(
      CustomQuestionFormVM.edit(
        questionVM: questionVM,
        taskType: questionVM?.taskType ?? TaskType.multipleOptions,
      ),
    );
    notifyListeners();
  }

  // onAddMultipleAnswersQuestion() {
  //   if (validateAllForms()) {
  //     questions.add(
  //       CustomQuestionFormVM.add(),
  //     );
  //     notifyListeners();
  //   }
  // }

  validateAllForms() {
    if (questions.any((element) => !element.validateForm_())) return false;
    return true;
  }

  List<TaskViewModel> submitForms() {
    List<TaskViewModel> items = [];

    if (validateAllForms()) {
      for (var element in questions) {
        items.add(TaskViewModel(
            id: uuid.v1(),
            task: element.question ?? '',
            imagePathLocally: element.image?.path,
            downloadUrl: element.questionVM?.downloadUrl,
            taskType: element.taskType,
            options: element.submitOptions()));
      }
    }
    return items;
  }

  Future<void> onDeleteQuestion(int index) async {
    var question = questions.elementAt(index);
    question.toggleIsLoading();
    bool? isDeleted = true;
    // if (question.questionVM != null &&
    //     question.questionVM!.id != null &&
    //     question.questionVM!.id != 0) {}
    // isDeleted = await serviceLocator<TomatoNetworkProvider>()
    //     .DeleteCustomQuestion(id: question.questionVM!.id!);
    if (isDeleted == true) {
      questions.removeAt(index);
      notifyListeners();
    }
    question.toggleIsLoading();
  }

  // onAddYesNoQuestion() {
  //   questions.add(
  //     CustomQuestionFormVM(
  //       isMultipleQuestion: false,
  //     ),
  //   );
  //   notifyListeners();
  // }
}
