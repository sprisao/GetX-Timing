import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddScreen1 extends StatefulWidget {
  const AddScreen1({Key? key}) : super(key: key);

  @override
  State<AddScreen1> createState() => _AddScreen1State();
}

class _AddScreen1State extends State<AddScreen1> {
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
    return Column(
      children: [
        SfDateRangePicker(
          selectionMode: DateRangePickerSelectionMode.single,
          view: DateRangePickerView.month,
          monthViewSettings: const DateRangePickerMonthViewSettings(
            firstDayOfWeek: 1,
          ),
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            setState(() {
              _date = args.value;
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
