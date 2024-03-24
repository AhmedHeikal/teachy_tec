import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/utils/AppConstants.dart';

// ignore: must_be_immutable
class DefaultContainer extends StatelessWidget {
  DefaultContainer(
      {required this.child,
      this.borderRadiusValue = 8,
      this.height,
      this.width,
      this.color = AppColors.white,
      this.padding,
      this.margin,
      this.addDefaultBoxShadow = false,
      this.boxShadow,
      this.decoration,
      this.constraints,
      this.borderRadius,
      this.border,
      this.addBorder = false,
      Key? key})
      : super(key: key);

  double borderRadiusValue;
  BorderRadiusGeometry? borderRadius;
  // double borderWidth;
  List<BoxShadow>? boxShadow;
  bool addDefaultBoxShadow;
  bool addBorder;
  Border? border;
  Color color;
  double? height;
  double? width;
  EdgeInsetsGeometry? padding;
  EdgeInsetsGeometry? margin;
  BoxConstraints? constraints;
  Widget child;
  BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return addBorder
        ? DottedBorder(
            dashPattern: const [10, 10],
            borderType: BorderType.RRect,
            strokeWidth: 2,
            color: AppColors.grey300,
            radius: const Radius.circular(12),
            child: Container(
              height: height,
              width: width,
              margin: margin ?? EdgeInsets.zero,
              padding: padding ?? EdgeInsets.zero,
              constraints: constraints,
              decoration: decoration ??
                  BoxDecoration(
                    color: color,
                    borderRadius: borderRadius ??
                        BorderRadius.circular(borderRadiusValue),
                    boxShadow:
                        addDefaultBoxShadow ? KdefaultShadow : boxShadow ?? [],
                    border: border != null ? border : null,
                  ),
              child: child,
            ),
          )
        : Container(
            height: height,
            width: width,
            margin: margin ?? EdgeInsets.zero,
            padding: padding ?? EdgeInsets.zero,
            constraints: constraints,
            decoration: decoration ??
                BoxDecoration(
                  color: color,
                  borderRadius:
                      borderRadius ?? BorderRadius.circular(borderRadiusValue),
                  boxShadow: boxShadow,
                  border: border ??
                      Border.all(
                        color:
                            addBorder ? AppColors.grey200 : Colors.transparent,
                      ),
                ),
            child: child,
          );
  }
}
