import 'package:flutter/foundation.dart';
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

class DeleteItemPopup extends StatelessWidget {
  const DeleteItemPopup(
      {required this.onDeleteCallback,
      required this.deleteMessage,
      this.dangerAdviceText,
      this.customWidget,
      super.key});
  final VoidCallback onDeleteCallback;
  final Widget? customWidget;
  final String deleteMessage;
  final String? dangerAdviceText;
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
                  deleteMessage,
                  style: TextStyles.InterGrey700S16W600,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: kMainPadding),
                if (customWidget != null) customWidget!,
                if (dangerAdviceText != null)
                  AdviceText.danger(text: dangerAdviceText!),
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
                  onTap: onDeleteCallback,
                  text: AppLocale.delete
                      .getString(UIRouter.getCurrentContext())
                      .capitalizeFirstLetter(),
                  // 'Delete',
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
