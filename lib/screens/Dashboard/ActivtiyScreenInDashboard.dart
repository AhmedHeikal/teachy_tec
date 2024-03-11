import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Activity/ActivityPreview.dart';
import 'package:teachy_tec/screens/Activity/ActivityScreenVM.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';

class ActivtiyScreenInDashboard extends StatelessWidget {
  const ActivtiyScreenInDashboard({required this.model, super.key});
  final ActivityScreenVM model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ChangeNotifierProvider.value(
          value: model,
          child: Column(
            children: [
              const SizedBox(height: kMainPadding),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kMainPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppLocale.yourActivities
                            .getString(context)
                            .capitalizeFirstLetter(),
                        // 'Your Activity',
                        style: TextStyles.InterBlackS20W700,
                      ),
                    ),
                    InkWell(
                      onTap: model.onAddActivityTapped,
                      child: Text(
                        "+ ${AppLocale.addBoard.getString(context).capitalizeFirstLetter()}",
                        style: TextStyles.InterYellowS16W600,
                      ),
                    )
                  ],
                ),
              ),
              Consumer<ActivityScreenVM>(
                builder: (context, model, _) => ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
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
                          onDeleteItemCallback: () => model.onDeleteActivity(
                              currentItem,
                              MediaQuery.alwaysUse24HourFormatOf(context)),
                          onDuplicateCallback: () => model.onDuplicateActivity(
                            currentItem,
                          ),
                        ));
                  },
                ),
              ),
            ],
          )),
    );
  }
}
