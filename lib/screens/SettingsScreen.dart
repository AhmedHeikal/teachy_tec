import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/hive/injector/hiveInjector.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Settings/ChangeLanguage.dart';
import 'package:teachy_tec/screens/SettingsScreenVM.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/utils/Routing/AppAnalyticsConstants.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';
import 'package:teachy_tec/widgets/AboutScreen.dart';
import 'package:teachy_tec/widgets/AppButtons.dart';
import 'package:teachy_tec/widgets/Appbar.dart';
import 'package:teachy_tec/widgets/Popups/PublishItemsPopup.dart';
import 'package:teachy_tec/widgets/PrivacyPolicyScreen.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({required this.model, Key? key}) : super(key: key);
  final SettingsScreenVM model;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: Consumer<SettingsScreenVM>(
        builder: (context, model, _) => Scaffold(
          appBar: CustomAppBar(
            containsBackButton: false,
            screenName:
                AppLocale.settings.getString(context).capitalizeFirstLetter(),
            actions: [
              InkWell(
                onTap: () async {
                  await GoogleSignIn().signOut();
                  serviceLocator<FirebaseAuth>().signOut();
                  UIRouter.RestartApp(context: context);
                },
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      kHelpingPadding, kHelpingPadding, kMainPadding, 0),
                  child: SizedBox(
                    width: 24,
                    child: SvgPicture.asset(
                      'assets/svg/exit.svg',
                      // matchTextDirection: true,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary700,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                DefaultContainer(
                  color: AppColors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      children: [
                        settingDetailsRow(
                          name: AppLocale.language
                              .getString(context)
                              .capitalizeFirstLetter(),
                          onTap: () => UIRouter.pushScreen(
                              const ChangeLanguageScreen(),
                              pageName: AppAnalyticsConstants.ActivityScreen),
                          details: Row(
                            children: [
                              Text(
                                AppUtility.getLanguageString(
                                  serviceLocator<FlutterLocalization>()
                                      .currentLocale!
                                      .languageCode
                                      .toLowerCase(),
                                ),
                                style: TextStyles.InterGrey500S14W500,
                              ),
                              const SizedBox(width: 12),
                              Transform.rotate(
                                angle: pi,
                                child: SvgPicture.asset(
                                  AppUtility.getArrowAssetLocalized(),
                                  height: 14,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.grey400,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        settingDetailsRow(
                          name: AppLocale.privacyPolicyTermsOfUse
                              .getString(context)
                              .capitalizeFirstLetter(),
                          onTap: () => UIRouter.pushScreen(
                              const PrivacyPolicyScreen(),
                              pageName:
                                  AppAnalyticsConstants.PrivacyPolicyScreen),
                          details: Transform.rotate(
                            angle: pi,
                            child: SvgPicture.asset(
                              AppUtility.getArrowAssetLocalized(),
                              height: 14,
                              colorFilter: const ColorFilter.mode(
                                AppColors.grey400,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        settingDetailsRow(
                          name: AppLocale.aboutTeachyTec
                              .getString(context)
                              .capitalizeFirstLetter(),
                          onTap: () => UIRouter.pushScreen(
                            const AboutScreen(),
                            // TomatoAboutScreen(),
                            pageName:
                                AppAnalyticsConstants.TeachyTecAboutScreen,
                          ),
                          details: Transform.rotate(
                            angle: pi,
                            child: SvgPicture.asset(
                              AppUtility.getArrowAssetLocalized(),
                              height: 14,
                              colorFilter: const ColorFilter.mode(
                                AppColors.grey400,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        settingDetailsRow(
                          name: AppLocale.deleteAccount
                              .getString(context)
                              .capitalizeFirstLetter(),
                          style: TextStyles.InterGrey800S14W500.copyWith(
                              color: AppColors.red700),
                          onTap: model.onDeleteUser,
                          details: Transform.rotate(
                            angle: pi,
                            child: SvgPicture.asset(
                              AppUtility.getArrowAssetLocalized(),
                              height: 14,
                              colorFilter: const ColorFilter.mode(
                                AppColors.grey400,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                BottomPageButton(
                  onTap: () {
                    UIRouter.showAppBottomDrawerWithCustomWidget(
                      bottomPadding: 0,
                      child: PublishItemsPopup(
                        publishButtonText: AppLocale.clearCache
                            .getString(context)
                            .capitalizeFirstLetter(),
                        publishedText: AppLocale.clearCache
                            .getString(context)
                            .capitalizeFirstLetter(),
                        publishedDecritpionText: AppLocale
                            .clearEntireCacheDescription
                            .getString(context)
                            .capitalizeFirstLetter(),

                        // 'Mr. Tomato uses caching to make the app faster and easier to use. If you have storage or memory issues, you can use "Clear Entire Cache" to free up space.\n\nThis will remove stored media and documents, but you can still access them again by re-downloading from the cloud.',
                        publishPressed: () async {
                          UIRouter.popScreen(rootNavigator: true);
                          await HiveInjector.cleanHiveDatabaseLocally();
                          UIRouter.RestartApp(context: context);
                        },
                      ),
                    );
                  },
                  text: AppLocale.clearEntrireCache
                      .getString(context)
                      .capitalizeFirstLetter(),

                  // 'Clear Entire Cache',
                  // isActive: networkConnection.connectionStatus !=
                  //     ConnectivityResult.none,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget settingDetailsRow(
    {required String name,
    Widget? nameDetailsRow,
    VoidCallback? onTap,
    required Widget details,
    bool isDeactivated = false,
    TextStyle style = TextStyles.InterGrey800S14W500,
    bool isLoading = false}) {
  return Container(
    color: isDeactivated ? AppColors.grey300 : null,
    child: InkWell(
      onTap: isLoading ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kMainPadding,
          vertical: kBottomPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: style,
                  ),
                  if (nameDetailsRow != null) ...[
                    const SizedBox(height: 2),
                    nameDetailsRow
                  ],
                ],
              ),
            ),
            const SizedBox(width: kInternalPadding),
            isLoading
                ? const SizedBox(
                    height: 10,
                    width: 10,
                    child: CircularProgressIndicator(
                      color: AppColors.primary700,
                      strokeWidth: 1,
                    ),
                  )
                : details,
          ],
        ),
      ),
    ),
  );
}
