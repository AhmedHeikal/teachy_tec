import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';

class CheckpointWidget extends StatelessWidget {
  const CheckpointWidget({
    this.isQuestion = false,
    this.index,
    super.key,
  });
  final bool isQuestion;
  final int? index;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: kInternalPadding,
      ),
      decoration: BoxDecoration(
          color: AppColors.primary50, borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/svg/flag.svg',
            // matchTextDirection: true,
            color: AppColors.primary700,
          ),
          const SizedBox(width: 2),
          Text(
            "${AppLocale.question.getString(context).capitalizeFirstLetter()} ${index != null ? (index! + 1).toString() : ""}"
                .trim(),
            style: TextStyles.InterYellow700S14W500,
          ),
        ],
      ),
    );
  }
}
