import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/utils/UIRouter.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? screenName;
  final bool containsBackButton;
  final List<Widget>? actions;
  final void Function()? onBackTapped;

  CustomAppBar({
    Key? key,
    required this.screenName,
    this.onBackTapped,
    this.containsBackButton = true,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: KboxBlurredShadowsArray,
        color: AppColors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: SizedBox(
              // padding: EdgeInsets.only(top: topPadding),
              width: double.infinity,
              // height: kToolbarHeight + topPadding + kMainPadding,
              // decoration: BoxDecoration(
              //   boxShadow: KboxBlurredShadowsArray,
              //   color: TomatoColors.White,
              // ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.directional(
                    textDirection: AppUtility.getTextDirectionality(),
                    start: 0,
                    bottom: 0,
                    child: containsBackButton
                        ? InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: onBackTapped ??
                                () => UIRouter.popScreen(
                                    context:
                                        context) /*  Navigator.of(context).pop() */,
                            child: Container(
                              padding: const EdgeInsetsDirectional.only(
                                  end: kMainPadding),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    start: kMainPadding),
                                child: SvgPicture.asset(
                                    AppUtility.getArrowAssetLocalized(),
                                    height: 22,
                                    colorFilter: const ColorFilter.mode(
                                        AppColors.grey400, BlendMode.srcATop)
                                    // color: TomatoColors.Grey400,
                                    ),
                              ),
                              // child: Row(
                              //   mainAxisSize: MainAxisSize.min,
                              //   crossAxisAlignment: CrossAxisAlignment.end,
                              //   children: [
                              //     SizedBox(
                              //       width: kMainPadding,
                              //     )
                              //   ],
                              // ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                  if (screenName != null)
                    Positioned.directional(
                      textDirection: AppUtility.getTextDirectionality(),
                      start: 70,
                      end: 70,
                      bottom: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: KboxBlurredShadowsArray),
                            child: Text(
                              //  AutoSizeText(
                              AppUtility.capitalizeAllWord(screenName!),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              // maxFontSize: 16,
                              // minFontSize: 14,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.InterGrey800S16W600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (actions != null)
                    Positioned.directional(
                        textDirection: AppUtility.getTextDirectionality(),
                        end: 0,
                        bottom: 0,
                        child: SizedBox(
                          width: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: actions!,
                          ),
                        ))
                ],
              ),
            ),
          ),
          const SizedBox(
            height: kBottomPadding,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(screenName == null ? 0 : kToolbarHeight);
}

class BlurredAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? screenName;
  final bool containsBackButton;
  final List<Widget>? actions;
  final void Function()? onBackTapped;

  const BlurredAppBar({
    super.key,
    required this.screenName,
    this.onBackTapped,
    this.containsBackButton = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(
              0.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: SizedBox(
                  // padding: EdgeInsets.only(top: topPadding),
                  width: double.infinity,
                  // height: kToolbarHeight + topPadding + kMainPadding,
                  // decoration: BoxDecoration(
                  //   boxShadow: KboxBlurredShadowsArray,
                  //   color: TomatoColors.White,
                  // ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.directional(
                        textDirection: AppUtility.getTextDirectionality(),
                        start: 0,
                        bottom: 0,
                        child: containsBackButton
                            ? InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: onBackTapped ??
                                    () => UIRouter.popScreen(
                                        context:
                                            context) /*  Navigator.of(context).pop() */,
                                child: Container(
                                  padding: const EdgeInsetsDirectional.only(
                                    start: kMainPadding,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SvgPicture.asset(
                                        AppUtility.getArrowAssetLocalized(),

                                        // "assets/vectors/ArrowLeft.svg",
                                        height: 22,
                                        color: AppColors.grey400,
                                      ),
                                      const SizedBox(
                                        width: kMainPadding,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ),
                      if (screenName != null)
                        Positioned(
                          left: 70,
                          right: 70,
                          bottom: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    boxShadow: KboxBlurredShadowsArray),
                                child: Text(
                                  //  AutoSizeText(
                                  AppUtility.capitalizeAllWord(screenName!),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  // maxFontSize: 16,
                                  // minFontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.InterGrey800S16W600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (actions != null)
                        Positioned.directional(
                            textDirection: AppUtility.getTextDirectionality(),
                            end: 0,
                            bottom: 0,
                            child: SizedBox(
                              width: 70,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: actions!,
                              ),
                            ))
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: kBottomPadding,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(screenName == null ? 0 : kToolbarHeight);
}

class TomatoTransparentAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  // final String screenName;
  final void Function()? onBackTapped;

  const TomatoTransparentAppBar({
    Key? key,
    // required this.screenName,
    this.onBackTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
        leading: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => UIRouter.popScreen() /* Navigator.of(context).pop() */,
          child: Container(
            padding: const EdgeInsetsDirectional.only(
              start: kMainPadding,
            ),
            child: Row(
              children: [
                ClipOval(
                  child: Container(
                    height: 27,
                    width: 27,
                    padding: EdgeInsets.all(kInternalPadding),
                    color: Color.fromRGBO(187, 190, 196, 0.3),
                    child: SizedBox(
                      height: 15,
                      width: 15,
                      child: SvgPicture.asset(
                        AppUtility.getArrowAssetLocalized(),

                        // "assets/vectors/ArrowLeft.svg",
                        height: 15,
                        width: 15,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: kMainPadding,
                )
              ],
            ),
          ),
        )
        // actions: model.barItems.length > 1
        //     ? [
        //         Padding(
        //           padding: const EdgeInsets.only(right: 16.0),
        //           child: Consumer<BarItemsScreenVM>(
        //             builder: (context, value, child) => AnimatedChipContainer(
        //               currentIndex: value.currentIndex,
        //               itemsCount: model.barItems.length,
        //             ),
        //           ),
        //         ),
        //       ]
        //     : [],
        );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class TomatoRoundenBorderAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const TomatoRoundenBorderAppbar({
    this.onExitCallBack,
    required this.screenName,
    this.isCloseIncluded = false,
    super.key,
  });
  final bool isCloseIncluded;
  final String screenName;

  final VoidCallback? onExitCallBack;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: KboxBlurredShadowsArray,
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: kMainPadding),
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  children: [
                    if (isCloseIncluded) ...[
                      const Padding(
                        padding: EdgeInsets.all(kHelpingPadding),
                        child: Icon(
                          Icons.close,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(
                        width: kMainPadding,
                      ),
                    ],
                    Expanded(
                      child: Text(
                        screenName,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.InterGrey800S16W600,
                      ),
                    ),
                    if (isCloseIncluded) ...[
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: onExitCallBack,
                        child: Container(
                          padding: const EdgeInsetsDirectional.only(
                            start: kMainPadding,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(kHelpingPadding),
                            child: Icon(
                              Icons.close,
                              color: AppColors.grey400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: kBottomPadding,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
