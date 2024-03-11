import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/models/Student.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class StudentPreview extends StatelessWidget {
  const StudentPreview({required this.model, super.key});
  final Student model;
  @override
  Widget build(BuildContext context) {
    String getAssetValue() {
      if (model.gender == Gender.male) {
        return 'assets/svg/male.svg';
      } else if (model.gender == Gender.female) {
        return 'assets/svg/female.svg';
      }
      return 'assets/svg/male.svg';
    }

    return Container(
      decoration: BoxDecoration(
        boxShadow: kListShadowsArray,
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding:
          const EdgeInsets.symmetric(vertical: 10, horizontal: kBottomPadding),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(kBottomPadding),
            decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primary700,
                ),
                shape: BoxShape.circle),
            child: SvgPicture.asset(getAssetValue()),
          ),
          const SizedBox(width: kInternalPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  style: TextStyles.InterGrey800S12W400,
                ),
                if (model.studentClass != null)
                  DefaultContainer(
                    color: AppColors.primary500,
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: kInternalPadding,
                    ),
                    child: Text(
                      model.studentClass!.name,
                      style: TextStyles.InterBlackS10W700,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: kInternalPadding),
          SvgPicture.asset('assets/svg/grade.svg'),
          const SizedBox(width: kInternalPadding),
          Text(AppLocale.grade.getString(context).capitalizeFirstLetter(),
              style: TextStyles.InterGrey900S14W500)
        ],
      ),
    );
  }
}
