import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teachy_tec/models/CustomQuestionOptionModel.dart';
import 'package:teachy_tec/models/TaskViewModel.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/widgets/FormParentClass.dart';
import 'package:teachy_tec/widgets/showSpecificNotifications.dart';
import 'package:uuid/uuid.dart';

class CustomQuestionFormVM extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  UnfocusDisposition disposition = UnfocusDisposition.scope;
  TaskViewModel? questionVM;
  var uuid = const Uuid();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  String? question;
  late bool addMedia;
  VoidCallback? onChange;
  List<QuestionOptionComponentVM> options = [];
  PlatformFile? image;
  TaskType taskType;

  bool isReadOnly;

  unFocusAllNodes() {
    primaryFocus!.unfocus(disposition: disposition);
  }

  void updateReadOnlyStatus(bool isReadOnly) {
    this.isReadOnly = isReadOnly;
    for (var element in options) {
      element.updateReadOnlyStatus(isReadOnly);
    }
    notifyListeners();
  }

  bool validateForm() {
    final result = formKey.currentState?.validate();
    if (result == false) {
      return false;
    }
    formKey.currentState?.save();
    return true;
  }

  void toggleIsLoading() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading.value = !isLoading.value;
    });
  }

  CustomQuestionFormVM.add({
    this.question,
    this.isReadOnly = false,
    this.taskType = TaskType.multipleOptions,
    // required this.isMultipleQuestion,
    this.addMedia = true,
  }) {
    if (taskType == TaskType.multipleOptions) {
      options = [
        QuestionOptionComponentVM(
          isCorrect: true,
          tasktype: taskType,
          isReadOnly: isReadOnly,
        ),
        QuestionOptionComponentVM(
          isCorrect: false,
          tasktype: taskType,
          isReadOnly: isReadOnly,
        ),
      ];
    } else if (taskType == TaskType.trueFalse) {
      options = [
        QuestionOptionComponentVM(
          isCorrect: true,
          tasktype: taskType,
          isReadOnly: isReadOnly,
        ),
      ];
    } else {
      options = [];
    }
  }

  CustomQuestionFormVM.edit({
    required this.questionVM,
    this.taskType = TaskType.multipleOptions,
    this.isReadOnly = false,
    this.onChange,
  }) {
    addMedia = true;

    question = questionVM!.task;

    for (int i = 0; i < (questionVM!.options?.length ?? 0); i++) {
      options.add(QuestionOptionComponentVM(
        option: questionVM!.options?[i],
        tasktype: taskType,
        isReadOnly: isReadOnly,
      ));
    }

    loadImage();
  }

  Future loadImage() async {
    if (questionVM!.downloadUrl != null) {
      Uint8List bytes =
          (await NetworkAssetBundle(Uri.parse(questionVM!.downloadUrl!))
                  .load(questionVM!.downloadUrl!))
              .buffer
              .asUint8List();
      image = PlatformFile(
        name: 'image',
        size: bytes.elementSizeInBytes,
        bytes: bytes,
      );
      notifyListeners();
    }
  }

  addAnOption({bool startWithTrue = false}) {
    if (validateOptionsForm()) {
      var newOption = CustomQuestionOptionModel(
        uuid.v1(),
        '',
        null,
        startWithTrue,
        null,
        null,
      );
      options.add(QuestionOptionComponentVM(
        option: newOption,
        tasktype: taskType,
        isReadOnly: isReadOnly,
      ));

      notifyListeners();
    }
  }

  List<CustomQuestionOptionModel> submitOptions() {
    List<CustomQuestionOptionModel> items = [];
    for (var element in options) {
      items.add(
        CustomQuestionOptionModel(
          (element.id ?? uuid.v1()),
          element.optionString ?? "",
          null,
          element.isCorrect!,
          element.option?.downloadUrl,
          element.image?.path,
        ),
      );
    }
    return items;
  }

  bool validateOptionsForm(/* {bool isLastElement = false} */) {
    bool textWasAddedBefore = false;
    for (int i = 0; i < options.length; i++) {
      for (int j = i + 1; j < options.length; j++) {
        if (options[i].optionString?.isNotEmpty == true &&
            options[j].optionString?.isNotEmpty == true &&
            options[i].optionString?.trim().toLowerCase() ==
                options[j].optionString?.trim().toLowerCase()) {
          textWasAddedBefore = true;
          break;
        }
      }
    }

    if (options.any((element) => !element.validate())) {
      return false;
    } else if (textWasAddedBefore) {
      showSpecificNotificaiton(
          notifcationDetails:
              AppNotifcationsItems.customQuestionOptionDuplicated);
      return false;
    }
    return true;
  }

  bool validateForm_() {
    if (!validateForm()) {
      return false;
    } else if (taskType == TaskType.multipleOptions) {
      if (options.length < 2) {
        showSpecificNotificaiton(
            notifcationDetails:
                AppNotifcationsItems.CustomQuestionOptionsNotComplete);
        // showNotification(
        //     UIRouter.getCurrentContext(), 'We need to have two options atleast');
        return false;
      } else if (options.every((element) => !(element.isCorrect ?? false))) {
        showSpecificNotificaiton(
            notifcationDetails:
                AppNotifcationsItems.CustomQuestionNoCorrectOption);
        // showNotification(
        //     UIRouter.getCurrentContext(), 'We need to have two options atleast');
        return false;
      } else if (options.every((element) => (element.isCorrect ?? false))) {
        showSpecificNotificaiton(
            notifcationDetails:
                AppNotifcationsItems.CustomQuestionNoIncorrectOption);

        return false;
      } else if (!validateOptionsForm()) {
        // showNotification(UIRouter.getCurrentContext(),
        //     'One or more options doesn\'t have body');
        return false;
      }
    }

    return true;
  }

  void onDeleteOption(int index) {
    options.removeAt(index);
    // if (questionVM != null) {
    //   questionVM!.customOptions.removeAt(index);
    //   if (onChange != null) onChange!();
    // }
    // if (onChange != null) onChange!();
    notifyListeners();
  }
}

class QuestionOptionComponentVM extends ChangeNotifier with FormParentClass {
  PlatformFile? image;
  String? optionString;
  String? id;
  bool? isCorrect;
  CustomQuestionOptionModel? option;
  final VoidCallback? onSelectItem;
  final TaskType tasktype;
  bool isReadOnly;
  QuestionOptionComponentVM({
    this.isCorrect = false,
    this.isReadOnly = false,
    this.tasktype = TaskType.multipleOptions,
    this.option,
    this.onSelectItem,
  }) {
    if (option != null) {
      isCorrect = option!.isCorrect;
      optionString = option!.name;
      id = option!.id;
      loadImage();
    }
  }

  Future loadImage() async {
    if (option!.downloadUrl != null) {
      Uint8List bytes =
          (await NetworkAssetBundle(Uri.parse(option!.downloadUrl!))
                  .load(option!.downloadUrl!))
              .buffer
              .asUint8List();
      image = PlatformFile(
        name: 'option!.downloadUrl',
        size: bytes.elementSizeInBytes,
        bytes: bytes,
      );
      notifyListeners();
    }
  }

  QuestionOptionComponentVM.old({
    required this.option,
    this.isReadOnly = false,
    this.tasktype = TaskType.multipleOptions,
    this.onSelectItem,
  }) {
    optionString = option!.name;
    id = option!.id;
    isCorrect = option!.isCorrect;
  }

  void onselectTrueOrFalseInTrueFalseQuestion(bool answerSelcted) {
    isCorrect = answerSelcted;
    option?.isCorrect = answerSelcted;

    notifyListeners();
  }

  void updateReadOnlyStatus(bool isReadOnly) async {
    this.isReadOnly = isReadOnly;
    notifyListeners();
  }

  bool validate() => validateForm();
}
