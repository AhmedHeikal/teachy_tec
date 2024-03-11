import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';

class CalendarNumber extends StatelessWidget {
  const CalendarNumber({
    super.key,
    required this.currentDay,
  });
  final int currentDay;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset('assets/svg/calendarCap.svg'),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(2),
              bottomRight: Radius.circular(2),
            ),
            color: AppColors.grey900,
          ),
          child: Text(
            currentDay.toString(),
            style: TextStyles.InterYellow700S12W500,
          ),
        )
      ],
    );
  }
}
