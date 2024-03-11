import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Students/SingleStudentFormVM.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/AppButtons.dart';
import 'package:teachy_tec/widgets/CustomizedDropdown.dart';
import 'package:teachy_tec/widgets/InputTitle.dart';
import 'package:teachy_tec/widgets/RoundedTextField.dart';

class SingleStudentForm extends StatelessWidget {
  const SingleStudentForm(
      {this.addKeyboardHeight = false, required this.model, super.key});
  final SingleStudentFormVM model;
  final bool addKeyboardHeight;
  @override
  Widget build(BuildContext context) {
    var keyboardHeight =
        addKeyboardHeight ? MediaQuery.viewInsetsOf(context).bottom : null;

    return ChangeNotifierProvider.value(
      value: model,
      child: Form(
        key: model.formKey,
        child: Consumer<SingleStudentFormVM>(
          builder: (context, model, _) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  duration: const Duration(milliseconds: 400),
                  reverseDuration: const Duration(milliseconds: 300),
                  child: model.isPreview == true
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () =>
                                      model.togglePreview(isPreview: false),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: kInternalPadding),
                                    child: SvgPicture.asset(
                                      'assets/svg/pen.svg',
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.primary700,
                                        BlendMode.srcIn,
                                      ),
                                      height: 33,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: model.deleteStudent,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: kInternalPadding),
                                    child: SvgPicture.asset(
                                      'assets/svg/bin.svg',
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.primary700,
                                        BlendMode.srcIn,
                                      ),
                                      height: 38,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InputTitle(
                              title: AppLocale.fullName
                                  .getString(context)
                                  .capitalizeAllWord()),
                          const SizedBox(height: 2),
                          RoundedInputField(
                            hintText: AppLocale.fullName
                                .getString(context)
                                .capitalizeAllWord(),
                            isReadOnly: model.isPreview,
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
                if (model.isPreview != false || model.isInClass == true) ...[
                  const SizedBox(height: kBottomPadding),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputTitle(
                          title: AppLocale.className
                              .getString(context)
                              .capitalizeAllWord()),
                      const SizedBox(height: 2),
                      model.isPreview == true || model.isInClass == true
                          ? RoundedInputField(
                              hintText: AppLocale.className
                                  .getString(context)
                                  .capitalizeAllWord(),
                              isReadOnly: true,
                              text: model.selectedClass?.name ??
                                  model.selectedClass?.name,
                              isEmptyValidation: true,
                              textInputAction: TextInputAction.next,
                              onChanged: (input) {
                                model.name = input;
                              },
                            )
                          : ValueListenableBuilder<bool>(
                              valueListenable: model.isClassesLoading,
                              builder: (context, isLoading, child) {
                                return CustomizedDropdown(
                                  emptyChoiceText: AppLocale.loading
                                      .getString(context)
                                      .capitalizeAllWord(),
                                  emptyChoiceChosenText: AppLocale.loading
                                      .getString(context)
                                      .capitalizeAllWord(),
                                  chosenItem: model.selectedClass?.name,
                                  items: (model.classes ?? [])
                                      .map((e) => e.name)
                                      .toList(),
                                  onChange: (name, index) {
                                    model.onSelectClass(name);
                                  },
                                );
                              },
                            ),
                    ],
                  ),
                ],
                const SizedBox(height: kBottomPadding),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputTitle(
                      title: AppLocale.gender
                          .getString(context)
                          .capitalizeAllWord(),
                    ),
                    const SizedBox(height: kHelpingPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: model.isPreview ?? false
                              ? null
                              : () => model.onGenderChange(Gender.male),
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
                          onTap: model.isPreview ?? false
                              ? null
                              : () => model.onGenderChange(Gender.female),
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
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  reverseDuration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: model.showActionButtons
                      ? Column(
                          children: [
                            const SizedBox(height: kMainPadding),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BottomPageButton(
                                  color: Colors.transparent,
                                  textStyle: TextStyles.InterGrey900S16W600,
                                  borderColor: AppColors.grey900,
                                  onTap: () =>
                                      model.togglePreview(isPreview: true),
                                  text: AppLocale.cancel
                                      .getString(context)
                                      .capitalizeFirstLetter(),
                                ),
                                const SizedBox(width: kBottomPadding),
                                BottomPageButton(
                                  onTap: model.isPreview == null
                                      ? model.addNewstudent
                                      : model.editNewStudent,
                                  text: AppLocale.save
                                      .getString(context)
                                      .capitalizeFirstLetter(),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                ),
                if ((keyboardHeight ?? 0) > 0) SizedBox(height: keyboardHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
