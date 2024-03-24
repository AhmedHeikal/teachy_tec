import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/models/AutoCompleteViewModel.dart';
import 'package:teachy_tec/screens/Grades/GradesFormVM.dart';
import 'package:teachy_tec/screens/Grades/SectionComponent.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/AppButtons.dart';
import 'package:teachy_tec/widgets/Appbar.dart';
import 'package:teachy_tec/widgets/AutocompleteTextFieldComponent.dart';
import 'package:teachy_tec/widgets/InputTitle.dart';
import 'package:teachy_tec/widgets/RoundedTextField.dart';
import 'package:teachy_tec/widgets/SelectableBubble.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class GradesForm extends StatelessWidget {
  const GradesForm({required this.model, super.key});
  final GradesFormVM model;

  @override
  Widget build(BuildContext context) {
    // var keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    // bool is24HoursFormat = MediaQuery.alwaysUse24HourFormatOf(context);

    return ChangeNotifierProvider.value(
      value: model,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.grey50,
          appBar: CustomAppBar(
            screenName: 'New Grades Schema',
          ),
          bottomNavigationBar: AppBottomNavCustomWidget(
            child: BottomPageButton(
              onTap: model.onSubmittingFirstPage,
              //  () => UIRouter.pushScreen(
              //     GradesFormSecondPage(model: model),
              //     pageName: AppAnalyticsConstants.GradesFormSecondScreen),
              text: AppLocale.next.getString(context).capitalizeFirstLetter(),
            ),
          ),
          body: SafeArea(
            child: Form(
              key: model.formKey,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: kMainPadding),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: kMainPadding),
                      DefaultContainer(
                        padding: const EdgeInsets.all(kInternalPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputTitle(
                              title: 'Schema Name'.capitalizeAllWord(),
                            ),
                            const SizedBox(height: 2),
                            RoundedInputField(
                              hintText: 'ex. Primary Class'.capitalizeAllWord(),
                              text: '',
                              isEmptyValidation: true,
                              textInputAction: TextInputAction.next,
                              onChanged: (input) => model.name = input,
                            ),
                            const SizedBox(height: kMainPadding),
                            InputTitle(
                              title: AppLocale.className
                                  .getString(context)
                                  .capitalizeFirstLetter(),
                            ),
                            const SizedBox(height: 2),
                            Consumer<GradesFormVM>(
                              builder: (context, model, _) {
                                return ValueListenableBuilder<bool>(
                                  valueListenable: model.isClassesLoading,
                                  builder: (context, isLoading, child) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AutocompleteTextFieldComponent(
                                          key: model.classesGlobalKey,
                                          isEmptyValidation: true,
                                          onSelectItem:
                                              (AutoCompleteViewModel name) {
                                            model.onSelectClass(name.name);
                                          },
                                          isMultiSelectionSupported: true,
                                          selectedItemsList: model
                                              .selectedClasses
                                              .mapWithIndex(
                                            (e, index) => AutoCompleteViewModel(
                                              name: e.name,
                                              id: e.id,
                                            ),
                                          ),
                                          textFieldLabel: 'Current Classes',
                                          list: model.classes?.mapWithIndex(
                                              (e, index) =>
                                                  AutoCompleteViewModel(
                                                      name: e.name, id: e.id)),
                                        ),
                                        if (model
                                            .selectedClasses.isNotEmpty) ...[
                                          const SizedBox(height: kMainPadding),
                                          SizedBox(
                                            height: 34,
                                            child: ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                var currentItem = model
                                                    .selectedClasses[index];
                                                return SelectableBubble(
                                                  text: currentItem.name,
                                                  onTap: () => model
                                                      .addToOrRemoveFromSelectedClasses(
                                                          currentItem),
                                                  onDelete: () => model
                                                      .addToOrRemoveFromSelectedClasses(
                                                          currentItem),
                                                );
                                              },
                                              itemCount:
                                                  model.selectedClasses.length,
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const SizedBox(
                                                width: kInternalPadding,
                                              ),
                                            ),
                                          )
                                        ],
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: kBottomPadding),
                      const Text('Sections',
                          style: TextStyles.InterBlackS16W600),
                      const SizedBox(height: kBottomPadding),
                      Consumer<GradesFormVM>(
                        builder: (context, model, _) => ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var currentItem = model.sections[index];
                              return SectionComponent(
                                key: UniqueKey(),
                                model: currentItem,
                                onDelete: index == 0
                                    ? null
                                    : () => model.onDeleteSection(index),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: kMainPadding);
                            },
                            itemCount: model.sections.length),
                      ),
                      InkWell(
                        onTap: model.onAddSection,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kBottomPadding,
                            vertical: kMainPadding,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SvgPicture.asset(
                                'assets/svg/PlusSVG.svg',
                                color: AppColors.primary700,
                              ),
                              const SizedBox(width: kInternalPadding),
                              Text('Add Section'.capitalizeFirstLetter(),
                                  style: TextStyles.InterYellow700S16W600),
                            ],
                          ),
                        ),
                      ),
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
