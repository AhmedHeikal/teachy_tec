// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Activity/CustomQuestionComponentVM.dart';
import 'package:teachy_tec/screens/Activity/CustomQuestionForm.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/HorizontalDottedLine.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class CustomQuestionComponent extends StatelessWidget {
  const CustomQuestionComponent({super.key, required this.model});
  final CustomQuestionComponentVM model;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: Column(
        children: [
          Consumer<CustomQuestionComponentVM>(
            builder: (context, model, _) => DefaultContainer(
              margin: EdgeInsets.only(
                top: model.questions.isEmpty ? 0 : kBottomPadding,
              ),
              color: AppColors.grey50,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var item = model.questions[index];
                  return CustomQuestionForm(
                    key: UniqueKey(),
                    model: item,
                    index: index + 1,
                    onDelete: () => model.onDeleteQuestion(index),
                  );
                },
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.fromLTRB(
                    kBottomPadding,
                    kBottomPadding,
                    kBottomPadding,
                    kHelpingPadding,
                  ),
                  child: HorizontalDottedLine(),
                ),
                itemCount: model.questions.length,
              ),
            ),
          ),
          if (!model.isTasksReadOnlyInEditMode)
            DefaultContainer(
              color: AppColors.grey50,
              child: InkWell(
                onTap: model.onAddMultipleAnswersQuestion,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kBottomPadding,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                          AppLocale.addTask
                              .getString(context)
                              .capitalizeFirstLetter(),
                          style: TextStyles.InterYellow700S16W600),
                      const SizedBox(width: kInternalPadding),
                      SvgPicture.asset(
                        'assets/svg/PlusSVG.svg',
                        color: AppColors.primary700,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
