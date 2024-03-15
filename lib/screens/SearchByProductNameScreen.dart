import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/styles/AppTextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/AppButtons.dart';
import 'package:teachy_tec/widgets/AutocompleteTextFieldComponent.dart';
import 'package:teachy_tec/widgets/LanguageDropDown.dart';
import 'package:teachy_tec/widgets/PopScreenBackArrow.dart';

class SearchByProductNameScreen extends StatelessWidget {
  const SearchByProductNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  alignment: AlignmentDirectional.topCenter,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Positioned.directional(
                      textDirection: Directionality.of(context),
                      start: kMainPadding,
                      child: const PopScreenBackArrow(),
                    ),
                    Align(
                      child: Image.asset(
                        'assets/png/mainLogo.png',
                        height: 50,
                      ),
                    ),
                    Positioned.directional(
                        textDirection: Directionality.of(context),
                        end: kMainPadding,
                        child: const LanguageDropdown()),
                  ],
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: kMainPadding),
                      Text(
                        AppLocale.guidlinesForSearchingByProductName
                            .getString(context)
                            .capitalizeFirstLetter(),
                        style: AppTextStyles.blackS18W300,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: kMainPadding),
                      AutocompleteTextFieldComponent(
                        onSelectItem: (AutoCompleteViewModel) {},
                        textFieldLabel: AppLocale.productName
                            .getString(context)
                            .capitalizeAllWord(),
                      ),
                      const SizedBox(height: kMainPadding),
                      BottomPageButton(
                        onTap: () {},
                        text: AppLocale.discoverNow
                            .getString(context)
                            .capitalizeAllWord(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
