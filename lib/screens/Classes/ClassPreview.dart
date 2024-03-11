import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teachy_tec/models/Class.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class ClassPreview extends StatelessWidget {
  const ClassPreview(
      {required this.model,
      required this.onEditTapped,
      required this.onDeleteTapped,
      super.key});
  final Class model;
  final VoidCallback onEditTapped;
  final VoidCallback onDeleteTapped;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DefaultContainer(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            color: AppColors.grey800,
          ),
          padding: const EdgeInsets.symmetric(
              vertical: kBottomPadding, horizontal: kBottomPadding),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  model.name,
                  style: TextStyles.InterWhiteS16W400,
                ),
              ),
              SvgPicture.asset(
                AppUtility.getArrowAssetLocalized(rightArrowInLTR: false),
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
        DefaultContainer(
          padding: const EdgeInsets.symmetric(
              horizontal: kMainPadding, vertical: kInternalPadding),
          decoration: BoxDecoration(
            boxShadow: kListShadowsArray,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            color: AppColors.white,
            border: Border.all(color: AppColors.grey200),
          ),
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (model.department != null) ...[
                      Text(
                        model.department!,
                        style: TextStyles.InterGrey700S16W400,
                      ),
                      const SizedBox(height: 4),
                    ],
                    if (model.grade_level != null)
                      Text(
                        model.grade_level!,
                        style: TextStyles.InterGrey700S16W400,
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: onEditTapped,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
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
                    onTap: onDeleteTapped,
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
              )

              // InkWell(
              //   onTap: onEditTapped,
              //   child: Row(
              //     children: [
              //       SvgPicture.asset(
              //         'assets/svg/pen.svg',
              //         colorFilter: const ColorFilter.mode(
              //           AppColors.grey900,
              //           BlendMode.srcIn,
              //         ),
              //         height: 24,
              //       ),
              //       const SizedBox(width: 4),
              //       SvgPicture.asset(
              //         'assets/svg/bin.svg',
              //         colorFilter: const ColorFilter.mode(
              //           AppColors.grey900,
              //           BlendMode.srcIn,
              //         ),
              //         height: 28,
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        )
      ],
    );
  }
}
