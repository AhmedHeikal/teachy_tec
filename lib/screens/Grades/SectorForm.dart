import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/screens/Grades/SectorFormVM.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/InputTitle.dart';
import 'package:teachy_tec/widgets/RoundedTextField.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class SectorForm extends StatefulWidget {
  const SectorForm({
    required this.model,
    this.onDelete,
    super.key,
  });

  final VoidCallback? onDelete;
  final SectorFormVM model;

  @override
  State<SectorForm> createState() => _SectorFormState();
}

class _SectorFormState extends State<SectorForm> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.model,
      child: Consumer<SectorFormVM>(
        builder: (context, model, _) => Form(
          key: model.formKey,
          child: DefaultContainer(
            padding: const EdgeInsets.all(kMainPadding),
            border: Border.all(
              color: AppColors.grey200,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: RoundedInputField(
                        isReadOnly: model.isDisabled,
                        hintText: 'ex. Midterm'.capitalizeAllWord(),
                        text: '',
                        isEmptyValidation: true,
                        textInputAction: TextInputAction.next,
                        onChanged: (input) => model.name = input,
                      ),
                    ),
                    if (widget.onDelete != null) ...[
                      const SizedBox(width: kInternalPadding),
                      InkWell(
                        onTap: widget.onDelete,
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
                            title: 'Real Weight'.capitalizeAllWord(),
                            style: TextStyles.InterGrey600S10W600,
                          ),
                          const SizedBox(height: 2),
                          RoundedInputField(
                            isReadOnly: model.isDisabled,
                            hintText: ''.capitalizeAllWord(),
                            text: model.realWeight != null
                                ? model.realWeight!.toString()
                                : "",
                            // errorHintText:
                            //     'Please provide real weight of grade',
                            isEmptyValidation: true,
                            textInputAction: TextInputAction.next,
                            validateLargerThan: 0,
                            validateSmallerThan: model.currentRemainingGrade,
                            max: 100,
                            min: 0,
                            inputType: const TextInputType.numberWithOptions(
                                decimal: true),
                            onChanged: (input) => model.onRealWeightUpdate(
                              input,
                              // widget.totalSectionGrade,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: kHelpingPadding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InputTitle(
                            title: 'Percentage Weight'.capitalizeAllWord(),
                            style: TextStyles.InterGrey600S10W600,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: RoundedInputField(
                                  isReadOnly: model.isDisabled,
                                  hintText: ''.capitalizeAllWord(),
                                  text: model.percentageWeight != null
                                      ? model.percentageWeight!.toString()
                                      : "",
                                  // errorHintText:
                                  //     'Please provide percentage wight',
                                  isEmptyValidation: true,
                                  textInputAction: TextInputAction.next,
                                  inputType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  max: 100,
                                  min: 1,
                                  onChanged: (input) =>
                                      model.onPercentageWeight(
                                    input,
                                    // widget.totalSectionGrade,
                                  ),
                                  // onChanged: (input) {
                                  //   model.percentageWeight =
                                  //       double.tryParse(input);
                                  // },
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text(
                                  '%',
                                  style: TextStyles.InterGrey400S16W600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // if (model.realWeight != null &&
                //     (model.realWeight ?? 0) == 0) ...[
                //   const SizedBox(height: kMainPadding),
                //   Text(
                //     //  "Sector grades exceed section total. Please adjust accordingly."
                //     "The Sector Grade must be more than zero"
                //         .capitalizeFirstLetter(),
                //     /* AppLocale.totalGradeCantBeZero
                //         .getString(context)
                //         .capitalizeFirstLetter(), */
                //     style: TextStyles.InterRed700S10W400,
                //     textAlign: TextAlign.start,
                //   ),
                // ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}