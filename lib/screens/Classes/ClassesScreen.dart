import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Classes/ClassPreview.dart';
import 'package:teachy_tec/screens/Classes/ClassesScreenVM.dart';
import 'package:teachy_tec/screens/Students/StudentsScreen.dart';
import 'package:teachy_tec/screens/Students/StudentsScreenVM.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/Routing/AppAnalyticsConstants.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/widgets/AppPullToRefreshComponent.dart';
import 'package:teachy_tec/widgets/Appbar.dart';
import 'package:teachy_tec/widgets/EmptyPlugins.dart';

class ClassesScreen extends StatelessWidget {
  const ClassesScreen({required this.model, super.key});
  final ClassesScreenVM model;
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: Scaffold(
        appBar: CustomAppBar(
          screenName:
              AppLocale.classes.getString(context).capitalizeFirstLetter(),
          actions: [
            InkWell(
              onTap: model.onAddNewClass,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kMainPadding,
                  // left: kMainPadding,
                  // right: kMainPadding,
                ),
                child: SvgPicture.asset(
                  'assets/svg/addButton.svg',
                ),
              ),
            ),
          ],
        ),
        body: Consumer<ClassesScreenVM>(builder: (context, model, _) {
          if (!model.isInitialized) return Container();
          if (model.classes.isEmpty) {
            return EmptyPlugin(
              plugin: AppPluginsItems().classesEmptyPlugin,
            );
          }

          return SafeArea(
            child: AppPullToRefreshComponent(
              onRefresh: () => model.getClassesList(),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                    horizontal: kMainPadding, vertical: kMainPadding),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var currentClass = model.classes[index];
                  return InkWell(
                    onTap: () {
                      UIRouter.pushScreen(
                          StudentsScreen(
                              model:
                                  StudentsScreenVM(currentClass: currentClass)),
                          pageName: AppAnalyticsConstants.StudentsScreen);
                    },
                    child: ClassPreview(
                      key: UniqueKey(),
                      onEditTapped: () =>
                          model.onEditClass(classToEdit: currentClass),
                      onDeleteTapped: () =>
                          model.onDeleteClass(classToEdit: currentClass),
                      model: currentClass,
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: kMainPadding),
                itemCount: model.classes.length,
              ),
            ),
          );
        }),
      ),
    );
  }
}
