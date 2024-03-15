import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Students/StudentPreview.dart';
import 'package:teachy_tec/screens/Students/StudentsScreenVM.dart';
import 'package:teachy_tec/screens/Students/studentDetailsScreen.dart';
import 'package:teachy_tec/screens/Students/studentDetailsScreenVM.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/Routing/AppAnalyticsConstants.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/widgets/AppPullToRefreshComponent.dart';
import 'package:teachy_tec/widgets/Appbar.dart';
import 'package:teachy_tec/widgets/EmptyPlugins.dart';
import 'package:teachy_tec/widgets/RoundedTextField.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({required this.model, super.key});
  final StudentsScreenVM model;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: CustomAppBar(
            screenName: model.currentClass?.name ??
                AppLocale.studentsList
                    .getString(context)
                    .capitalizeFirstLetter(),
            actions: [
              InkWell(
                onTap: model.onTapAddNewStudent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kMainPadding),
                  child: SvgPicture.asset(
                    'assets/svg/addButton.svg',
                  ),
                ),
              ),
            ],
          ),
          // if (!model.isInitialized) return Container();
          //         if (model.activitiesList.isEmpty) {
          //           return EmptyPlugin(
          //             plugin: AppPluginsItems().activitiesEmptyPlugin,
          //           );
          //         }

          body: SafeArea(
            child: AppPullToRefreshComponent(
              onRefresh: () => model.getStudentsList(),
              child: Consumer<StudentsScreenVM>(
                builder: (context, model, _) {
                  if (!model.isInitialized) return Container();
                  if (model.students.isEmpty && model.studentsCount == 0) {
                    return EmptyPlugin(
                        plugin: AppPluginsItems().studentsEmptyPlugin);
                  }
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: kMainPadding),
                      child: Column(
                        children: [
                          const SizedBox(height: kMainPadding),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: SearchTextField(
                                  hintText: AppLocale.searchByStudentOrClassName
                                      .getString(context)
                                      .capitalizeFirstLetter(),
                                  onChanged: model.onSearch,
                                  onCancelSearchFunction: () =>
                                      model.onSearch(""),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: kMainPadding),
                          model.students.isEmpty
                              ? Container()
                              : ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(
                                      bottom: kMainPadding),
                                  itemBuilder: (context, index) {
                                    var currentItem = model.students[index];
                                    return InkWell(
                                      onTap: () => UIRouter.pushScreen(
                                          StudentDetailsScreen(
                                              model: StudentDetailsScreenVM(
                                            currentStudent: currentItem,
                                            onDeleteStudent: () {
                                              model.students.removeAt(index);
                                              model.onUpdateStudent(
                                                  model.students);
                                            },
                                            onUpdateStudent: (newStudent) {
                                              currentItem = newStudent;
                                              model.students[index] =
                                                  newStudent;
                                              model.onUpdateStudent(
                                                  model.students);
                                            },
                                          )),
                                          pageName: AppAnalyticsConstants
                                              .StudentDetailsScreen),
                                      child: StudentPreview(
                                          key: UniqueKey(), model: currentItem),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: kMainPadding);
                                  },
                                  itemCount: model.students.length,
                                )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
