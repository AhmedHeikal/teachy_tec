import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/widgets/CustomizedDropdown.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final FlutterLocalization localization = FlutterLocalization.instance;
    return CustomizedDropdown(
      items: SupportedLocales.values.map((e) => e.jsonValue).toList(),
      onChange: (name, index) {
        localization.translate(SupportedLocales.values
            .firstWhere((element) => element.jsonValue == name)
            .name);
      },
      chosenItem: SupportedLocales.values
          .firstWhere((element) =>
              element.name == localization.currentLocale?.languageCode)
          .jsonValue,
    );
  }
}
