import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/widgets/AdviceContainer.dart';
import 'package:teachy_tec/widgets/AppButtons.dart';

class CreateClassForDashboardRequest extends StatelessWidget {
  const CreateClassForDashboardRequest({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(kMainPadding),
          child: AdviceText(
            text: AppLocale
                .toCreateBoardYouNeedToHaveAtleastOneClassSoByAccepting
                .getString(context)
                .capitalizeFirstLetter(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BottomPageButton(
              onTap: () {
                UIRouter.popScreen(rootNavigator: true, argumentReturned: true);
              },
              text: AppLocale.create.getString(context).capitalizeFirstLetter(),
            ),
            const SizedBox(width: kMainPadding)
          ],
        ),
      ],
    );
  }
}
