import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';

class EmptyPlugin extends StatelessWidget {
  const EmptyPlugin({super.key, this.alignTop = false, required this.plugin});
  final EmptyPluginClass plugin;
  final bool alignTop;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment:
                alignTop ? MainAxisAlignment.start : MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              plugin.isGIF
                  ? Image.asset(
                      plugin.path,
                      height: 200,
                      width: 200,
                    )
                  : SvgPicture.asset(
                      plugin.path,
                    ),
              const SizedBox(height: kHelpingPadding),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kMainPadding),
                child: Text(
                  plugin.text,
                  style: TextStyles.InterGrey400S16W400,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class AppPluginsItems {
  EmptyPluginClass studentsEmptyPlugin = const EmptyPluginClass(
    path: 'assets/EmptyPlugins/StudentsEmptyState.svg',
    text: 'No Students to display yet',
    isGIF: false,
  );

  EmptyPluginClass activitiesEmptyPlugin = const EmptyPluginClass(
    path: 'assets/EmptyPlugins/ActivitiesEmptyState.svg',
    text: 'No Activities to display yet',
    isGIF: false,
  );
  EmptyPluginClass classesEmptyPlugin = const EmptyPluginClass(
    path: 'assets/EmptyPlugins/ClassesEmptyState.svg',
    text: 'No Classes to display yet',
    isGIF: false,
  );
}

class EmptyPluginClass {
  final String path;
  final String text;
  final bool isGIF;
  const EmptyPluginClass(
      {required this.path, required this.text, required this.isGIF});
}
