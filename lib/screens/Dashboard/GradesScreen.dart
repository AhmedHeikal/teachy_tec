import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Dashboard/GradesScreenVM.dart';
import 'package:teachy_tec/screens/Dashboard/StudentPreviewDashboadVM.dart';
import 'package:teachy_tec/screens/Dashboard/StudentPreviewInDashboard.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/CustomizedDropdown.dart';

class GradesScreen extends StatelessWidget {
  const GradesScreen({required this.model, super.key});
  final GradesScreenVM model;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: Consumer<GradesScreenVM>(
        builder: (context, model, _) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: kMainPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocale.pleaseChooseClassForGrading
                    .getString(context)
                    .capitalizeFirstLetter(),
                // 'Please choose class for grading',
                style: TextStyles.InterGrey400S12W600,
              ),
              ValueListenableBuilder<bool>(
                valueListenable: model.isClassesLoading,
                builder: (context, isLoading, child) => CustomizedDropdown(
                  // emptyChoiceText: 'Class Titles',
                  // emptyChoiceChosenText: 'Class Title',
                  chosenItem: model.selectedClass?.name,
                  items: [
                    AppLocale.classTitle.getString(context).capitalizeAllWord(),
                    ...model.classes.map((e) => e.name)
                  ],
                  onChange: (name, index) {
                    model.onSelectClass(name);
                  },
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: kMainPadding),
                itemBuilder: (context, index) {
                  var currentItem = model.currentlyItem.entries.toList()[index];
                  return StudentPreviewInDashboard(
                    key: UniqueKey(),
                    model: StudentPreviewInDashboardVM(),
                    student: currentItem.key,
                    tasks: currentItem.value,
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: model.currentlyItem.entries.toList().length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
