// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Activity/ActivityScreen.dart';
import 'package:teachy_tec/screens/Activity/ActivityScreenVM.dart';
import 'package:teachy_tec/screens/Classes/ClassesScreen.dart';
import 'package:teachy_tec/screens/Classes/ClassesScreenVM.dart';
import 'package:teachy_tec/screens/HomeScreenVM.dart';
import 'package:teachy_tec/screens/Students/StudentsScreen.dart';
import 'package:teachy_tec/screens/Students/StudentsScreenVM.dart';
// import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/Routing/AppAnalyticsConstants.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';
import 'package:teachy_tec/widgets/AdviceContainer.dart';
import 'package:teachy_tec/widgets/homeScreenDetailsButton.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.model, super.key});
  final HomeScreenVM model;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: kMainPadding),
          Expanded(
            child: Stack(
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kMainPadding),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${AppLocale.hi.getString(context).capitalizeFirstLetter()},",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.InterBlackS32W700,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  style: TextStyles.InterBlackS32W700,
                                  children: [
                                    TextSpan(
                                      text: serviceLocator<FirebaseAuth>()
                                          .currentUser!
                                          .displayName,
                                      style: TextStyles.InterYellow700S32W700,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: kMainPadding),
                        MarketCard(
                          text: AppLocale
                              .transformYourClassroomExperienceOurAppSupportsTeachers
                              .getString(context)
                              .capitalizeFirstLetter(),
                        ),
                        const SizedBox(height: kMainPadding),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: HomeScreenDetailsButton(
                                    imageVectorString: 'students',
                                    title: AppLocale.students
                                        .getString(context)
                                        .capitalizeFirstLetter(),
                                    onTapCallBack: () => UIRouter.pushScreen(
                                      StudentsScreen(
                                        model: StudentsScreenVM(
                                          currentClass: null,
                                        ),
                                      ),
                                      showNavigator: true,
                                      pageName:
                                          AppAnalyticsConstants.DashboardScreen,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: kHelpingPadding),
                                Expanded(
                                  child: HomeScreenDetailsButton(
                                    imageVectorString: 'classes',
                                    title: AppLocale.classes
                                        .getString(context)
                                        .capitalizeFirstLetter(),
                                    onTapCallBack: () => UIRouter.pushScreen(
                                      ClassesScreen(model: ClassesScreenVM()),
                                      showNavigator: true,
                                      pageName:
                                          AppAnalyticsConstants.DashboardScreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: kHelpingPadding),
                            Row(
                              children: [
                                Expanded(
                                  child: HomeScreenDetailsButton(
                                    imageVectorString: 'dashboard',
                                    title: AppLocale.activities
                                        .getString(context)
                                        .capitalizeFirstLetter(),
                                    onTapCallBack: () => UIRouter.pushScreen(
                                      ActivityScreen(model: ActivityScreenVM()),
                                      showNavigator: true,
                                      pageName:
                                          AppAnalyticsConstants.DashboardScreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
