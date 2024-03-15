import 'package:flutter/cupertino.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/models/TaskViewModel.dart';
import 'package:teachy_tec/screens/Activity/CustomQuestionForm.dart';
import 'package:teachy_tec/screens/Activity/CustomQuestionFormVM.dart';
import 'package:teachy_tec/screens/Students/StudentForm.dart';
import 'package:teachy_tec/screens/Students/StudentFormVM.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
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
  late Widget firstItemWidget;
  late Widget secongItemWidget;

  initiatlizeWidgets() {
    firstItemWidget = Padding(
      padding: const EdgeInsets.fromLTRB(
        kMainPadding,
        0,
        kMainPadding,
        0,
      ),
      child: StudentForm(model: studentFormVM),
    );
    secongItemWidget = Padding(
      padding: const EdgeInsets.fromLTRB(
        kMainPadding,
        0,
        kMainPadding,
        0,
      ),
      child: CustomQuestionForm(
        model: addSingleTaskFormVM,
        isInPopUp: true,
        padding: EdgeInsets.zero,
      ),
    );
  }

  CustomQuestionFormVM addSingleTaskFormVM = CustomQuestionFormVM.add();

  AddNewItemToDayTableVM() {
    initiatlizeWidgets();
    currentPageName = firstPageName;
  }
  void onChangePageCallback(String pageName) {
    currentPageName = pageName;
  }

  void onSubmitForm() {
    Object? currentItem;
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
    if (currentItem != null) {
      UIRouter.popScreen(rootNavigator: true, argumentReturned: currentItem);
    }
  }
}
