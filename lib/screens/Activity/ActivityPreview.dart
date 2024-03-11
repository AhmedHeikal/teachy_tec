import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/models/Activity.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class ActivityPreview extends StatelessWidget {
  const ActivityPreview(
      {required this.model,
      required this.onDeleteItemCallback,
      required this.onDuplicateCallback,
      super.key});
  final Activity model;
  final VoidCallback onDeleteItemCallback;
  final VoidCallback onDuplicateCallback;
  @override
  Widget build(BuildContext context) {
    bool is24HoursFormat = MediaQuery.alwaysUse24HourFormatOf(context);
    return DefaultContainer(
        padding: const EdgeInsets.all(kMainPadding),
        decoration: BoxDecoration(
          color: AppColors.primary50,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.25),
              spreadRadius: 0,
              blurRadius: 9,
              offset: const Offset(0, 3.6), // changes position of shadow
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocale.classVar
                            .getString(context)
                            .capitalizeAllWord(),
                        style: TextStyles.InterGrey500S14W700,
                      ),
                      const Text(
                        ": ",
                        style: TextStyles.InterGrey500S14W700,
                      ),
                      Text(
                        model.currentClass?.name ?? "",
                        style: TextStyles.InterGrey700S14W400.copyWith(
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "${AppUtility.appTimeFormat(DateTime.fromMillisecondsSinceEpoch((model.timestamp)))}  -  ",
                        style: TextStyles.InterGrey500S14W400,
                      ),
                      Text(
                        is24HoursFormat
                            ? AppUtility.getTwentyFourTimeFromSeconds(
                                model.time,
                                inUtc: true,
                              )
                            : AppUtility.getAMPMTimeFromSeconds(
                                model.time,
                                inUtc: true,
                              ),
                        style: TextStyles.InterGrey500S14W400,
                      ),
                    ],
                  )
                ],
              ),
            ),
            InkWell(
              onTap: onDuplicateCallback,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kInternalPadding),
                child: SvgPicture.asset(
                  'assets/svg/copy.svg',
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary700,
                    BlendMode.srcIn,
                  ),
                  height: 32,
                ),
              ),
            ),
            InkWell(
              onTap: onDeleteItemCallback,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kInternalPadding),
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
        ));
  }
}
