import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/widgets/AdviceContainer.dart';
import 'package:teachy_tec/widgets/AppButtons.dart';

Future<bool> AppPermissionBottomDialogue(
    {required String headerText, required String adviceText}) async {
  bool isAccepted = false;
  await UIRouter.showAppBottomDrawerWithCustomWidget(
      bottomPadding: 0,
      backgroundColor: AppColors.white,
      child: Container(
        color: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: kBottomPadding,
            ),
            Text(
              headerText,
              style: TextStyles.InterGrey900S16W600,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kBottomPadding),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kMainPadding),
              child: AdviceText(
                text: adviceText,
              ),
            ),
            const SizedBox(height: kBottomPadding),
            AppBottomNavCustomWidget(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BottomPageButton(
                    onTap: () async {
                      isAccepted = true;
                      UIRouter.popScreen(rootNavigator: true);
                    },
                    text: AppLocale.next
                          .getString(UIRouter.getCurrentContext())
                          .capitalizeFirstLetter()
                  ),
                ],
              ),
            ),
          ],
        ),
      ));

  return isAccepted;
}
