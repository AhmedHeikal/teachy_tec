// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';

class AdviceText extends StatelessWidget {
  AdviceText({
    super.key,
    required this.text,
    this.additionalWidgetInTheBottomOfAdvice,
    this.verticalBarColor = AppColors.grey900,
    this.backgroundColor = AppColors.grey200,
    this.textStyle = TextStyles.InterGrey900S14W400,
  });

  AdviceText.danger({
    super.key,
    required this.text,
    this.additionalWidgetInTheBottomOfAdvice,
  }) {
    verticalBarColor = AppColors.primary700;
    backgroundColor = AppColors.primary50;
    textStyle = TextStyles.InterYellow700S12W400;
  }

  late Color verticalBarColor;
  late Color backgroundColor;
  late TextStyle textStyle;
  final String text;
  final Widget? additionalWidgetInTheBottomOfAdvice;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kHelpingPadding),
      decoration: BoxDecoration(
          color: backgroundColor,
          border: BorderDirectional(
            start: BorderSide(color: verticalBarColor, width: 3),
          ),
          borderRadius: const BorderRadiusDirectional.only(
            topEnd: Radius.circular(8),
            bottomEnd: Radius.circular(8),
          )),
      width: double.infinity,
      child: Column(
        children: [
          Text(
            text,
            style: textStyle,
          ),
          if (additionalWidgetInTheBottomOfAdvice != null)
            additionalWidgetInTheBottomOfAdvice!,
        ],
      ),
    );
  }
}

class MarketCard extends StatelessWidget {
  MarketCard({
    Key? key,
    required this.text,
    // this.verticalBarColor = AppColors.black,
    this.backgroundColor = AppColors.primary100,
    this.textStyle = TextStyles.InterBlackS16W400,
  }) : super(key: key);

  MarketCard.danger({
    Key? key,
    required this.text,
  }) {
    // this.verticalBarColor = AppColors.black;
    this.backgroundColor = AppColors.primary100;
    this.textStyle = TextStyles.InterBlackS16W400;
  }

  // late Color verticalBarColor;
  late Color backgroundColor;
  late TextStyle textStyle;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kMainPadding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        // border: BorderDirectional(
        //   start: BorderSide(color: verticalBarColor, width: 3),
        // ),
      ),
      width: double.infinity,
      child: Text(
        this.text,
        style: textStyle,
        // textAlign: TextAlign.center,
      ),
    );
  }
}
