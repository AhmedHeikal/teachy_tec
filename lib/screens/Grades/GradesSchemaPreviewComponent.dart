import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:teachy_tec/screens/Grades/GradesSchemaPreviewComponentVM.dart';
import 'package:teachy_tec/screens/Grades/SectionComponentVM.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class GradesSchemaPreviewComponent extends StatelessWidget {
  const GradesSchemaPreviewComponent({required this.model, super.key});
  final GradesSchemaPreviewComponentVM model;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...model.gradesFormVM.superSections.map(
          (currentItems) {
            var currentColor = currentItems.colorhex ?? 0xFFFFFFFF;
            var currenSuperSectionHeight = currentItems.selectedSections.fold(
              0,
              (count, innerList) =>
                  count +
                  ((innerList.sectors.length > 1
                          ? innerList.sectors.length
                          : 2) +
                      1),
            );

            var currentSelectedSections = currentItems.selectedSections.length;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DefaultContainer(
                    height: ((currenSuperSectionHeight == 0
                                ? 4
                                : (currenSuperSectionHeight + 1)) *
                            54) +
                        (currentSelectedSections * 2 * kInternalPadding),
                    padding: const EdgeInsets.all(8.0),
                    border: currentColor == 0xFFFFFFFF
                        ? Border.all(color: AppColors.grey200, width: 2)
                        : null,
                    color: Color(currentItems.colorhex ?? 0xFFFFFFFF),
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentItems.name ?? "",
                            style: currentColor == 0xFFFFFFFF
                                ? TextStyles.InterBlackS16W800
                                : TextStyles.InterWhiteS16W800,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: kInternalPadding),
                  Column(
                    children: [
                      Row(
                        children: [
                          DefaultContainer(
                            color: Color(currentColor),
                            border: currentColor == 0xFFFFFFFF
                                ? Border.all(
                                    color: AppColors.grey200,
                                    width: 2,
                                  )
                                : null,
                            borderRadius: const BorderRadiusDirectional.only(
                              topStart: Radius.circular(8),
                              bottomStart: Radius.circular(8),
                            ),
                            width: 128,
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: Center(
                              child: AutoSizeText(
                                "Total Grade",
                                style: currentColor == 0xFFFFFFFF
                                    ? TextStyles.InterBlackS12W600
                                    : TextStyles.InterWhiteS12W600,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DefaultContainer(
                            height: 50,
                            width: 44,
                            border: currentColor == 0xFFFFFFFF
                                ? Border.all(
                                    color: AppColors.grey200,
                                    width: 2,
                                  )
                                : null,
                            borderRadius: const BorderRadiusDirectional.only(
                              topEnd: Radius.circular(8),
                              bottomEnd: Radius.circular(8),
                            ),
                            color: Color(currentItems.colorhex ?? 0xFFFFFFFF),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      (currentItems.selectedSections.fold<num>(
                                          0,
                                          (count, innerList) =>
                                              count +
                                              (innerList.totalGrade.value ??
                                                  0))).toString(),
                                      style: currentColor == 0xFFFFFFFF
                                          ? TextStyles.InterBlackS16W800
                                          : TextStyles.InterWhiteS16W800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: kHelpingPadding),
                      ...currentItems.selectedSections.map(
                        (currentItem) {
                          return SectionGradesPreview(
                            key: UniqueKey(),
                            currentItem: currentItem,
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: model.gradesFormVM.sections
              .where((section) => !model.gradesFormVM.superSections.any(
                  (superSection) => superSection.selectedSections
                      .any((element) => element.id == section.id)))
              .map(
            (currentItem) {
              return SectionGradesPreview(
                key: UniqueKey(),
                currentItem: currentItem,
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}

class SectionGradesPreview extends StatelessWidget {
  const SectionGradesPreview({
    required this.currentItem,
    super.key,
  });
  final SectionComponentVM currentItem;

  @override
  Widget build(BuildContext context) {
    var currentColor = currentItem.colorhex ?? 0xFFFFFFFF;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kInternalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DefaultContainer(
            height: ((currentItem.sectors.length > 1
                        ? currentItem.sectors.length
                        : 2) +
                    1) *
                54,
            border: currentColor == 0xFFFFFFFF
                ? Border.all(
                    color: AppColors.grey200,
                    width: 2,
                  )
                : null,
            padding: const EdgeInsets.all(10),
            color: Color(currentItem.colorhex ?? 0xFFFFFFFF),
            child: RotatedBox(
              quarterTurns: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentItem.name ?? "",
                    style: currentColor == 0xFFFFFFFF
                        ? TextStyles.InterBlackS14W600
                        : TextStyles.InterWhiteS14W600,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    DefaultContainer(
                      color: Color(currentItem.colorhex ?? 0xFFFFFFFF),
                      borderRadius: const BorderRadiusDirectional.only(
                        topStart: Radius.circular(8),
                        bottomStart: Radius.circular(8),
                      ),
                      border: currentColor == 0xFFFFFFFF
                          ? Border.all(
                              color: AppColors.grey200,
                              width: 2,
                            )
                          : null,
                      width: 80,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.all(4),
                      child: Center(
                        child: AutoSizeText(
                          "Total Grade",
                          style: currentColor == 0xFFFFFFFF
                              ? TextStyles.InterBlackS12W600
                              : TextStyles.InterWhiteS12W600,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DefaultContainer(
                      height: 50,
                      width: 44,
                      borderRadius: const BorderRadiusDirectional.only(
                        topEnd: Radius.circular(8),
                        bottomEnd: Radius.circular(8),
                      ),
                      border: currentColor == 0xFFFFFFFF
                          ? Border.all(
                              color: AppColors.grey200,
                              width: 2,
                            )
                          : null,
                      color: Color(currentItem.colorhex ?? 0xFFFFFFFF),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                (currentItem.totalGrade.value ?? 0).toString(),
                                style: currentColor == 0xFFFFFFFF
                                    ? TextStyles.InterBlackS12W800
                                    : TextStyles.InterWhiteS16W800,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ...currentItem.sectors.map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        DefaultContainer(
                          width: 80,
                          height: 50,
                          border: currentColor == 0xFFFFFFFF
                              ? Border.all(
                                  color: AppColors.grey200,
                                  width: 2,
                                )
                              : null,
                          borderRadius: const BorderRadiusDirectional.only(
                            topStart: Radius.circular(8),
                            bottomStart: Radius.circular(8),
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.all(4),
                          child: Center(
                            child: Text(
                              (e.name ?? ""),
                              style: TextStyles.InterBlackS12W600,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DefaultContainer(
                          height: 50,
                          width: 44,
                          borderRadius: const BorderRadiusDirectional.only(
                            topEnd: Radius.circular(8),
                            bottomEnd: Radius.circular(8),
                          ),
                          border: currentColor == 0xFFFFFFFF
                              ? Border.all(
                                  color: AppColors.grey200,
                                  width: 2,
                                )
                              : null,
                          color: Color(currentItem.colorhex ?? 0xFFFFFFFF),
                          child: Center(
                            child: Text(
                              (e.realWeight ?? 0).toString(),
                              style: currentColor == 0xFFFFFFFF
                                  ? TextStyles.InterBlackS14W400
                                  : TextStyles.InterWhiteS14W400,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
