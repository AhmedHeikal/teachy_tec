import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/widgets/AdviceContainer.dart';
import 'package:teachy_tec/widgets/AppButtons.dart';

class ClearStudentGradesRequest extends StatelessWidget {
  const ClearStudentGradesRequest({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(kMainPadding),
          child: AdviceText(
            text: AppLocale.allStudentGradesForThisActivityWilBeDeleted
                .getString(context)
                .capitalizeFirstLetter(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BottomPageButton(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              onTap: () {
                UIRouter.popScreen(rootNavigator: true, argumentReturned: true);
              },
              text: AppLocale.deleteStudentGrades
                  .getString(context)
                  .capitalizeFirstLetter(),
            ),
            const SizedBox(width: kMainPadding)
          ],
        ),
      ],
    );
  }
}
