import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:teachy_tec/styles/AppColors.dart';

class HorizontalDottedLine extends StatelessWidget {
  const HorizontalDottedLine({
    super.key,
    this.color = AppColors.grey300,
  });
  final Color color;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) => DottedBorder(
        customPath: (_) => Path()
          ..moveTo(0, 0)
          ..lineTo(constraint.maxWidth, 0),
        borderType: BorderType.RRect,
        dashPattern: const <double>[5, 4],
        color: color,
        strokeWidth: 1,
        child: Container(
          height: 1,
        ),
      ),
    );
  }
}
