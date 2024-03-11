// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/widgets/TransparentPointer.dart';

showSpecificNotificaiton(
    {required AppNotifcation Function(BuildContext) notifcationDetails,
    BuildContext? context}) async {
  OverlayState? overlayState =
      Overlay.of(context ?? UIRouter.getCurrentContext());
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(builder: (BuildContext context) {
    return TransparentPointer(
      child: Dismissible(
        key: const Key('overlay'),
        onDismissed: (direction) {
          overlayEntry.remove();
        },
        child: _AppNotification(
          notifcationDetails: notifcationDetails(context),
        ),
      ),
    );
  });

  // ignore: unnecessary_null_comparison
  if (overlayState != null) {
    overlayState.insert(overlayEntry);
    await Future.delayed(const Duration(seconds: 3));
    if (overlayEntry.mounted) overlayEntry.remove();
  }
}

showErrorNotification(
    {required String errorText,
    String? stackTrace,
    BuildContext? context}) async {
  OverlayState? overlayState =
      Overlay.of(context ?? UIRouter.getCurrentContext());
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(builder: (BuildContext context) {
    return TransparentPointer(
      child: Dismissible(
        key: const Key('overlay'),
        onDismissed: (direction) {
          overlayEntry.remove();
        },
        child: _AppDebugingNotification(
          errorText: errorText,
          stackTrace: stackTrace ?? "",
        ),
      ),
    );
  });

  // ignore: unnecessary_null_comparison
  if (overlayState != null) {
    overlayState.insert(overlayEntry);
    await Future.delayed(const Duration(seconds: 10));
    if (overlayEntry.mounted) overlayEntry.remove();
  }
}

class _AppNotification extends StatefulWidget {
  const _AppNotification({
    required this.notifcationDetails,
  });
  final AppNotifcation notifcationDetails;
  @override
  State<StatefulWidget> createState() => _AppNotificationState();
}

class _AppNotificationState extends State<_AppNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> position;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));
    position = Tween<Offset>(begin: const Offset(0.0, -4.0), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: controller, curve: Curves.bounceInOut));

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 32.0),
          child: SlideTransition(
            position: position,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: kMainPadding),
              decoration: BoxDecoration(
                color: widget.notifcationDetails.color.colorValue,
                border: Border.all(
                    color: widget.notifcationDetails.color ==
                            NotificationColors.Successful
                        ? AppColors.primary300
                        : widget.notifcationDetails.color ==
                                NotificationColors.Requirement
                            ? AppColors.grey200
                            : AppColors.red300),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey400.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 12,
                    offset: const Offset(3, 7), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      widget.notifcationDetails.icon.iconPath,
                      // "assets/vectors/warning.svg",
                      // height: 28,
                    ),
                    const SizedBox(width: kHelpingPadding),
                    Expanded(
                      child: Text(
                        widget.notifcationDetails.text,
                        style: TextStyles.InterBlackS14W400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppDebugingNotification extends StatefulWidget {
  const _AppDebugingNotification({
    required this.errorText,
    required this.stackTrace,
    // required this.parametersText,
  });
  final String errorText;
  final String stackTrace;

  @override
  State<StatefulWidget> createState() => _AppDebugingNotificationState();
}

class _AppDebugingNotificationState extends State<_AppDebugingNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> position;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));
    position = Tween<Offset>(begin: const Offset(0.0, -4.0), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: controller, curve: Curves.bounceInOut));

    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 32.0),
          child: SlideTransition(
            position: position,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: kMainPadding),
              decoration: BoxDecoration(
                color: AppColors.red50,
                border: Border.all(color: AppColors.red300),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey400.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 12,
                    offset: const Offset(3, 7),
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/warning.svg",
                          height: 24,
                        ),
                        const SizedBox(width: kHelpingPadding),
                        Expanded(
                          child: Text(
                            widget.errorText,
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.InterBlackS12W400,
                          ),
                        ),
                      ],
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: kBottomPadding),
                        width: double.infinity,
                        height: 1,
                        color: AppColors.grey100),
                    InkWell(
                      onTap: () async {
                        await Clipboard.setData(
                          ClipboardData(
                            text: widget.errorText,
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/copy.svg',
                            height: 24,
                            color: AppColors.red600,
                          ),
                          const SizedBox(width: kHelpingPadding),
                          const Text(
                            'Error',
                            // "Duplicate",
                            style: TextStyles.InterBlackS16W400,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: kHelpingPadding),
                    if (widget.stackTrace.trim().isNotEmpty) ...[
                      InkWell(
                        onTap: () async {
                          await Clipboard.setData(
                            ClipboardData(
                              text: widget.stackTrace,
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/svg/copy.svg',
                              height: 24,
                              color: AppColors.red600,
                            ),
                            const SizedBox(width: kHelpingPadding),
                            const Text(
                              'stackTrace',
                              // "Duplicate",
                              style: TextStyles.InterBlackS16W400,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: kHelpingPadding,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppNotifcation {
  final String text;
  final NotificationIcons icon;
  final NotificationColors color;
  const AppNotifcation({
    required this.text,
    required this.icon,
    required this.color,
  });
}

class AppNotifcationsItems {
  BuildContext context;
  AppNotifcationsItems(this.context);
  /*  */

  static AppNotifcation customQuestionOptionDuplicated(BuildContext context) =>
      AppNotifcation(
        text: AppLocale.answerShouldBeDifferent
            .getString(context)
            .capitalizeFirstLetter(),
        icon: NotificationIcons.Require,
        color: NotificationColors.Requirement,
      );

  static AppNotifcation CustomQuestionOptionsNotComplete(
          BuildContext context) =>
      AppNotifcation(
        text: AppLocale.twoOptionsAtLeastNotification
            .getString(context)
            .capitalizeFirstLetter(),

        // text: 'Should be two options at least',
        icon: NotificationIcons.Require,
        color: NotificationColors.Requirement,
      );
  static AppNotifcation CustomQuestionOptionDuplicated(BuildContext context) =>
      AppNotifcation(
        text: AppLocale.answerShouldBeDifferent
            .getString(context)
            .capitalizeFirstLetter(),

        // text: 'Should be two options at least',
        icon: NotificationIcons.Require,
        color: NotificationColors.Requirement,
      );

  static AppNotifcation CustomQuestionNoCorrectOption(BuildContext context) =>
      AppNotifcation(
        text: AppLocale.shouldBeAtleasetOneCorrect
            .getString(context)
            .capitalizeFirstLetter(),

        // text: 'Should be atleast one option correct',
        icon: NotificationIcons.Require,
        color: NotificationColors.Requirement,
      );

  static AppNotifcation CustomQuestionNoIncorrectOption(BuildContext context) =>
      AppNotifcation(
        text: AppLocale.shouldBeAtleastOneIncorrect
            .getString(context)
            .capitalizeFirstLetter(),

        // text: 'Should be atleast one option incorrect',
        icon: NotificationIcons.Require,
        color: NotificationColors.Requirement,
      );
  static AppNotifcation activityDeletedSuccessfully(BuildContext context) =>
      AppNotifcation(
        text: AppLocale.activityDeletedSuccessfully
            .getString(context)
            .capitalizeFirstLetter(),
        icon: NotificationIcons.Delete,
        color: NotificationColors.Warning,
      );

  static AppNotifcation mediaChosenAlready(BuildContext context) =>
      AppNotifcation(
        text: AppLocale.choseThisItemBefore
            .getString(context)
            .capitalizeFirstLetter(),
        icon: NotificationIcons.Require,
        color: NotificationColors.Requirement,
      );

  static AppNotifcation unsupportedMedia(BuildContext context) =>
      AppNotifcation(
        text: AppLocale.youChoseUnsupportedElement
            .getString(context)
            .capitalizeFirstLetter(),
        icon: NotificationIcons.Require,
        color: NotificationColors.Requirement,
      );
  static AppNotifcation studentNamesDuplicated(BuildContext context) =>
      AppNotifcation(
        text: AppLocale.studentNamesDuplicated
            .getString(context)
            .capitalizeFirstLetter(),
        icon: NotificationIcons.Warning,
        color: NotificationColors.Warning,
      );

  static AppNotifcation didntFindNamesColumn(BuildContext context) =>
      AppNotifcation(
        text: AppLocale.didntFindNamesColumn
            .getString(context)
            .capitalizeFirstLetter(),
        icon: NotificationIcons.Require,
        color: NotificationColors.Requirement,
      );
  static AppNotifcation fileSizeExceeded(BuildContext context) =>
      AppNotifcation(
        text: AppLocale.fileSizeWasExceeded
            .getString(context)
            .capitalizeFirstLetter(),
        icon: NotificationIcons.Require,
        color: NotificationColors.Requirement,
      );

  static AppNotifcation Function(BuildContext context) itemsExceeded(
    int maxItemsCount,
  ) =>
      (BuildContext context) => AppNotifcation(
            text:
                "${AppLocale.chooseMoreThanNotification_nput_P1.getString(context).capitalizeFirstLetter()} $maxItemsCount ${AppLocale.chooseMoreThanNoification_Input_P2.getString(context).toLowerCase()}",
            icon: NotificationIcons.Require,
            color: NotificationColors.Requirement,
          );
  static AppNotifcation Function(BuildContext) duplicateValuesInAvailability(
          int removedStudents) =>
      (BuildContext context) => AppNotifcation(
            text:
                "${AppLocale.studentsRemovedForDuplicationPart1.getString(context).capitalizeFirstLetter()} $removedStudents ${AppLocale.studentsRemovedForDuplicationPart2.getString(context).capitalizeFirstLetter()}",
            icon: NotificationIcons.Warning,
            color: NotificationColors.Warning,
          );
}

enum NotificationColors {
  Successful(colorValue: AppColors.primary50),
  Requirement(colorValue: AppColors.grey50),
  Warning(colorValue: AppColors.red50);

  final Color colorValue;
  const NotificationColors({required this.colorValue});
}

enum NotificationIcons {
  Successful(iconPath: 'assets/notifications/Check.svg'),
  Delete(iconPath: 'assets/notifications/Bin.svg'),
  Pin(iconPath: 'assets/notifications/Pin.svg'),
  Unpin(iconPath: 'assets/notifications/Unpin.svg'),
  Archive(iconPath: 'assets/notifications/Archive.svg'),
  Saved(iconPath: 'assets/notifications/Save to.svg'),
  Clipboard(iconPath: 'assets/notifications/Copy.svg'),
  Shift(iconPath: 'assets/notifications/Shift.svg'),
  Clock(iconPath: 'assets/notifications/Time.svg'),
  ShiftRed(iconPath: 'assets/notifications/ShiftRed.svg'),
  Require(iconPath: 'assets/notifications/Warning.svg'),
  Warning(iconPath: 'assets/notifications/Forbidden.svg'),
  Wifi(iconPath: 'assets/notifications/Connection.svg');

  final String iconPath;
  const NotificationIcons({required this.iconPath});
}
