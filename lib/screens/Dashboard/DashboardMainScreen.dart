import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/screens/Dashboard/ActivtiyScreenInDashboard.dart';
import 'package:teachy_tec/screens/Dashboard/DashboardMainScreenVM.dart';
import 'package:teachy_tec/screens/Dashboard/GradesScreen.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/widgets/CalendarWidget.dart';

class DashboardMainScreen extends StatelessWidget {
  const DashboardMainScreen({super.key, required this.model});
  final DashboardMainScreenVM model;

  @override
  Widget build(BuildContext context) {
    const Color activeButtonColor = AppColors.grey900;
    const Color inActiveButtonColor = Colors.transparent;
    const TextStyle activeTextColor = TextStyles.InterYellow700S16W500;
    const TextStyle inActiveTextColor = TextStyles.InterGrey900S16W500;

    return ChangeNotifierProvider.value(
      value: model,
      child: Consumer<DashboardMainScreenVM>(
        builder: (context, model, _) => Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: kMainPadding),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: kMainPadding),
                  decoration: BoxDecoration(
                    color: AppColors.primary500.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: InkWell(
                          onTap: () => model.toggleSelectedButton(true),
                          child: Container(
                            width: 120,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: model.isFirstPageChoosen
                                  ? activeButtonColor
                                  : inActiveButtonColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                model.firstPageName,
                                style: model.isFirstPageChoosen
                                    ? activeTextColor
                                    : inActiveTextColor,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: InkWell(
                          onTap: () => model.toggleSelectedButton(false),
                          child: Container(
                            width: 120,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: !model.isFirstPageChoosen
                                  ? activeButtonColor
                                  : inActiveButtonColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                model.secondPageName,
                                style: !model.isFirstPageChoosen
                                    ? activeTextColor
                                    : inActiveTextColor,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kMainPadding),
                CalendarWidget(
                  onSelectDate: model.onSelectDay,
                  onSelectDateRange: model.onSelecDateRange,
                  onChangeMultiDaySelectionCallback:
                      model.onChangeMultiDaySelectionCallback,
                ),
                const SizedBox(height: kMainPadding),
                model.isFirstPageChoosen
                    ? GradesScreen(model: model.gradesScreenVM)
                    : ActivtiyScreenInDashboard(model: model.activityScreenVM),
                // To avoid the bottom navigation bar
                const SizedBox(height: 110),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
