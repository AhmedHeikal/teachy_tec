import 'package:flutter/cupertino.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/widgets/AdviceContainer.dart';
import 'package:teachy_tec/widgets/AppButtons.dart';

class RestartShuffledStudentsPopup extends StatelessWidget {
  const RestartShuffledStudentsPopup(
      {required this.onConfirmTapped, super.key});
  final VoidCallback onConfirmTapped;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: kMainPadding, horizontal: kMainPadding),
            child: Column(
              children: [
                Text(
                  AppLocale.allStudentsHaveBeenSelectedDoYouWantToRestart
                      .getString(context)
                      .capitalizeFirstLetter(),
                  style: TextStyles.InterGrey700S16W600,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: kMainPadding),
                AdviceText.danger(
                  text: AppLocale.alreadySelectedStudentsWillBeRemovedWhichMeans
                      .getString(context)
                      .capitalizeFirstLetter(),
                ),
              ],
            ),
          ),
          AppBottomNavCustomWidget(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BottomPageButton(
                  onTap: () => UIRouter.popScreen(rootNavigator: true),
                  text: AppLocale.cancel
                      .getString(UIRouter.getCurrentContext())
                      .capitalizeFirstLetter(),
                  color: AppColors.grey100,
                  textStyle: TextStyles.InterGrey600S16W600,
                ),
                const SizedBox(width: kBottomPadding),
                BottomPageButton(
                  onTap: onConfirmTapped,
                  text: AppLocale.confirm
                      .getString(UIRouter.getCurrentContext())
                      .capitalizeFirstLetter(),
                  textStyle: TextStyles.InterWhiteS16W600,
                  color: AppColors.grey900,
                ),
                const SizedBox(width: kMainPadding),
              ],
            ),
          )
        ],
      ),
    );
  }
}
