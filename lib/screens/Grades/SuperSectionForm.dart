import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/models/AutoCompleteViewModel.dart';
import 'package:teachy_tec/screens/Grades/SuperSectionFormVM.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/AutocompleteTextFieldComponent.dart';
import 'package:teachy_tec/widgets/CustomizedDropdown.dart';
import 'package:teachy_tec/widgets/InputTitle.dart';
import 'package:teachy_tec/widgets/RoundedTextField.dart';
import 'package:teachy_tec/widgets/SelectableBubble.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class SuperSectionForm extends StatelessWidget {
  const SuperSectionForm({
    required this.model,
    this.onDelete,
    super.key,
  });
  final SuperSectionFormVM model;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: Consumer<SuperSectionFormVM>(
        builder: (context, model, _) {
          var currentSections = model.getAllSections();
          return Form(
            key: model.formKey,
            child: DefaultContainer(
              padding: const EdgeInsets.all(kMainPadding),
              border: Border.all(
                color: currentSections.isEmpty
                    ? AppColors.red600
                    : AppColors.grey200,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputTitle(
                              title: 'Name'.capitalizeAllWord(),
                            ),
                            const SizedBox(height: 2),
                            RoundedInputField(
                              isReadOnly: currentSections.isEmpty,
                              hintText: 'ex. Course Work'.capitalizeAllWord(),
                              text: model.name,
                              isEmptyValidation: true,
                              textInputAction: TextInputAction.next,
                              onChanged: model.onUpdateName,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: kInternalPadding),
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InputTitle(
                                    title: 'Color'.capitalizeAllWord(),
                                  ),
                                  const SizedBox(height: 2),
                                  ColorDropdown(
                                    isEnabled: currentSections.isNotEmpty,
                                    chosenItem: model.colorhex,
                                    items: AppColors.superSectionColors,
                                    onChange: (selectedColor, index) {
                                      model.onUpdateColor(selectedColor);
                                      // model.colorhex = selectedColor;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (currentSections.isEmpty) ...[
                    const SizedBox(height: kBottomPadding),
                    Text(
                      AppLocale.allSectionsHaveBeenChosenDeleteThisSupersection
                          .getString(context)
                          .capitalizeFirstLetter(),
                      style: TextStyles.InterRed700S10W400,
                    ),
                  ],
                  const SizedBox(height: kBottomPadding),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputTitle(
                              title: 'Selected Sections',
                            ),
                            const SizedBox(height: 2),
                            Consumer<SuperSectionFormVM>(
                              builder: (context, model, _) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutocompleteTextFieldComponent(
                                      key: model.sectionGlobalKey,
                                      isEmptyValidation: true,
                                      onSelectItem:
                                          (AutoCompleteViewModel name) {
                                        model.onSelectSection(name.name);
                                      },
                                      isMultiSelectionSupported: true,
                                      selectedItemsList:
                                          model.selectedSections.mapWithIndex(
                                        (e, index) => AutoCompleteViewModel(
                                          name: e.name ?? "",
                                          id: e.id,
                                        ),
                                      ),
                                      textFieldLabel: 'Section Name',
                                      list: currentSections.mapWithIndex(
                                          (e, index) => AutoCompleteViewModel(
                                              name: e.name ?? "", id: e.id)),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      if (model.selectedSections.isNotEmpty) ...[
                        const SizedBox(width: kHelpingPadding),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InputTitle(
                                title: 'Grade'.capitalizeAllWord(),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                  "${model.selectedSections.map((e) => e.totalGrade.value ?? 0).toList().fold(0.0, (previousValue, element) => previousValue + element)}%"),
                              const SizedBox(height: 4),
                              const Text(
                                'Percentage grade',
                                style: TextStyles.InterGrey400S8W400,
                              )
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (model.selectedSections.isNotEmpty) ...[
                    const SizedBox(height: kMainPadding),
                    SizedBox(
                      height: 34,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var currentItem = model.selectedSections[index];
                          return SelectableBubble(
                            text: currentItem.name ?? "",
                            onTap: () => model
                                .addToOrRemoveFromSelectedSection(currentItem),
                            onDelete: () => model
                                .addToOrRemoveFromSelectedSection(currentItem),
                          );
                        },
                        itemCount: model.selectedSections.length,
                        separatorBuilder: (context, index) => const SizedBox(
                          width: kInternalPadding,
                        ),
                      ),
                    )
                  ],
                  if (onDelete != null) ...[
                    const SizedBox(height: kInternalPadding),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: InkWell(
                        onTap: onDelete,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: kInternalPadding, top: 26),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                "assets/svg/bin.svg",
                                color: AppColors.primary700,
                                height: 30,
                                width: 30,
                              ),
                              Text(
                                AppLocale.delete
                                    .toString()
                                    .capitalizeFirstLetter(),
                                style: TextStyles.InterYellow700S16W600,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
