import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/models/Schema.dart';
import 'package:teachy_tec/screens/Grades/SchemaTable.dart';
import 'package:teachy_tec/screens/Grades/SchemaTableVM.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/utils/Routing/AppAnalyticsConstants.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class SchemaPreview extends StatelessWidget {
  const SchemaPreview({required this.model, super.key});
  final Schema model;
  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
        boxShadow: KdefaultShadow,
        padding: const EdgeInsets.all(kBottomPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    model.name,
                    style: TextStyles.InterGrey600S16W600,
                  ),
                ),
                InkWell(
                  // onTap: onDuplicateCallback,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kInternalPadding),
                    child: SvgPicture.asset(
                      'assets/svg/copy.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary700,
                        BlendMode.srcIn,
                      ),
                      height: 32,
                    ),
                  ),
                ),
                InkWell(
                  // onTap: onDeleteItemCallback,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kInternalPadding),
                    child: SvgPicture.asset(
                      'assets/svg/bin.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary700,
                        BlendMode.srcIn,
                      ),
                      height: 38,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: kHelpingPadding),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/svg/clock.svg',
                  colorFilter: const ColorFilter.mode(
                    AppColors.grey500,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: kHelpingPadding),
                Text(
                  AppUtility.appTimeFormat(
                      DateTime.fromMillisecondsSinceEpoch(model.timestamp),
                      showTime: true),
                  style: TextStyles.InterGrey500S14W400,
                ),
              ],
            ),
            const SizedBox(height: kHelpingPadding),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/svg/classes.svg',
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    AppColors.grey500,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: kHelpingPadding),
                Text(
                  AppLocale.classes.getString(context).capitalizeFirstLetter(),
                  style: TextStyles.InterGrey500S14W400,
                ),
              ],
            ),
            const SizedBox(height: kHelpingPadding),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: kHelpingPadding),
              itemCount: model.classes.length,
              itemBuilder: (context, index) {
                var currentItem = model.classes[index];
                bool isCurrentItemActive = currentItem.isActive;
                return InkWell(
                  onTap: () => UIRouter.pushScreen(
                      SchemaTable(
                        model: SchemaTableVM(
                            schema: model, selectedClass: currentItem),
                      ),
                      pageName: AppAnalyticsConstants.SchemaTableScreen),
                  child: DefaultContainer(
                    boxShadow: KdefaultShadow,
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        DefaultContainer(
                          padding: const EdgeInsets.all(kInternalPadding),
                          color: AppColors.grey600,
                          child: Text(
                            currentItem.name,
                            style: TextStyles.InterWhiteS12W400,
                          ),
                        ),
                        const SizedBox(width: kMainPadding * 1.5),
                        DottedBorder(
                          color: AppColors.green600,
                          borderType: BorderType.RRect,
                          dashPattern: const <double>[7, 6],
                          radius: const Radius.circular(50),
                          strokeWidth: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kInternalPadding, vertical: 3),
                            child: Row(
                              children: [
                                Container(
                                  height: 8,
                                  width: 8,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isCurrentItemActive
                                          ? AppColors.green600
                                          : AppColors.red600),
                                ),
                                const SizedBox(width: kInternalPadding),
                                Text(
                                  isCurrentItemActive ? 'Active' : 'Inactive',
                                  style: TextStyles.InterGrey600S12W600,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          // onTap: onDeleteItemCallback,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kInternalPadding),
                            child: SvgPicture.asset(
                              'assets/svg/download.svg',
                              colorFilter: const ColorFilter.mode(
                                AppColors.grey500,
                                BlendMode.srcIn,
                              ),
                              height: 20,
                            ),
                          ),
                        ),
                        const InkWell(
                          // onTap: onDeleteItemCallback,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: kInternalPadding),
                              child: Icon(
                                Icons.keyboard_arrow_right_rounded,
                                color: AppColors.grey500,
                                size: 30,
                              )

                              // SvgPicture.asset(
                              //   'assets/svg/rightArrow.svg',
                              //   colorFilter: const ColorFilter.mode(
                              //     AppColors.grey500,
                              //     BlendMode.srcIn,
                              //   ),
                              //   height: 20,
                              // ),
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ));
  }
}
