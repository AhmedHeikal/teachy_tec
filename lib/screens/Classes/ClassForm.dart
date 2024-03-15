import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Classes/ClassFormVM.dart';
import 'package:teachy_tec/screens/Students/StudentsComponent.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/AppButtons.dart';
import 'package:teachy_tec/widgets/Appbar.dart';
import 'package:teachy_tec/widgets/InputTitle.dart';
import 'package:teachy_tec/widgets/RoundedTextField.dart';

class ClassForm extends StatelessWidget {
  const ClassForm({required this.model, super.key});
  final ClassFormVM model;
  @override
  Widget build(BuildContext context) {
    // var keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ChangeNotifierProvider.value(
        value: model,
        child: Scaffold(
          appBar: CustomAppBar(
              screenName: model.oldClass == null
                  ? AppLocale.newClass.getString(context).capitalizeAllWord()
                  : AppLocale.editClass.getString(context).capitalizeAllWord()),
          bottomNavigationBar: AppBottomNavCustomWidget(
            child: BottomPageButton(
              onTap: model.oldClass == null
                  ? model.addNewClassToTeacher
                  : model.editClassToTeacher,
              text: model.oldClass == null
                  ? AppLocale.create.getString(context).capitalizeAllWord()
                  : AppLocale.save.getString(context).capitalizeAllWord(),
            ),
          ),
          body: Form(
            key: model.formKey,
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kMainPadding,
                    vertical: kBottomPadding,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: kBottomPadding),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InputTitle(
                                    title: AppLocale.className
                                        .getString(context)
                                        .capitalizeAllWord()),
                                const SizedBox(height: 2),
                                Consumer<ClassFormVM>(
                                  builder: (context, model, _) =>
                                      RoundedInputField.classField(
                                    hintText: AppLocale.title
                                        .getString(context)
                                        .toLowerCase(),
                                    classesNames: model.currentClasses
                                        .map((e) => e.name)
                                        .toList(),
                                    text: model.className,
                                    isEmptyValidation: true,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (input) {
                                      model.className = input;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: kHelpingPadding),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InputTitle(
                                    title: AppLocale.gradeLevel
                                        .getString(context)
                                        .capitalizeAllWord()),
                                const SizedBox(height: 2),
                                RoundedInputField(
                                  hintText: AppLocale.egTenthGrade
                                      .getString(context)
                                      .capitalizeAllWord(),
                                  text: model.gradeLevel,
                                  // isEmptyValidation: true,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (input) {
                                    model.gradeLevel = input;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: kBottomPadding),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InputTitle(
                            title: AppLocale.department
                                .getString(context)
                                .capitalizeAllWord(),
                          ),
                          const SizedBox(height: 2),
                          RoundedInputField(
                            hintText: AppLocale.egMaths
                                .getString(context)
                                .capitalizeAllWord(),
                            text: model.department,
                            isEmptyValidation: true,
                            textInputAction: TextInputAction.next,
                            onChanged: (input) {
                              model.department = input;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: kBottomPadding * 2),
                      StudentsComponent(
                        model: model.studentsComponentVM,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
