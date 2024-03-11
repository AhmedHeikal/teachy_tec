import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Activity/NoteFormForCellInDayTableVM.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/widgets/AppButtons.dart';
import 'package:teachy_tec/widgets/RoundedTextField.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class NoteFormForCellInDayTable extends StatelessWidget {
  const NoteFormForCellInDayTable(
      {required this.model, required this.onDeleteTapped, super.key});
  final NoteFormForCellInDayTableVM model;
  final VoidCallback onDeleteTapped;

  @override
  Widget build(BuildContext context) {
    var keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;

    return ChangeNotifierProvider.value(
      value: model,
      child: Consumer<NoteFormForCellInDayTableVM>(
        builder: (context, model, _) => GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              kMainPadding,
              kMainPadding,
              kMainPadding,
              0,
            ),
            child: Form(
              key: model.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppLocale.note
                              .getString(context)
                              .capitalizeFirstLetter(),
                          style: TextStyles.InterGrey600S12W600,
                        ),
                      ),
                      if (model.isEditting == false && model.oldModel != null)
                        InkWell(
                          onTap: model.editNote,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.all(
                                kHelpingPadding),
                            child: SvgPicture.asset('assets/svg/pen.svg',
                                height: 24),
                          ),
                        ),
                      InkWell(
                        onTap: onDeleteTapped,
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.all(kHelpingPadding),
                          child: SvgPicture.asset('assets/svg/bin.svg',
                              color: AppColors.primary700, height: 24),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  model.isEditting == false
                      ? DefaultContainer(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.grey200),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            model.note ?? '',
                            style: TextStyles.InterGrey500S14W400,
                          ))
                      : RoundedMultilineInputField(
                          hintText: AppLocale
                              .intelligentBoyWithCoolSenseOfHumour
                              .getString(context)
                              .capitalizeFirstLetter(),
                          text: model.note,
                          isEmptyValidation: true,
                          textInputAction: TextInputAction.next,
                          onChanged: (input) {
                            model.note = input;
                          },
                        ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (model.isEditting == true) ...[
                        BottomPageButton(onTap: model.addNote, text: 'Save'),
                        const SizedBox(width: kHelpingPadding),
                      ],
                      BottomPageButton(
                        onTap: () => UIRouter.popScreen(),
                        text: 'Cancel',
                        color: AppColors.white,
                        borderColor: AppColors.grey900,
                        textStyle: TextStyles.InterGrey900S14W500,
                      ),
                    ],
                  ),
                  if (keyboardHeight > 0) SizedBox(height: keyboardHeight),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
