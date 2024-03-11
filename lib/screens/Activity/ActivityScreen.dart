import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Activity/ActivityPreview.dart';
import 'package:teachy_tec/screens/Activity/ActivityScreenVM.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/AppPullToRefreshComponent.dart';
import 'package:teachy_tec/widgets/Appbar.dart';
import 'package:teachy_tec/widgets/CalendarWidget.dart';
import 'package:teachy_tec/widgets/EmptyPlugins.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key, required this.model});
  final ActivityScreenVM model;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AppPullToRefreshComponent(
        onRefresh: model.getActivities,
        child: ChangeNotifierProvider.value(
          value: model,
          child: Scaffold(
            appBar: CustomAppBar(
              screenName:
                  AppLocale.activities.getString(context).capitalizeAllWord(),
              actions: [
                InkWell(
                  onTap: model.onAddActivityTapped,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kMainPadding),
                    child: SvgPicture.asset(
                      'assets/svg/addButton.svg',
                    ),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  CalendarWidget(
                    onSelectDate: model.onSelectDate,
                    onSelectDateRange: model.onSelectDateRange,
                    onChangeMultiDaySelectionCallback:
                        model.onToggleDaySelection,
                  ),
                  const SizedBox(height: kMainPadding),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kMainPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppLocale.yourActivities
                                .getString(context)
                                .capitalizeAllWord(),
                            style: TextStyles.InterBlackS20W700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Consumer<ActivityScreenVM>(
                      builder: (context, model, _) {
                        if (!model.isInitialized) return Container();
                        if (model.activitiesList.isEmpty) {
                          return EmptyPlugin(
                            plugin: AppPluginsItems().activitiesEmptyPlugin,
                          );
                        }

                        return ListView.separated(
                          physics: const ClampingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: kMainPadding, vertical: kMainPadding),
                          shrinkWrap: true,
                          itemCount: model.activitiesList.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: kHelpingPadding),
                          itemBuilder: (context, index) {
                            var currentItem = model.activitiesList[index];
                            return InkWell(
                              onTap: () => model.onOpenActivity(currentItem),
                              child: ActivityPreview(
                                model: currentItem,
                                onDuplicateCallback: () =>
                                    model.onDuplicateActivity(
                                  currentItem,
                                ),
                                onDeleteItemCallback: () =>
                                    model.onDeleteActivity(
                                        currentItem,
                                        MediaQuery.alwaysUse24HourFormatOf(
                                            context)),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
