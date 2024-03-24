import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Grades/SectionComponentVM.dart';
import 'package:teachy_tec/screens/Grades/SectorForm.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/CustomizedDropdown.dart';
import 'package:teachy_tec/widgets/HorizontalDottedLine.dart';
import 'package:teachy_tec/widgets/InputTitle.dart';
import 'package:teachy_tec/widgets/RoundedTextField.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class SectionComponent extends StatelessWidget {
  const SectionComponent({
    required this.model,
    this.onDelete,
    super.key,
  });

  final VoidCallback? onDelete;
  final SectionComponentVM model;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: Consumer<SectionComponentVM>(
        builder: (context, model, _) => DefaultContainer(
          padding: const EdgeInsets.all(kBottomPadding),
          border: Border.all(
              color: model.isCumulativeMoreThanTotalGrade
                  ? AppColors.red600
                  : AppColors.white),
          child: Form(
            key: model.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputTitle(
                  title: 'Section Name'.capitalizeAllWord(),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: RoundedInputField(
                        hintText: 'ex. Midterm'.capitalizeAllWord(),
                        text: '',
                        isEmptyValidation: true,
                        textInputAction: TextInputAction.next,
                        onChanged: (input) => model.name = input,
                      ),
                    ),
                    if (onDelete != null) ...[
                      const SizedBox(width: kInternalPadding),
                      InkWell(
                        onTap: onDelete,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: kBottomPadding),
                          child: SvgPicture.asset(
                            "assets/svg/bin.svg",
                            color: AppColors.primary700,
                            height: 35,
                            width: 35,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: kBottomPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InputTitle(
                            title: 'Total Grade'.capitalizeAllWord(),
                          ),
                          const SizedBox(height: 2),
                          RoundedInputField(
                            hintText: ''.capitalizeAllWord(),
                            text: model.totalGrade.value != null
                                ? model.totalGrade.value!.toString()
                                : "",
                            validateLargerThan: 0,
                            validateSmallerThan:
                                model.currentRemainingGrade,
                            // errorHintText: 'Please provide total grade',
                            isEmptyValidation: true,
                            textInputAction: TextInputAction.next,
                            inputType: const TextInputType.numberWithOptions(
                                decimal: true),
                            max: 100,
                            min: 0,
                            onChanged: model.updateTotalGrade,
                            // (input) {
                            //   model.totalGrade = double.tryParse(input);
                            // },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: kHelpingPadding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InputTitle(
                            title: 'Color'.capitalizeAllWord(),
                          ),
                          const SizedBox(height: 2),
                          ColorDropdown(
                            chosenItem: model.colorhex,
                            onChange: (selectedColor, index) {
                              model.colorhex = selectedColor;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                model.sectors.isNotEmpty
                    ? (model.totalGrade.value == null ||
                            model.totalGrade.value == 0)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: kMainPadding),
                              Text(
                                AppLocale.totalGradeCantBeZero
                                    .getString(context)
                                    .capitalizeFirstLetter(),
                                style: TextStyles.InterRed700S10W400,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        : (model.totalGrade.value != null &&
                                model.totalGrade.value! > 0)
                            ? Column(
                                children: [
                                  const SizedBox(height: kBottomPadding),
                                  ValueListenableBuilder<num>(
                                    valueListenable:
                                        model.sectorCumulativeGrade,
                                    builder: (context, sectorCumulativeGrade,
                                        child) {
                                      var currentPercentage =
                                          (sectorCumulativeGrade /
                                              (model.totalGrade.value ?? 0));
                                      currentPercentage = currentPercentage > 1
                                          ? 1
                                          : currentPercentage;
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Current Score'
                                                  .capitalizeFirstLetter(),
                                              style: TextStyles
                                                  .InterGrey900S12W400,
                                            ),
                                          ),
                                          Text(
                                            '${(currentPercentage * 100).toStringAsFixed(1)}%'
                                                .capitalizeFirstLetter(),
                                            style:
                                                TextStyles.InterGrey800S16W400,
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 2),
                                  ValueListenableBuilder<num>(
                                    valueListenable:
                                        model.sectorCumulativeGrade,
                                    builder: (context, sectorCumulativeGrade,
                                        child) {
                                      var currentPercentage =
                                          (sectorCumulativeGrade /
                                              (model.totalGrade.value ?? 0));
                                      currentPercentage = currentPercentage > 1
                                          ? 1
                                          : currentPercentage;
                                      return Stack(
                                        children: [
                                          FractionallySizedBox(
                                            alignment: AlignmentDirectional
                                                .bottomStart,
                                            widthFactor: 1,
                                            child: Container(
                                              height: 10,
                                              decoration: BoxDecoration(
                                                color: AppColors.grey200,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                          FractionallySizedBox(
                                            alignment: AlignmentDirectional
                                                .bottomStart,
                                            widthFactor: currentPercentage,
                                            child: Container(
                                              height: 10,
                                              decoration: BoxDecoration(
                                                color: AppColors.primary500,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              )
                            : const SizedBox()
                    : const SizedBox(),
                if (model.isCumulativeMoreThanTotalGrade &&
                    model.totalGrade.value != null &&
                    model.totalGrade.value != 0) ...[
                  const SizedBox(height: kMainPadding),
                  Text(
                    //  "Sector grades exceed section total. Please adjust accordingly."
                    "The total grade of the sectors is higher than the section's total grade, please adjust the sectors grades or the total grade of the section"
                        .capitalizeFirstLetter(),
                    /* AppLocale.totalGradeCantBeZero
                        .getString(context)
                        .capitalizeFirstLetter(), */
                    style: TextStyles.InterRed700S10W400,
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: kHelpingPadding),
                DefaultContainer(
                  margin: EdgeInsets.only(
                      top: model.sectors.isEmpty ? 0 : kBottomPadding),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var item = model.sectors[index];
                      return SectorForm(
                        key: UniqueKey(),
                        model: item,
                        // totalSectionGrade: model.totalGrade.value!,
                        onDelete: () => model.onDeleteSector(index),
                      );
                    },
                    separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.fromLTRB(
                        kBottomPadding,
                        kMainPadding,
                        kBottomPadding,
                        kHelpingPadding,
                      ),
                      child: HorizontalDottedLine(),
                    ),
                    itemCount: model.sectors.length,
                  ),
                ),
                if (!model.isCumulativeMoreThanTotalGrade) ...[
                  const SizedBox(height: kHelpingPadding),
                  InkWell(
                    onTap: model.onAddNewSector,
                    child: DefaultContainer(
                      child: DottedBorder(
                        // radius: Radius.circular(7),
                        color: AppColors.grey300,
                        dashPattern: const [5, 5],
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(8),
                        // radius: Radius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kBottomPadding,
                              vertical: kHelpingPadding
                              // vertical: 0,
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/svg/PlusSVG.svg',
                                color: AppColors.grey400,
                              ),
                              const SizedBox(width: kInternalPadding),
                              Text('Add Sector'.capitalizeFirstLetter(),
                                  style: TextStyles.InterGrey400S16W600),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
