// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';
import 'package:teachy_tec/widgets/Appbar.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  @override
  void initState() {
    super.initState();
    // serviceLocator<FlutterLocalization>().onTranslatedLanguage =
    //     _onTranslatedLanguage;

    // TODO: implement initState
  }

  // void _onTranslatedLanguage(Locale? locale) {
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final FlutterLocalization localization = FlutterLocalization.instance;

    return Scaffold(
      appBar: CustomAppBar(
          screenName:
              AppLocale.language.getString(context).capitalizeFirstLetter()),
      body: DefaultContainer(
        margin: const EdgeInsets.symmetric(
            vertical: 22, horizontal: kHelpingPadding),
        child: ListView.builder(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var item = SupportedLocales.values[index];
            return Padding(
              padding: const EdgeInsets.all(kBottomPadding),
              child: InkWell(
                onTap: () {
                  localization.translate(SupportedLocales.values
                      .firstWhere(
                          (element) => element.jsonValue == item.jsonValue)
                      .name);
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      item.name ==
                              serviceLocator<FlutterLocalization>()
                                  .currentLocale!
                                  .languageCode
                          ? 'assets/svg/activeRadioButton.svg'
                          : 'assets/svg/inActiveRadioButton.svg',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        AppUtility.getLanguageString(item.name),
                        style: TextStyles.InterGrey700S14W500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: SupportedLocales.values.length,
        ),
      ),
    );
  }
}
