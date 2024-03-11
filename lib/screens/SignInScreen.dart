import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/SignInScreenVM.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/AppButtons.dart';
import 'package:teachy_tec/widgets/LanguageDropDown.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({required this.model, super.key});
  final SignInScreenVM model;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Transform.translate(
              offset: const Offset(0, 50),
              child: SvgPicture.asset(
                'assets/svg/homeScreenClip.svg',
                width: size.width,
              ),
            ),
          ),
          Positioned(
            top: size.height / 6,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/svg/logo.svg',
                  height: 120,
                ),
                const SizedBox(height: kBottomPadding),
                Text(
                  AppLocale.teachyTec.getString(context).toUpperCase(),
                  style: TextStyles.MontserratYellow700S32W700,
                ),
                // SizedBox(height: kBottomPadding),
                Text(
                  AppLocale.teachyTecSlogan
                      .getString(context)
                      .capitalizeAllWord(),
                  style: FlutterLocalization
                              .instance.currentLocale?.languageCode
                              .toLowerCase() ==
                          "ar"
                      ? TextStyles.MontserratBlackS18W300
                      : TextStyles.MontserratBlackS14W300,
                ),
                const SizedBox(height: 30),
                Text(
                  AppLocale.loginToTeachyTec
                      .getString(context)
                      .capitalizeFirstLetter(),
                  style: TextStyles.InterBlackS24W700,
                ),
                const SizedBox(height: kBottomPadding),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ExtendingButton(
                    onTap: model.signUpByGmail,
                    text: AppLocale.signupWithGoogle
                        .getString(context)
                        .capitalizeFirstLetter(),
                    icon: SvgPicture.asset(
                      'assets/svg/gmail.svg',
                    ),
                  ),
                ),
                if (Platform.isIOS) ...[
                  const SizedBox(height: kMainPadding),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ExtendingButton(
                      onTap: model.signUpByApple,
                      text: AppLocale.signupWithApple
                          .getString(context)
                          .capitalizeFirstLetter(),
                      icon: SvgPicture.asset(
                        'assets/svg/apple.svg',
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Positioned(
            // textDirection: Directionality.of(context),
            top: 30,
            right: kMainPadding,
            child: LanguageDropdown(),
          ),
        ],
      ),
    );
  }
}
