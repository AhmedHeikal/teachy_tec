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

class PublishItemsPopup extends StatelessWidget {
  const PublishItemsPopup(
      {required this.publishPressed,
      this.publishedText,
      this.publishButtonText,
      this.publishedDecritpionText,
      Key? key})
      : super(key: key);
  final VoidCallback publishPressed;
  final String? publishButtonText;
  final String? publishedText;
  final String? publishedDecritpionText;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          SizedBox(height: kBottomPadding),
          Text(
            publishedText ??
                AppLocale.publishingCahnges
                    .getString(context)
                    .capitalizeAllWord(),

            // 'Publishing Changes',
            style: TextStyles.InterGrey800S16W600,
          ),
          SizedBox(height: kBottomPadding),
          Container(
            margin: const EdgeInsets.symmetric(
                horizontal: kMainPadding, vertical: kBottomPadding),
            child: AdviceText(
              text: publishedDecritpionText ??
                  AppLocale.publishChangesMessage
                      .getString(context)
                      .capitalizeFirstLetter(),
            ),
            // 'If you press “Publish” all changes will reflect for all locations and users who have access to this item.'),
          ),
          AppBottomNavCustomWidget(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BottomPageButton(
                  onTap: () {
                    UIRouter.popScreen(rootNavigator: true);
                  },
                  text: AppLocale.cancel
                      .getString(context)
                      .capitalizeFirstLetter(),

                  // 'Cancel',
                  color: AppColors.grey100,
                  textStyle: TextStyles.InterGrey600S16W600,
                ),
                const SizedBox(
                  width: kBottomPadding,
                ),
                BottomPageButton(
                  onTap: publishPressed,
                  text: publishButtonText ??
                      AppLocale.publish
                          .getString(context)
                          .capitalizeFirstLetter(),

                  // 'Publish',
                ),
                const SizedBox(
                  width: kMainPadding,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
