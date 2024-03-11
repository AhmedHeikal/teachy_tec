import 'dart:io';

import 'package:flutter/material.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';

// ignore: must_be_immutable
class BottomPageButton extends StatelessWidget {
  BottomPageButton({
    required this.onTap,
    this.isActive = true,
    this.icon,
    this.color,
    this.borderColor = Colors.transparent,
    this.inAcvtiveColor,
    this.textStyle = TextStyles.InterYellow700S16W600,
    this.addShadows = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 34, vertical: 15),
    required this.text,
    Key? key,
  }) : super(key: key);
  final Color borderColor;
  final VoidCallback? onTap;
  Color? color;
  Color? inAcvtiveColor;
  final EdgeInsets padding;
  final bool isActive;
  final Widget? icon;
  final String text;
  final bool addShadows;
  final TextStyle textStyle;
  @override
  Widget build(BuildContext context) {
    color = color ?? (isActive ? AppColors.grey900 : AppColors.grey700);

    return Center(
      child: InkWell(
        onTap: onTap != null && isActive
            ? () {
                FocusManager.instance.primaryFocus?.unfocus();
                onTap!();
              }
            : null,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
            boxShadow: addShadows ? kBoxBlurredShadowsArray : null,
            color: isActive ? color : color?.withOpacity(0.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 4),
              ],
              Text(
                text,
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ExtendingButton extends StatelessWidget {
  ExtendingButton({
    required this.onTap,
    this.isActive = true,
    this.icon,
    this.color,
    this.inAcvtiveColor,
    this.textStyle = TextStyles.InterYellow700S18W400,
    this.addShadows = false,
    required this.text,
    Key? key,
  }) : super(key: key);
  final VoidCallback? onTap;
  Color? color;
  Color? inAcvtiveColor;
  final bool isActive;
  final Widget? icon;
  final String text;
  final bool addShadows;
  final TextStyle textStyle;
  @override
  Widget build(BuildContext context) {
    color = color ?? (isActive ? AppColors.black : AppColors.grey900);

    return Center(
      child: InkWell(
        onTap: onTap != null && isActive
            ? () {
                FocusManager.instance.primaryFocus?.unfocus();
                onTap!();
              }
            : null,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            boxShadow: addShadows ? kBoxBlurredShadowsArray : null,
            color: isActive ? color : color?.withOpacity(0.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  text,
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBottomNavCustomWidget extends StatelessWidget {
  const AppBottomNavCustomWidget(
      {required this.child,
      this.color = AppColors.white,
      this.addShadows = true,
      this.height = 88,
      super.key});
  final double height;
  final Widget child;
  final bool addShadows;
  final Color color;
  @override
  Widget build(BuildContext context) {
    bool isIOS = Platform.isIOS;
    return Container(
      padding: EdgeInsets.only(bottom: isIOS ? kMainPadding : 0),
      // constraints: BoxConstraints(minHeight: height),
      height: height,
      decoration: BoxDecoration(
        boxShadow: addShadows ? KboxBlurredShadowsArray : null,
        color: color,
      ),
      child: child,
    );
  }
}
