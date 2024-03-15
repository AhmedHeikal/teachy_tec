import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Students/StudentPreviewInForm.dart';
import 'package:teachy_tec/screens/Students/StudentsComponentVM.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';

class StudentsComponent extends StatelessWidget {
  const StudentsComponent({required this.model, super.key});
  final StudentsComponentVM model;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: Consumer<StudentsComponentVM>(
        builder: (context, model, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.isPreview
                  ? AppLocale.students
                      .getString(context)
                      .capitalizeFirstLetter()
                  : AppLocale.addStudents
                      .getString(context)
                      .capitalizeFirstLetter(),
              style: TextStyles.InterBlackS16W600,
            ),
            const SizedBox(height: kMainPadding),
            if (!model.isPreview) ...[
              Column(
                children: [
                  InkWell(
                    onTap: model.onUploadFile,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 18,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.grey400),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.25),
                            spreadRadius: 0.5,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/svg/upload.svg'),
                          const SizedBox(width: kHelpingPadding),
                          Text(
                            AppLocale.uploadExcelSheet
                                .getString(context)
                                .capitalizeFirstLetter(),
                            style: TextStyles.InterBlackS16W400,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: kBottomPadding),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.currentFile == null
                              ? AppLocale
                                  .downloadTheFollowingFileToHveCorrectFormat
                                  .getString(context)
                                  .capitalizeFirstLetter()
                              : AppLocale.originalFileAttached
                                  .getString(context)
                                  .capitalizeFirstLetter(),
                          style: TextStyles.InterGrey800S14W300.copyWith(
                              fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: kHelpingPadding),
                        InkWell(
                          onTap: model.downloadFileFromAssets,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: model.currentFile == null
                                      ? AppColors.grey200
                                      : AppColors.primary700),
                              color: model.currentFile == null
                                  ? AppColors.white
                                  : AppColors.primary300,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: kHelpingPadding,
                              horizontal: kBottomPadding,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/svg/xls.svg'),
                                const SizedBox(width: kInternalPadding),
                                Expanded(
                                  child: Text(
                                    model.currentFile == null
                                        ? 'Students Template.xls'
                                        : model.currentFile!.name,
                                    style: TextStyles.InterGrey600S14W500,
                                  ),
                                ),
                                if (model.currentFile == null) ...[
                                  const SizedBox(width: kInternalPadding),
                                  SvgPicture.asset(
                                      'assets/svg/downloadIcon.svg'),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var currentItem = model.studentsList[index];
                return InkWell(
                  onTap: currentItem.isPreview
                      ? () => model.onTapStudentInPreviewDetails(currentItem)
                      : null,
                  child: StudentPreviewInForm(
                    key: UniqueKey(),
                    model: currentItem,
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: kHelpingPadding,
              ),
              itemCount: model.studentsList.length,
            ),
            if (!model.isPreview) ...[
              const SizedBox(height: kMainPadding),
              InkWell(
                onTap: model.onAddNewStudent,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.grey400),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.25),
                        spreadRadius: 0.5,
                        blurRadius: 2,
                        offset:
                            const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/svg/addStudent.svg'),
                      const SizedBox(width: kHelpingPadding),
                      Text(
                        AppLocale.addStudents
                            .getString(context)
                            .capitalizeFirstLetter(),
                        style: TextStyles.InterBlackS16W400,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}
