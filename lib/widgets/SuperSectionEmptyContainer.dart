import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/AdviceContainer.dart';

class SuperSectionEmptyContainer extends StatelessWidget {
  const SuperSectionEmptyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return AdviceText(
      text: AppLocale.superSectionIsLikeBigUmbrella
          .getString(context)
          .capitalizeFirstLetter(),

      // "A 'Super Section' is like a big umbrella that brings together smaller sections. Let's say your school grades are based on different types of work like quizzes, midterms, and other activities. Instead of seeing them separately, you can group them under one big category, like 'Coursework.' This way, the total grade for 'Coursework' is automatically calculated based on all the smaller sections it includes.",
      textStyle: TextStyles.InterGrey600S10W400,
    );
    // padding: const EdgeInsets.all(kBottomPadding),
    // child: Column(
    //   children: [
    //     Text(

    //       style: TextStyles.InterGrey600S10W400,
    //     ),
    //     // SizedBox(
    //     //   height: kMainPadding,
    //     // ),
    //     // Align(
    //     //   alignment: AlignmentDirectional.centerEnd,
    //     //   child: Text(
    //     //     "Try it out now?",
    //     //     style: TextStyles.InterGrey700S12W400,
    //     //   ),
    //     // ),
    //   ],
    // ));
  }
}
