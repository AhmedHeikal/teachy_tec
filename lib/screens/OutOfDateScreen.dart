import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/AppButtons.dart';

class OutOfDateScreen extends StatelessWidget {
  const OutOfDateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, BoxConstraints constraints) => Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/images/newVersion.png",
                  fit: BoxFit.cover,
                  // height: 1000,
                ),
              ),
              Positioned(
                bottom: (constraints.maxHeight / 4.5),
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text.rich(
                      TextSpan(
                        text: AppLocale.teachyTec
                            .getString(context)
                            .capitalizeFirstLetter(),
                        style: TextStyles.InterYellow700S20W600,
                        children: [
                          TextSpan(
                            text: AppLocale.isHere
                                .getString(context)
                                .capitalizeFirstLetter(),
                            style: TextStyles.InterYellow700S20W600.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: kMainPadding),
                    Text(
                      AppLocale.youCurrentlyHaveOlderVersion
                          .getString(context)
                          .capitalizeFirstLetter(),

                      // 'You currently have an older version of Mr. Tomato.Update to Mr. Tomato 2.0 now!',
                      textAlign: TextAlign.center,
                      style: TextStyles.InterWhiteS16W600,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: BottomPageButton(
                    onTap: () async {
                      // await StoreRedirect.redirect(
                      //   androidAppId: "com.trastsoursing.mrtomato",
                      //   iOSAppId: "1451697553",
                      // );
                    },
                    text: AppLocale.update
                        .getString(context)
                        .capitalizeFirstLetter()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
