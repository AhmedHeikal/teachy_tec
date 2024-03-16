import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/Appbar.dart';
import 'package:teachy_tec/widgets/InteractiveText.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          screenName: AppLocale.privacyPolicyTermsOfUse
              .getString(context)
              .capitalizeFirstLetter(),
          // 'Privacy policy & Terms of use',
          // containsBackButton: !model.isNotAgreedToConitions,
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(kMainPadding),
            child: Column(
              children: [
                InteractiveText(
                  showPreview: false,
                  // linkStyle: TextStyles.InterBlue700S14W500,
                  text: AppLocale.privacyPolicyDescription
                      .getString(context)
                      .capitalizeFirstLetter(),
                  style: TextStyles.InterGrey700S16W400,
                ),
                const SizedBox(height: kMainPadding * 2),
              ],
            ),
          ),
        ));
  }
}
