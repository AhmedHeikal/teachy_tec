import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/models/TaskViewModel.dart';
import 'package:teachy_tec/screens/Activity/CustomQuestionForm.dart';
import 'package:teachy_tec/screens/Activity/CustomQuestionFormVM.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/widgets/AppButtons.dart';
import 'package:teachy_tec/widgets/FormParentClass.dart';
import 'package:uuid/uuid.dart';

class AddTaskPopup extends StatelessWidget {
  const AddTaskPopup({
    super.key,
    required this.model,
  });

  final AddTaskPopupVM model;

  @override
  Widget build(BuildContext context) {
    var keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    return InkWell(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          kMainPadding,
          kMainPadding,
          kMainPadding,
          0,
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kHelpingPadding),
              child: Text(
                  AppLocale.addTask.getString(context).capitalizeFirstLetter(),
                  style: TextStyles.InterGrey700S16W600),
            ),
            SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Container(
                    constraints: const BoxConstraints(maxHeight: 350),
                    child: model.currentWidget)),
            Container(
              padding: const EdgeInsets.only(
                top: kMainPadding,
              ),
              child: BottomPageButton(
                onTap: model.submitForm,
                // color: AppColors.black,
                addShadows: true,
                text: AppLocale.add.getString(context).capitalizeFirstLetter(),
              ),
            ),
            if (keyboardHeight > 0) SizedBox(height: keyboardHeight),
          ],
        ),
      ),
    );
  }
}

class AddTaskPopupVM extends ChangeNotifier with FormParentClass {
  final TaskType taskType;
  final List<String> taskLists;
  late CustomQuestionFormVM addSingleTaskFormVM;
  late Widget currentWidget;

  AddTaskPopupVM({
    required this.taskLists,
    required this.taskType,
  }) {
    if (taskType == TaskType.textOnly) {
      addSingleTaskFormVM =
          CustomQuestionFormVM.add(taskType: TaskType.textOnly);
    } else if (taskType == TaskType.trueFalse) {
      addSingleTaskFormVM =
          CustomQuestionFormVM.add(taskType: TaskType.trueFalse);
    } else {
      addSingleTaskFormVM =
          CustomQuestionFormVM.add(taskType: TaskType.multipleOptions);
    }

    currentWidget = CustomQuestionForm(
      model: addSingleTaskFormVM,
      isInPopUp: true,
      padding: EdgeInsets.zero,
    );
  }

  void submitForm() {
    Object? currentItem;
    if (addSingleTaskFormVM.validateForm_()) {
      if (taskLists
          .any((element) => element == addSingleTaskFormVM.question)) {}
      currentItem = TaskViewModel(
        id: const Uuid().v1(),
        task: addSingleTaskFormVM.question ?? '',
        imagePathLocally: addSingleTaskFormVM.image?.path,
        downloadUrl: addSingleTaskFormVM.questionVM?.downloadUrl,
        options: addSingleTaskFormVM.submitOptions(),
        taskType: taskType,
      );
    }
    if (currentItem != null) {
      UIRouter.popScreen(rootNavigator: true, argumentReturned: currentItem);
    }
  }
}
