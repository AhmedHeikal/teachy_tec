import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget(
      {this.initialDate,
      this.enableMultiSelection = true,
      required this.onSelectDate,
      required this.onSelectDateRange,
      this.rangeStartDate,
      this.rangeEndDate,
      this.onChangeMultiDaySelectionCallback,
      super.key});
  final DateTime? initialDate;
  final DateTime? rangeStartDate;
  final DateTime? rangeEndDate;

  final Function(DateTime) onSelectDate;
  final Function(DateTime?, DateTime?) onSelectDateRange;
  final bool enableMultiSelection;
  final void Function(bool)? onChangeMultiDaySelectionCallback;
  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = AppUtility.removeTime(DateTime.now());
  DateTime? _selectedDay;
  DateTime? _rangeStartDate;
  DateTime? _rangeEndDate;
  bool isMultiSelectionActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.enableMultiSelection) {
      _onRangeSelected(
        widget.rangeStartDate ??
            AppUtility.removeTime(
                DateTime.now().subtract(const Duration(days: 4))),
        widget.rangeEndDate ?? AppUtility.removeTime(DateTime.now()),
        AppUtility.removeTime(
          DateTime.now().subtract(
            const Duration(days: 4),
          ),
        ),
      );
    }
  }

  void toggleMultiSelection() {
    setState(
      () {
        isMultiSelectionActive = !isMultiSelectionActive;
        if (widget.onChangeMultiDaySelectionCallback != null) {
          widget.onChangeMultiDaySelectionCallback!(isMultiSelectionActive);
        }
        if (isMultiSelectionActive) {
          _onRangeSelected(
            _selectedDay != null
                ? _selectedDay!.subtract(const Duration(days: 4))
                : DateTime.now().toUtc().subtract(const Duration(days: 4)),
            _selectedDay ?? DateTime.now().toUtc(),
            _selectedDay != null
                ? _selectedDay!.subtract(const Duration(days: 4))
                : DateTime.now().toUtc().subtract(const Duration(days: 4)),
          );
        } else {
          _selectedDay = DateTime.now().toUtc();
          _focusedDay = _selectedDay!;
          widget.onSelectDate(_selectedDay ?? _focusedDay);
          // _focusedDay = _selectedDay ?? _focusedDay;
        }
      },
    );
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = AppUtility.removeTime(focusedDay);
      _rangeStartDate = start != null ? AppUtility.removeTime(start) : null;
      _rangeEndDate = end != null ? AppUtility.removeTime(end) : null;
      widget.onSelectDateRange(_rangeStartDate, _rangeEndDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: kFirstDay,
          locale:
              serviceLocator<FlutterLocalization>().currentLocale!.languageCode,
          rangeStartDay: widget.enableMultiSelection && isMultiSelectionActive
              ? _rangeStartDate
              : _selectedDay,
          rangeEndDay: widget.enableMultiSelection && isMultiSelectionActive
              ? _rangeEndDate
              : null,
          rangeSelectionMode:
              widget.enableMultiSelection && isMultiSelectionActive
                  ? RangeSelectionMode.toggledOn
                  : RangeSelectionMode.toggledOff,
          lastDay: kLastDay,
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          availableCalendarFormats: {
            CalendarFormat.month:
                AppLocale.month.getString(context).capitalizeAllWord(),
            CalendarFormat.week:
                AppLocale.week.getString(context).capitalizeAllWord(),
          },
          onRangeSelected: _onRangeSelected,
          calendarBuilders: CalendarBuilders(
            disabledBuilder: (context, day, focusedDay) {
              return DottedBorder(
                color: AppColors.white,
                borderType: BorderType.Circle,
                dashPattern: const <double>[6, 4],
                strokeWidth: 2,
                child: Padding(
                  padding: const EdgeInsets.all(kBottomPadding),
                  child: Text(
                    day.day.toString(),
                    style: const TextStyle(
                      color: AppColors.grey200,
                    ),
                  ),
                ),
              );
            },
            outsideBuilder: (context, day, focusedDay) {
              return DottedBorder(
                color: AppColors.white,
                borderType: BorderType.Circle,
                dashPattern: const <double>[6, 4],
                strokeWidth: 2,
                child: Container(
                  margin: const EdgeInsets.only(top: kInternalPadding),
                  padding: const EdgeInsets.all(kBottomPadding),
                  child: Text(
                    day.day.toString(),
                    style: const TextStyle(color: AppColors.grey200),
                  ),
                ),
              );
            },
            rangeStartBuilder: (context, day, focusedDay) {
              return Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary300,
                ),
                child: Container(
                  padding: const EdgeInsets.all(kBottomPadding),
                  child: Text(
                    day.day.toString(),
                    style: const TextStyle(
                      color: AppColors.black,
                    ),
                  ),
                ),
              );
            },
            rangeEndBuilder: (context, day, focusedDay) {
              return Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary300,
                ),
                child: Container(
                  padding: const EdgeInsets.all(kBottomPadding),
                  child: Text(
                    day.day.toString(),
                    style: const TextStyle(
                      color: AppColors.black,
                    ),
                  ),
                ),
              );
            },
            rangeHighlightBuilder: (context, date, isInRange) {
              if (!isMultiSelectionActive || !widget.enableMultiSelection) {
                return null;
              }
              var currentDate = AppUtility.removeTime(date);
              if (_rangeStartDate != null && _rangeEndDate != null) {
                if (currentDate.isAtSameMomentAs(_rangeStartDate!)) {
                  return Container(
                    margin: const EdgeInsets.only(top: kHelpingPadding),
                    decoration: const BoxDecoration(
                      color: AppColors.primary300,
                      borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(50),
                        bottomStart: Radius.circular(50),
                      ),
                    ),
                  );
                } else if (currentDate.isAtSameMomentAs(_rangeEndDate!)) {
                  return Container(
                    margin: const EdgeInsets.only(top: kHelpingPadding),
                    decoration: const BoxDecoration(
                      color: AppColors.primary300,
                      borderRadius: BorderRadiusDirectional.only(
                        topEnd: Radius.circular(50),
                        bottomEnd: Radius.circular(50),
                      ),
                    ),
                  );
                } else if (currentDate.isAfter(_rangeStartDate!) &&
                    currentDate.isBefore(_rangeEndDate!)) {
                  return Container(
                    margin: const EdgeInsets.only(top: kHelpingPadding),
                    decoration: const BoxDecoration(
                      color: AppColors.primary300,
                    ),
                  );
                }
              }
              return null;
            },
            defaultBuilder: (context, day, focusedDay) {
              return Container(
                margin: const EdgeInsets.only(top: kInternalPadding),
                child: DottedBorder(
                  color: AppColors.white,
                  borderType: BorderType.Circle,
                  dashPattern: const <double>[6, 4],
                  strokeWidth: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(kBottomPadding),
                    child: Text(
                      day.day.toString(),
                      style: const TextStyle(color: AppColors.black),
                    ),
                  ),
                ),
              );
            },
            selectedBuilder: (context, day, focusedDay) {
              return Container(
                // margin: const EdgeInsets.only(bottom: 2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary300,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(kBottomPadding),
                  child: Text(
                    day.day.toString(),
                    style: const TextStyle(color: AppColors.black),
                  ),
                ),
              );
            },
            todayBuilder: (context, day, focusedDay) {
              return Container(
                margin: const EdgeInsets.only(bottom: 2),
                child: DottedBorder(
                  color: AppColors.primary700,
                  borderType: BorderType.Circle,
                  dashPattern: const <double>[6, 4],
                  strokeWidth: 2,
                  child: Container(
                    padding: const EdgeInsets.all(kHelpingPadding),
                    child: Text(
                      day.day.toString(),
                      style: const TextStyle(color: AppColors.black),
                    ),
                  ),
                ),
              );
            },
            withinRangeBuilder: (context, day, focusedDay) {
              return Container(
                margin: const EdgeInsets.only(bottom: 2),
                child: DottedBorder(
                  color: Colors.transparent,
                  borderType: BorderType.Circle,
                  dashPattern: const <double>[6, 4],
                  strokeWidth: 2,
                  child: Container(
                    padding: const EdgeInsets.all(kHelpingPadding),
                    child: Text(
                      day.day.toString(),
                      style: const TextStyle(color: AppColors.black),
                    ),
                  ),
                ),
              );
            },
          ),
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            widget.onSelectDate(focusedDay);
            if (!isSameDay(_selectedDay, selectedDay)) {
              // Call `setState()` when updating the selected day
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            }
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              // Call `setState()` when updating calendar format
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            // No need to call `setState()` here
            _focusedDay = focusedDay;
          },
        ),
        if (widget.enableMultiSelection)
          Container(
            margin: const EdgeInsets.fromLTRB(
              kMainPadding,
              kBottomPadding,
              kMainPadding,
              0,
            ),
            child: InkWell(
              onTap: toggleMultiSelection,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocale.selectMultiDay
                          .getString(context)
                          .capitalizeAllWord(),
                      style: TextStyles.InterGrey900S16W500,
                    ),
                  ),
                  SvgPicture.asset(
                    isMultiSelectionActive
                        ? 'assets/svg/switchOn.svg'
                        : 'assets/svg/switchOff.svg',
                    width: 36,
                    height: 19.5,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
