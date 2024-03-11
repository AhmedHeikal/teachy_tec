import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/screens/Students/StudentForm.dart';
import 'package:teachy_tec/screens/Students/StudentPreviewInFormVM.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppEnums.dart';

class StudentPreviewInForm extends StatelessWidget {
  const StudentPreviewInForm({required this.model, super.key});
  final StudentPreviewInFormVM model;

  @override
  Widget build(BuildContext context) {
    String getAssetValue() {
      if (model.currentStudent.gender == Gender.male) {
        return 'assets/svg/male.svg';
      } else if (model.currentStudent.gender == Gender.female) {
        return 'assets/svg/female.svg';
      }
      return 'assets/svg/male.svg';
    }

    return ChangeNotifierProvider.value(
      value: model,
      child: Consumer<StudentPreviewInFormVM>(
        builder: (context, model, _) => Container(
          margin: EdgeInsets.only(
              top: !model.isPreview && model.isInEditMode ? kMainPadding : 0,
              bottom:
                  !model.isPreview && model.isInEditMode ? kMainPadding : 0),
          padding: const EdgeInsets.symmetric(
              vertical: 10, horizontal: kBottomPadding),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.grey400.withOpacity(0.30),
                spreadRadius: 2,
                blurRadius: 0,
                offset: const Offset(1, 1),
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: !model.isPreview && model.isInEditMode
              ? StudentForm(
                  key: UniqueKey(),
                  model: model.studentFormVM,
                )
              : Row(
                  key: UniqueKey(),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(kBottomPadding),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primary700,
                          ),
                          shape: BoxShape.circle),
                      child: SvgPicture.asset(
                        getAssetValue(),
                      ),
                    ),
                    const SizedBox(width: kInternalPadding),
                    Expanded(
                      child: Text(
                        model.currentStudent.name,
                        style: TextStyles.InterGrey800S12W400,
                      ),
                    ),
                    if (!model.isPreview) ...[
                      Row(
                        children: [
                          InkWell(
                            onTap: model.onEditTappedInForm,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: SvgPicture.asset(
                                'assets/svg/pen.svg',
                                colorFilter: const ColorFilter.mode(
                                  AppColors.grey900,
                                  BlendMode.srcIn,
                                ),
                                height: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: model.onDeleteTapped,
                            child: SvgPicture.asset(
                              'assets/svg/bin.svg',
                              colorFilter: const ColorFilter.mode(
                                AppColors.grey900,
                                BlendMode.srcIn,
                              ),
                              height: 28,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
