import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
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
    super.key,
  });
  final SectionComponentVM model;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: Column(
        children: [
          RoundedInputField(
            hintText: 'ex. Midterm'.capitalizeAllWord(),
            text: '',
            textInputAction: TextInputAction.next,
            onChanged: (input) {},
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
                      hintText: 'ex. Primary Class'.capitalizeAllWord(),
                      text: '',
                      isEmptyValidation: true,
                      textInputAction: TextInputAction.next,
                      onChanged: (input) {},
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
                      // isEnabled: model.oldModel == null,
                      // emptyChoiceText:
                      //     AppLocale.loading.getString(context).capitalizeFirstLetter(),
                      // emptyChoiceChosenText:
                      //     AppLocale.loading.getString(context).capitalizeFirstLetter(),
                      // chosenItem: model.selectedClass?.name,
                      // items: (model.classes ?? []).map((e) => e.name).toList(),
                      onChange: (selectedColor, index) {
                        // model.onSelectClass(name);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: kHelpingPadding),
          Consumer<SectionComponentVM>(
            builder: (context, model, _) => DefaultContainer(
              margin: EdgeInsets.only(
                top: model.sectors.isEmpty ? 0 : kBottomPadding,
              ),
              // color: AppColors.grey50,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var item = model.sectors[index];
                  return SectorForm(
                    key: UniqueKey(),
                    model: item,
                  );
                },
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.fromLTRB(
                    kBottomPadding,
                    kBottomPadding,
                    kBottomPadding,
                    kHelpingPadding,
                  ),
                  child: HorizontalDottedLine(),
                ),
                itemCount: model.sectors.length,
              ),
            ),
          ),
          const SizedBox(height: kHelpingPadding),
          InkWell(
            onTap: model.onAddNewSector,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kBottomPadding,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Add Sector'.capitalizeFirstLetter(),
                      style: TextStyles.InterYellow700S16W600),
                  const SizedBox(width: kInternalPadding),
                  SvgPicture.asset(
                    'assets/svg/PlusSVG.svg',
                    color: AppColors.primary700,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
