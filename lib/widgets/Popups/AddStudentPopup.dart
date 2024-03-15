import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/models/Student.dart';
import 'package:teachy_tec/screens/Students/StudentForm.dart';
import 'package:teachy_tec/screens/Students/StudentFormVM.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/widgets/AppButtons.dart';
import 'package:teachy_tec/widgets/showSpecificNotifications.dart';

class AddStudentPopup extends StatelessWidget {
  AddStudentPopup({
    super.key,
    required this.usersList,
  });
  final List<Student> usersList;
  final StudentFormVM studentFormVM = StudentFormVM.plain(
    gender: Gender.male,
    changeGeneralGenderSettings: (gender) {},
    onFinishEditingStudent: (student, isMale) {},
    onDeleteStudent: () {},
  );

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
                  AppLocale.addStudent
                      .getString(context)
                      .capitalizeFirstLetter(),
                  style: TextStyles.InterGrey700S16W600),
            ),
            StudentForm(model: studentFormVM),
            const SizedBox(height: kMainPadding),
            BottomPageButton(
              onTap: () {
                var currentItem = studentFormVM.onAddNewStudentButtonTapped();
                if (usersList.any((element) =>
                    element.name.trim().toLowerCase() ==
                    currentItem?.name.trim().toLowerCase())) {
                  showSpecificNotificaiton(
                      notifcationDetails:
                          AppNotifcationsItems.studentNamesDuplicated);
                  return;
                }
                if (currentItem != null) {
                  UIRouter.popScreen(
                      rootNavigator: true, argumentReturned: currentItem);
                }
              },
              // color: AppColors.black,
              addShadows: true,
              text: AppLocale.add.getString(context).capitalizeFirstLetter(),
            ),
            if (keyboardHeight > 0) SizedBox(height: keyboardHeight),
          ],
        ),
      ),
    );
  }
}
