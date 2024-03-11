import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/Appbar.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    super.initState();
    getInfo();
    // TODO: implement initState
  }

  String buildNumber = '';
  Future getInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      buildNumber = 'v${packageInfo.version}(${packageInfo.buildNumber})';
    });
  }

  @override
  Widget build(BuildContext context) {
    // buildNumber = '3.2.${packageInfo.version}, ${packageInfo.buildNumber}';

    return Scaffold(
        appBar: CustomAppBar(
            screenName: AppLocale.aboutTeachyTec
                .getString(context)
                .capitalizeFirstLetter()

            // 'About GenieFX',
            ),
        body: Container(
          // decoration: BoxDecoration(
          //   boxShadow: [
          //     BoxShadow(
          //       color: AppColors.grey400.withOpacity(0.15),
          //       spreadRadius: 1,
          //       blurRadius: 20,
          //       offset: Offset(0, 20), // changes position of shadow
          //     ),
          //   ],
          // ),
          width: double.infinity,
          margin: const EdgeInsets.symmetric(
              horizontal: kMainPadding, vertical: 30),
          padding: const EdgeInsets.all(kMainPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 12),
              SvgPicture.asset(
                'assets/svg/logo.svg',
                height: 100,
              ),
              SizedBox(height: 30),

              Text(
                AppLocale.teachyTecAbout
                    .getString(context)
                    .capitalizeFirstLetter(),
                style: TextStyles.InterBlackS18W700,
                textAlign: TextAlign.center,
              ),
              // Text.rich(
              //   TextSpan(
              //     text:
              //     AppLocale.about.getString(context).capitalizeFirstLetter()
              //         // AppLocalizations.of(context).aboutMrTomato.capitalizeAllWord(),
              //         AppLocalizations.of(context)
              //             .allToolsYouNeedToRunBetterRestaurant
              //             .capitalizeFirstLetter(),
              //     // 'All the tools you need to run a better restaurant — ',
              //     style: TextStyles.InterBlackS18W700,
              //     children: [
              //       TextSpan(
              //         text:
              //             AppLocalizations.of(context).inOneApp.toLowerCase(),
              //         //  'in one app',
              //         style: TomatoTextStyles.InterBlue700S18W700H24,
              //       ),
              //     ],
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              // Expanded(
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Text(
              //           'All the tools you need to run a better restaurant — ',
              //           style: TomatoTextStyles.InterBlackS18W700H24,
              //           textAlign: TextAlign.center,
              //         ),
              //       ),
              //       Expanded(
              //         child: Text(
              //           'in one app',
              //           style: TomatoTextStyles.InterBlue700S18W700H24,
              //           textAlign: TextAlign.center,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(height: kBottomPadding),
              //                 Text(
              //                   AppLocalizations.of(context)
              //                           .AboutTomatoPart1
              //                           .capitalizeFirstLetter() +
              //                       "\n\n" +
              //                       AppLocalizations.of(context)
              //                           .AboutTomatoPart2
              //                           .capitalizeFirstLetter(),
              //                   // '''GenieFX - the application that helps business owners and managers to optimize the staff learning process and to guarantee the perfect quality.

              // // Technology pushes today’s world forward and it’s time for the restaurant industry to take advantage of the latest AI and machine learning solutions that will help them to focus on growth rather than daily routine. Our difference is we want to turn the experience of learning into fun.''',
              //                   style: TomatoTextStyles.InterGrey600S14W400H18,
              //                   textAlign: TextAlign.center,
              //                 ),
              const SizedBox(height: 30),
              // Text(
              //   AppLocalizations.of(context).version3.capitalizeFirstLetter(),

              //   // 'Version 3.0',
              //   style: TomatoTextStyles.InterGrey400S12W600H16,
              // ),
              // SizedBox(
              //   height: kMainPadding,
              // ),
              Text(
                buildNumber,
                style: TextStyles.InterGrey400S12W600,
              )
            ],
          ),
        ));
  }
}
