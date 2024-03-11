import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/AppUtility.dart';

class AppBottomDrawerHeader extends StatelessWidget {
  const AppBottomDrawerHeader(
      {super.key, required this.title, required this.saveFunction});
  final String title;
  final VoidCallback? saveFunction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 17),
                Center(
                  child: SvgPicture.asset(
                    AppUtility.getArrowAssetLocalized(),
                    // "assets/vectors/ArrowLeft.svg",
                    height: 12,
                    width: 9,
                    color: AppColors.grey400,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocale.back.getString(context).capitalizeFirstLetter(),
                  style: TextStyles.InterGrey400S16W600,
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 5,
          child: Text(
            title,
            style: TextStyles.InterBlackS16W600,
          ),
        ),
        Flexible(
          flex: 2,
          child: saveFunction == null
              ? Container()
              : InkWell(
                  onTap: saveFunction,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Center(
                        child: Text(
                          AppLocale.save
                              .getString(context)
                              .capitalizeFirstLetter(),
                          style: TextStyles.InterYellow700S16W600,
                        ),
                      ),
                      const SizedBox(width: 17),
                    ],
                  )),
        ),
      ],
    );
  }
}

class AppBottomDrawerHeaderWithCustomWidget extends StatelessWidget {
  const AppBottomDrawerHeaderWithCustomWidget(
      {Key? key, required this.title, required this.actionWidget})
      : super(key: key);
  final String title;
  final Widget actionWidget;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 17),
                Center(
                  child: SvgPicture.asset(
                    AppUtility.getArrowAssetLocalized(rightArrowInLTR: false),
                    // "assets/vectors/ArrowLeft.svg",
                    height: 12,
                    width: 9,
                    color: AppColors.grey400,

                    // fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'back'
                      // AppLocalizations.of(context).back
                      .capitalizeFirstLetter(),
                  style: TextStyles.InterGrey400S16W600,
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 5,
          child: Text(
            title,
            style: TextStyles.InterBlackS16W600,
          ),
        ),
        Flexible(
          flex: 2,
          child: actionWidget,
        ),
        // const SizedBox(width: 80)
      ],
    );
  }
}
