import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Grades/GradesFormVM.dart';
import 'package:teachy_tec/screens/Grades/GradesSchemaPreviewComponent.dart';
import 'package:teachy_tec/screens/Grades/GradesSchemaPreviewComponentVM.dart';
import 'package:teachy_tec/screens/Grades/SuperSectionForm.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/AppButtons.dart';
import 'package:teachy_tec/widgets/Appbar.dart';
import 'package:teachy_tec/widgets/SuperSectionEmptyContainer.dart';

class GradesFormSecondPage extends StatelessWidget {
  const GradesFormSecondPage({required this.model, super.key});
  final GradesFormVM model;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.grey50,
        appBar: CustomAppBar(
          screenName: 'New Grades Schema',
        ),
        bottomNavigationBar: AppBottomNavCustomWidget(
          child: BottomPageButton(
            onTap: model.onSubmitForm,
            text: AppLocale.create.getString(context).capitalizeFirstLetter(),
          ),
        ),
        body: ChangeNotifierProvider.value(
          value: model,
          child: Consumer<GradesFormVM>(
            builder: (context, model, _) => SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: kMainPadding),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      model.sections.isEmpty
                          ? const SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: kBottomPadding),
                                const Text('Super Sections',
                                    style: TextStyles.InterBlackS16W600),
                                const SizedBox(height: kBottomPadding),
                                const SuperSectionEmptyContainer(),
                                const SizedBox(height: kMainPadding),
                                ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var currentItem =
                                        model.superSections[index];
                                    return SuperSectionForm(
                                      key: UniqueKey(),
                                      model: currentItem,
                                      onDelete: () =>
                                          model.onDeleteSuperSection(index),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: kMainPadding);
                                  },
                                  itemCount: model.superSections.length,
                                ),
                                InkWell(
                                  onTap: model.onAddSuperSectionSection,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: kBottomPadding,
                                      vertical: kMainPadding,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/svg/PlusSVG.svg',
                                          color: AppColors.primary700,
                                        ),
                                        const SizedBox(width: kInternalPadding),
                                        Text(
                                            'Add Supper Section'
                                                .capitalizeFirstLetter(),
                                            style: TextStyles
                                                .InterYellow700S16W600),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      const SizedBox(height: kMainPadding),
                      const Text(
                        'Schema Preview',
                        style: TextStyles.InterBlackS16W600,
                      ),
                      const SizedBox(height: kMainPadding),
                      Align(
                        child: SizedBox(
                          width: 250,
                          child: GradesSchemaPreviewComponent(
                              model: GradesSchemaPreviewComponentVM(
                                  gradesFormVM: model)),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
