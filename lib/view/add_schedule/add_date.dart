import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:timing/models/schedule_model.dart';

class AddScreen1 extends StatefulWidget {
  final Function(CreateScheduleModel) onUpdate;
  final CreateScheduleModel schedule;

  const AddScreen1({Key? key, required this.onUpdate, required this.schedule})
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
    widget.onUpdate(CreateScheduleModel(date: _selectedDate,
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
          initialSelectedDate: _selectedDate,
          view: DateRangePickerView.month,
          monthViewSettings: const DateRangePickerMonthViewSettings(
            firstDayOfWeek: 1,
          ),
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            setState(() {
              _date = args.value;
              _updateDate(_date!);
            });
          },
          minDate: _firstDateOfCurrentMonth(),
          maxDate: _lastDateOfCurrentMonth(),
          selectableDayPredicate: _selectableDayPredicate,
        ),
        Text('옆으로 스와이프 하세요 >>>')
        /*StartTime*/
      ],
    );
  }
}
