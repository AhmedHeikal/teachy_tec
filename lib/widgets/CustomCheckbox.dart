import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teachy_tec/styles/AppColors.dart';

// ignore: must_be_immutable
class CustomCheckBox extends StatelessWidget {
  bool isChecked;
  bool isHidden;
  final double height;
  final double width;
  CustomCheckBox(
      {super.key,
      this.isChecked = false,
      this.height = 23,
      this.width = 23,
      this.isHidden = false});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      child: isHidden
          ? Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(3)),
            )
          : isChecked
              ? SvgPicture.asset(
                  "assets/svg/CheckedBox.svg",
                  height: height,
                  width: width,
                  fit: BoxFit.contain,
                )
              : Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                      color: AppColors.grey200,
                      borderRadius: BorderRadius.circular(3)),
                ),
    );
  }
}
