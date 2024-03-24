import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class HomeScreenDetailsButton extends StatelessWidget {
  const HomeScreenDetailsButton({
    Key? key,
    required this.imageVectorString,
    required this.title,
    required this.onTapCallBack,
  }) : super(key: key);

  final String imageVectorString;
  final String title;

  final VoidCallback onTapCallBack;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapCallBack,
      child: DefaultContainer(
        height: 58,
        decoration: BoxDecoration(
          color: AppColors.appBackgroundColor,
          boxShadow: KdefaultShadow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: kBottomPadding),
            SvgPicture.asset(
              'assets/svg/$imageVectorString.svg',
              height: 30,
              color: AppColors.primary700,
            ),
            const SizedBox(width: kInternalPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: TextStyles.InterGrey500S14W500),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
