// ignore: must_be_immutable
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/widgets/AppBottomDrawerHeight.dart';

// ignore: must_be_immutable
class DatePickerBottomDrawer extends StatelessWidget {
  DatePickerBottomDrawer({
    super.key,
    required this.drawerTile,
    required this.saveFunction,
    this.initialValue,
    this.firstDate,
    this.lastDate,
  });

  final String drawerTile;
  final void Function(DateTime) saveFunction;
  final DateTime? firstDate;
  final DateTime? lastDate;
  DateTime? initialValue;

  late DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    selectedDate = initialValue != null
        ? DateUtils.dateOnly(initialValue!)
        : DateUtils.dateOnly(DateTime.now());
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary700,
          onPrimary: AppColors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyles.InterGrey700S16W400,
          bodySmall: TextStyles.InterGrey700S16W400,
          titleSmall: TextStyles.InterGrey700S18W600,
        ),
      ),
      child: Builder(builder: (context) {
        return ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            const SizedBox(height: kBottomPadding),
            AppBottomDrawerHeader(
              title: drawerTile,
              saveFunction: () {
                saveFunction(
                    selectedDate.toUtc().add(selectedDate.timeZoneOffset));
                UIRouter.popScreen(context: context);
              },
            ),
            const SizedBox(height: kBottomPadding),
            CalendarDatePicker(
              initialDate: selectedDate,
              firstDate: firstDate ?? DateTime(1900),
              lastDate: lastDate ?? DateTime(2100),
              onDateChanged: (value) => selectedDate = value,
            )
          ],
        );
      }),
    );
  }
}

class SecondsMinutesTimer extends StatefulWidget {
  const SecondsMinutesTimer(
      {required this.initialValue,
      required this.callbackFunction,
      required this.title,
      Key? key})
      : super(key: key);
  final Function(int) callbackFunction;
  final String title;
  final int initialValue;

  @override
  State<SecondsMinutesTimer> createState() => SecondsMinutesTimerState();
}

class SecondsMinutesTimerState extends State<SecondsMinutesTimer> {
  late int _selectedSeconds;
  late int _selectedMinute;

  @override
  void initState() {
    super.initState();
    _selectedSeconds = widget.initialValue % 60;
    _selectedMinute = (widget.initialValue % 3600) ~/ 60;
  }

  double factorToMultiplyBy =
      (AppUtility.isDirectionalitionalityLTR() ? -1 : 1);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        const SizedBox(height: kBottomPadding),
        AppBottomDrawerHeader(
          title: widget.title,
          saveFunction: () {
            var secondsValue = ((_selectedSeconds) + (_selectedMinute * 60));
            widget.callbackFunction(secondsValue);
            Navigator.pop(context, secondsValue);
          },
        ),
        const SizedBox(height: kBottomPadding),
        Container(
          padding: const EdgeInsets.symmetric(vertical: kMainPadding),
          height: 216.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    CupertinoPicker(
                      diameterRatio: 3,
                      scrollController: FixedExtentScrollController(
                        initialItem: _selectedMinute,
                      ),
                      selectionOverlay: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                width: 0.5, color: AppColors.grey300),
                            bottom: BorderSide(
                                width: 0.5, color: AppColors.grey300),
                          ),
                        ),
                      ),
                      itemExtent: 42.0,
                      onSelectedItemChanged: (int index) {
                        setState(
                          () {
                            _selectedMinute = index;
                          },
                        );
                      },
                      children: List<Widget>.generate(
                        60,
                        (int index) {
                          return Transform.translate(
                            offset: Offset(30 * factorToMultiplyBy, 5),
                            child: Text(
                              '$index ',
                              style: _selectedMinute == index
                                  ? TextStyles.InterYellow700S20W600
                                  : TextStyles.InterGrey400S18W400,
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 15.0),
                      child: Text(
                        AppLocale.minutesShortcut
                            .getString(context)
                            .toLowerCase(),
                        style: TextStyles.InterYellow700S20W600,
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    CupertinoPicker(
                      diameterRatio: 3,
                      scrollController: FixedExtentScrollController(
                        initialItem: _selectedSeconds,
                      ),
                      selectionOverlay: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                width: 0.5, color: AppColors.grey300),
                            bottom: BorderSide(
                                width: 0.5, color: AppColors.grey300),
                          ),
                        ),
                      ),
                      itemExtent: 42.0,
                      onSelectedItemChanged: (int index) {
                        setState(
                          () {
                            _selectedSeconds = index;
                          },
                        );
                      },
                      children: List<Widget>.generate(
                        60,
                        (int index) {
                          return Transform.translate(
                            offset: Offset(40 * factorToMultiplyBy, 5),
                            child: Text(
                              '$index ',
                              style: _selectedSeconds == index
                                  ? TextStyles.InterYellow700S20W600
                                  : TextStyles.InterGrey400S18W400,
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 10.0),
                      child: Text(
                        AppLocale.secondShortcut
                            .getString(context)
                            .capitalizeFirstLetter(),
                        style: TextStyles.InterYellow700S20W600,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AmPmDayTimePicker extends StatefulWidget {
  const AmPmDayTimePicker(
      {required this.initialValue,
      required this.callbackFunction,
      required this.title,
      this.isUTCSameAsLocalTime = true,
      super.key});
  final Function(int utcValue, int localValue) callbackFunction;
  final String title;
  final bool isUTCSameAsLocalTime;

  /// In seconds
  final int initialValue;

  @override
  State<AmPmDayTimePicker> createState() => AmPmDayTimePickerState();
}

enum DayTimeTypeEnum {
  Am,
  Pm,
}

class AmPmDayTimePickerState extends State<AmPmDayTimePicker> {
  late DayTimeTypeEnum _dayTimeType;
  late int _selectedMinute;
  late int _selectedHour;
  double factorToMultiplyBy =
      (AppUtility.isDirectionalitionalityLTR() ? -1 : 1);

  @override
  void initState() {
    super.initState();

    _selectedMinute = (widget.initialValue % 3600) ~/ 60;
    _selectedHour = widget.initialValue ~/ 3600;
    _dayTimeType =
        _selectedHour >= 12 ? DayTimeTypeEnum.Pm : DayTimeTypeEnum.Am;
    _selectedHour = _selectedHour > 12 ? _selectedHour - 12 : _selectedHour;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        const SizedBox(height: kBottomPadding),
        AppBottomDrawerHeader(
          title: widget.title,
          saveFunction: () {
            DateTime newDuration = DateTime(
              0,
              0,
              0,
              (_selectedHour == 12 ? 0 : _selectedHour) +
                  (_dayTimeType == DayTimeTypeEnum.Pm ? 12 : 0),
              _selectedMinute,
            );

            DateTime utcTime = DateTime.utc(
                0,
                0,
                0,
                (_selectedHour == 12 ? 0 : _selectedHour) +
                    (_dayTimeType == DayTimeTypeEnum.Pm ? 12 : 0),
                _selectedMinute,
                widget.isUTCSameAsLocalTime
                    ? 0
                    : -DateTime.now().timeZoneOffset.inSeconds);

            var utcSecondsValue = (utcTime.minute * 60) + (utcTime.hour * 3600);

            var localSecondsValue = widget.isUTCSameAsLocalTime
                ? utcSecondsValue
                : (newDuration.minute * 60) + (newDuration.hour * 3600);

            widget.callbackFunction(utcSecondsValue, localSecondsValue);
            Navigator.pop(context, localSecondsValue);
          },
        ),
        const SizedBox(height: kBottomPadding),
        Container(
          padding: const EdgeInsets.symmetric(vertical: kMainPadding),
          height: 216.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: CupertinoPicker(
                    looping: true,
                    diameterRatio: 10,
                    scrollController: FixedExtentScrollController(
                      initialItem: _selectedHour,
                    ),
                    selectionOverlay: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 0.5, color: AppColors.grey300),
                          bottom:
                              BorderSide(width: 0.5, color: AppColors.grey300),
                        ),
                      ),
                    ),
                    itemExtent: 40.0,
                    onSelectedItemChanged: (int index) {
                      setState(
                        () {
                          _selectedHour = index;
                        },
                      );
                    },
                    children: List<Widget>.generate(12, (int index) {
                      return Transform.translate(
                        offset: const Offset(30, 5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kHelpingPadding),
                          child: Text(
                            '${index == 0 ? 12 : index} ',
                            style: _selectedHour == index ||
                                    (index == 0 && _selectedHour == 12)
                                ? TextStyles.InterYellow700S20W600
                                : TextStyles.InterGrey400S18W400,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      );
                    })),
              ),
              Flexible(
                child: CupertinoPicker(
                  looping: true,
                  diameterRatio: 3,
                  scrollController: FixedExtentScrollController(
                    initialItem: _selectedMinute,
                  ),
                  selectionOverlay: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 0.5, color: AppColors.grey300),
                        bottom:
                            BorderSide(width: 0.5, color: AppColors.grey300),
                      ),
                    ),
                  ),
                  itemExtent: 40.0,
                  onSelectedItemChanged: (int index) {
                    setState(
                      () {
                        _selectedMinute = index;
                      },
                    );
                  },
                  children: List<Widget>.generate(
                    60,
                    (int index) {
                      return Transform.translate(
                        offset: const Offset(0, 5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kHelpingPadding),
                          child: Text(
                            '$index ',
                            style: _selectedMinute == index
                                ? TextStyles.InterYellow700S20W600
                                : TextStyles.InterGrey400S18W400,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Flexible(
                child: CupertinoPicker(
                    diameterRatio: 1,
                    scrollController: FixedExtentScrollController(
                      initialItem: _dayTimeType == DayTimeTypeEnum.Pm ? 0 : 1,
                    ),
                    selectionOverlay: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 0.5, color: AppColors.grey300),
                          bottom:
                              BorderSide(width: 0.5, color: AppColors.grey300),
                        ),
                      ),
                    ),
                    itemExtent: 40.0,
                    onSelectedItemChanged: (int index) {
                      setState(
                        () {
                          _dayTimeType = index == 0
                              ? DayTimeTypeEnum.Pm
                              : DayTimeTypeEnum.Am;
                        },
                      );
                    },
                    children: [
                      Transform.translate(
                        offset: const Offset(-30, 5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kHelpingPadding),
                          child: Text(
                            AppLocale.pm.getString(context).toUpperCase(),
                            style: _dayTimeType == DayTimeTypeEnum.Pm
                                ? TextStyles.InterYellow700S20W600
                                : TextStyles.InterGrey400S18W400,
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(-30, 5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kHelpingPadding),
                          child: Text(
                            AppLocale.am.getString(context).toUpperCase(),
                            style: _dayTimeType == DayTimeTypeEnum.Am
                                ? TextStyles.InterYellow700S20W600
                                : TextStyles.InterGrey400S18W400,
                          ),
                        ),
                      )
                    ]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class twentyFourTimePicker extends StatefulWidget {
  const twentyFourTimePicker(
      {required this.initialValue,
      required this.callbackFunction,
      required this.title,
      this.isUTCSameAsLocalTime = true,
      super.key});
  final Function(int utcValue, int localValue) callbackFunction;
  final String title;
  final bool isUTCSameAsLocalTime;
  final int initialValue;

  @override
  State<twentyFourTimePicker> createState() => twentyFourTimePickerState();
}

class twentyFourTimePickerState extends State<twentyFourTimePicker> {
  late int _selectedMinute;
  late int _selectedHour;

  @override
  void initState() {
    super.initState();
    _selectedMinute = (widget.initialValue % 3600) ~/ 60;
    _selectedHour = widget.initialValue ~/ 3600;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        const SizedBox(height: kBottomPadding),
        AppBottomDrawerHeader(
          title: widget.title,
          saveFunction: () {
            DateTime newDuration = DateTime(
              0,
              0,
              0,
              _selectedHour,
              _selectedMinute,
            );

            var utcTime = DateTime.utc(
                0,
                0,
                0,
                _selectedHour,
                _selectedMinute,
                widget.isUTCSameAsLocalTime
                    ? 0
                    : -DateTime.now().timeZoneOffset.inSeconds);

            var utcSecondsValue = (utcTime.minute * 60) + (utcTime.hour * 3600);

            var localSecondsValue = widget.isUTCSameAsLocalTime
                ? utcSecondsValue
                : (newDuration.minute * 60) + (newDuration.hour * 3600);

            widget.callbackFunction(utcSecondsValue, localSecondsValue);
            Navigator.pop(context, localSecondsValue);
          },
        ),

        const SizedBox(height: kBottomPadding),
        Container(
          padding: const EdgeInsets.symmetric(vertical: kMainPadding),
          height: 216.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: CupertinoPicker(
                    looping: true,
                    diameterRatio: 10,
                    scrollController: FixedExtentScrollController(
                      initialItem: _selectedHour,
                    ),
                    selectionOverlay: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 0.5, color: AppColors.grey300),
                          bottom:
                              BorderSide(width: 0.5, color: AppColors.grey300),
                        ),
                      ),
                    ),
                    itemExtent: 40.0,
                    onSelectedItemChanged: (int index) {
                      setState(
                        () {
                          _selectedHour = index;
                        },
                      );
                    },
                    children: List<Widget>.generate(24, (int index) {
                      return Transform.translate(
                        offset: const Offset(30, 5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kHelpingPadding),
                          child: Text(
                            "${index.toString().padLeft(2, '0')} ",
                            // '${index == 0 ? 12 : index} ',
                            style: _selectedHour == index ||
                                    (index == 0 && _selectedHour == 12)
                                ? TextStyles.InterYellow700S20W600
                                : TextStyles.InterGrey400S18W400,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      );
                    })),
              ),
              Flexible(
                child: CupertinoPicker(
                  looping: true,
                  diameterRatio: 3,
                  scrollController: FixedExtentScrollController(
                    initialItem: _selectedMinute,
                  ),
                  selectionOverlay: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 0.5, color: AppColors.grey300),
                        bottom:
                            BorderSide(width: 0.5, color: AppColors.grey300),
                      ),
                    ),
                  ),
                  itemExtent: 40.0,
                  onSelectedItemChanged: (int index) {
                    setState(
                      () {
                        _selectedMinute = index;
                      },
                    );
                  },
                  children: List<Widget>.generate(
                    60,
                    (int index) {
                      return Transform.translate(
                        offset: const Offset(0, 5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kHelpingPadding),
                          child: Text(
                            "${index.toString().padLeft(2, '0')} ",
                            // '$index ',
                            style: _selectedMinute == index
                                ? TextStyles.InterYellow700S20W600
                                : TextStyles.InterGrey400S18W400,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        // InkWell(
        //   onTap: () {
        // Duration newDuration =
        //     Duration(minutes: _selectedMinute, hours: _selectedHour);
        // widget.callbackFunction(_selectedMinute + (_selectedHour * 60));
        // Navigator.pop(context, newDuration);
        //   },
        //   child:
        //   Container(
        //     decoration: BoxDecoration(
        //       color: TomatoColors.Green700,
        //       borderRadius: BorderRadius.circular(61),
        //     ),
        //     padding: EdgeInsets.symmetric(vertical: 15),
        //     child: Center(
        //       child: Text(
        //         'Save',
        //         style: TomatoTextStyles.InterWhiteS16W600H20,
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
