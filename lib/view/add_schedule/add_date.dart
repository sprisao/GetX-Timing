import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:timing/models/schedule_model.dart';

import '../../style/theme.dart';

class AddScreen1 extends StatefulWidget {
  final Function(CreateScheduleModel) onUpdate;
  final CreateScheduleModel schedule;
  final Function(int page) goToPage;
  final int currentPage;
  final Function(bool selected) onDateSelected;
  final bool isDateSelected;

  const AddScreen1(
      {Key? key,
      required this.onUpdate,
      required this.schedule,
      required this.goToPage,
      required this.currentPage,
      required this.onDateSelected,
      required this.isDateSelected})
      : super(key: key);

  @override
  State<AddScreen1> createState() => _AddScreen1State();
}

class _AddScreen1State extends State<AddScreen1> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  void _updateDate(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
    widget.onUpdate(CreateScheduleModel(
        date: _selectedDate,
        startTime: widget.schedule.startTime,
        endTime: widget.schedule.endTime,
        locationList: widget.schedule.locationList,
        activityItemList: widget.schedule.activityItemList,
        privacy: widget.schedule.privacy));
  }

  DateTime? _date = DateTime.now();

  DateTime _firstDateOfCurrentMonth() {
    final now = DateTime.now();
    final daysToFirstDayOfWeek = now.weekday - DateTime.monday;
    return now.subtract(Duration(days: daysToFirstDayOfWeek));
  }

  DateTime _lastDateOfCurrentMonth() {
    final now = DateTime.now();
    final daysToLastDayOfWeek = DateTime.sunday - now.weekday;
    final lastDayOfCurrentWeek = now.add(Duration(days: daysToLastDayOfWeek));
    final lastDayOfNextWeek = lastDayOfCurrentWeek.add(const Duration(days: 7));
    return lastDayOfNextWeek;
  }

  bool _selectableDayPredicate(DateTime day) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    return day.isAfter(today) || day == today;
  }

  @override
  Widget build(BuildContext context) {

    _selectedDate = widget.schedule.date;
    return Column(
      children: [
        SfDateRangePicker(
          selectionMode: DateRangePickerSelectionMode.single,
          initialSelectedDate: widget.isDateSelected  ?_selectedDate: null,
          view: DateRangePickerView.month,
          monthViewSettings: const DateRangePickerMonthViewSettings(
            firstDayOfWeek: 1,
          ),
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            widget.onDateSelected(true);
            setState(() {
              _date = args.value;
              _updateDate(_date!);
            });
          },
          minDate: _firstDateOfCurrentMonth(),
          maxDate: _lastDateOfCurrentMonth(),
          selectableDayPredicate: _selectableDayPredicate,
        ),
        FilledButton(
          onPressed: widget.isDateSelected ? () {
            widget.goToPage(1);
          } : null,
          child: Text('다음'),
          style: widget.isDateSelected
              ? FilledButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: ColorTheme.primary,
          )
              : FilledButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}
