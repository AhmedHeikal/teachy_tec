import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Students/StudentFormVM.dart';

import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/RoundedTextField.dart';

class StudentForm extends StatelessWidget {
  const StudentForm({required this.model, super.key});
  final StudentFormVM model;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: SafeArea(
        bottom: false,
        child: Form(
          key: model.formKey,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocale.fullName.getString(context).toUpperCase(),
                            style: TextStyles.InterGrey600S12W600,
                          ),
                          const SizedBox(height: 2),
                          RoundedInputField(
                            hintText: AppLocale.fullName
                                .getString(context)
                                .capitalizeFirstLetter(),
                            text: model.name,
                            isEmptyValidation: true,
                            textInputAction: TextInputAction.next,
                            onChanged: (input) {
                              model.name = input;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: kHelpingPadding),
                  ],
                ),
                const SizedBox(height: kBottomPadding),
                Consumer<StudentFormVM>(
                  builder: (context, model, _) => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocale.gender.getString(context).toUpperCase(),
                        style: TextStyles.InterGrey600S12W600,
                      ),
                      const SizedBox(height: kHelpingPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () => model.onGenderChange(Gender.male),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  (model.gender == Gender.male)
                                      ? 'assets/svg/activeRadioButton.svg'
                                      : 'assets/svg/inActiveRadioButton.svg',
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(width: kInternalPadding),
                                Text(
                                  AppLocale.male
                                      .getString(context)
                                      .capitalizeFirstLetter(),
                                  style: TextStyles.InterBlackS16W400,
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => model.onGenderChange(Gender.female),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 22),
                                SvgPicture.asset(
                                  (model.gender == Gender.female)
                                      ? 'assets/svg/activeRadioButton.svg'
                                      : 'assets/svg/inActiveRadioButton.svg',
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(width: kInternalPadding),
                                Text(
                                  AppLocale.female
                                      .getString(context)
                                      .capitalizeFirstLetter(),
                                  style: TextStyles.InterBlackS16W400,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kBottomPadding),
                if (model.isPlain != true) ...[
                  const SizedBox(height: kMainPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Spacer(),
                      InkWell(
                          onTap: () =>
                              model.onCompleteButtonTapped(context: context),
                          child:
                              SvgPicture.asset('assets/svg/roundedCheck.svg')),
                      const SizedBox(width: kMainPadding),
                      InkWell(
                          onTap: () => model.onAddNewStudentButtonTapped(
                              context: context),
                          child: SvgPicture.asset(
                              'assets/svg/roundedAddStudent.svg')),
                      const SizedBox(width: kMainPadding),
                      InkWell(
                          onTap: model.onDeleteStudent,
                          child: SvgPicture.asset('assets/svg/roundedBin.svg')),
                      const Spacer(),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
