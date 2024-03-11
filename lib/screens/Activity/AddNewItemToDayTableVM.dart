import 'package:flutter/cupertino.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/models/TaskViewModel.dart';
import 'package:teachy_tec/screens/Activity/CustomQuestionFormVM.dart';
import 'package:teachy_tec/screens/Students/StudentFormVM.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:uuid/uuid.dart';

class AddNewItemToDayTableVM extends ChangeNotifier {
  String secondPageName = AppLocale.addTask
      .getString(UIRouter.getCurrentContext())
      .capitalizeAllWord();
  String firstPageName = AppLocale.addStudent
      .getString(UIRouter.getCurrentContext())
      .capitalizeAllWord();
  var uuid = const Uuid();

  late String currentPageName;
  StudentFormVM studentFormVM = StudentFormVM.plain(
    gender: Gender.male,
    changeGeneralGenderSettings: (gender) {},
    onFinishEditingStudent: (student, isMale) {},
    onDeleteStudent: () {},
  );
  CustomQuestionFormVM addSingleTaskFormVM = CustomQuestionFormVM.add();

  AddNewItemToDayTableVM() {
    currentPageName = firstPageName;
  }
  void onChangePageCallback(String pageName) {
    currentPageName = pageName;
  }

  void onSubmitForm() {
    var currentItem;
    if (currentPageName == firstPageName) {
      currentItem = studentFormVM.onAddNewStudentButtonTapped();
    } else {
      if (addSingleTaskFormVM.validateForm_()) {
        currentItem = TaskViewModel(
            id: uuid.v1(),
            task: addSingleTaskFormVM.question ?? '',
            imagePathLocally: addSingleTaskFormVM.image?.path,
            downloadUrl: addSingleTaskFormVM.questionVM?.downloadUrl,
            options: addSingleTaskFormVM.submitOptions());
      }
      // ddSingleTaskFormVM.submitOptions();
    }
    if (currentItem != null)
      UIRouter.popScreen(rootNavigator: true, argumentReturned: currentItem);
  }
}
