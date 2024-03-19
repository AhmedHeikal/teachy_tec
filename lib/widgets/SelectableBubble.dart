import 'package:flutter/material.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';

enum SelectableBubbleStatus {
  active,
  inActive,
  error,
}

class SelectableBubble extends StatelessWidget {
  const SelectableBubble({
    super.key,
    this.activeBackgroundColor = AppColors.primary500,
    this.activeTextStyle = TextStyles.InterBlackS12W400,
    this.inActiveBackgroundColor = AppColors.grey100,
    this.inActiveTextStyle = TextStyles.InterGrey600S12W600,
    this.errorBackgroundColor = AppColors.red700,
    this.status = SelectableBubbleStatus.active,
    required this.text,
    required this.onTap,
    required this.onDelete,
  });

  final VoidCallback onTap;
  final VoidCallback onDelete;
  final String text;
  final Color activeBackgroundColor;
  final Color inActiveBackgroundColor;
  final Color errorBackgroundColor;
  final TextStyle activeTextStyle;
  final TextStyle inActiveTextStyle;
  final SelectableBubbleStatus status;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: kHelpingPadding, vertical: kInternalPadding),
            decoration: BoxDecoration(
                borderRadius: const BorderRadiusDirectional.only(
                  topStart: Radius.circular(12),
                  bottomStart: Radius.circular(6),
                  bottomEnd: Radius.circular(12),
                  topEnd: Radius.circular(6),
                ),
                color: status == SelectableBubbleStatus.inActive
                    ? inActiveBackgroundColor
                    : status == SelectableBubbleStatus.error
                        ? errorBackgroundColor
                        : activeBackgroundColor),
            child: Text(
              text,
              style: status == SelectableBubbleStatus.inActive
                  ? inActiveTextStyle
                  : activeTextStyle,
            ),
          ),
        ),
        Positioned.directional(
          textDirection: Directionality.of(context),
          top: -8,
          end: -6,
          child: InkWell(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: const BoxDecoration(
                color: AppColors.primary500,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: AppColors.red600,
                size: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
