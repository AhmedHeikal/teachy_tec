import 'package:flutter/material.dart';
import 'package:teachy_tec/models/TaskViewModel.dart';
import 'package:teachy_tec/screens/Activity/CustomQuestionFormVM.dart';
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
          questionVM: element, isReadOnly: isTasksReadOnlyInEditMode));
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

  void addFromExistingQuestionVM(TaskViewModel? questionVM) {
    questions.add(
      CustomQuestionFormVM.edit(
        questionVM: questionVM,
      ),
    );
    notifyListeners();
  }

  onAddMultipleAnswersQuestion() {
    if (validateAllForms()) {
      questions.add(
        CustomQuestionFormVM.add(),
      );
      notifyListeners();
    }
  }

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
