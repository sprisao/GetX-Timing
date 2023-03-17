import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../style/theme.dart';
import '../components/timing_filterchip.dart';

class AddScreen2 extends StatefulWidget {
  const AddScreen2({Key? key}) : super(key: key);

  @override
  State<AddScreen2> createState() => _AddScreen2State();
}

class _AddScreen2State extends State<AddScreen2> {
  DateTime? _startTime;
  DateTime? _endTime;

  final TextEditingController _startTimeTextField = TextEditingController();
  final TextEditingController _endTimeTextField = TextEditingController();

  bool _anytime = false;
  bool _startAnytime = false;
  bool _endAnytime = false;

  @override
  void initState() {
    super.initState();
    _startTimeTextField.text = "언제부터";
    _endTimeTextField.text = "언제까지";
  }

  @override
  Widget build(BuildContext context) {
    DateTime initialStartTime;
    if (_startTime != null) {
      int minutesPastInterval = _startTime!.minute.remainder(10);
      initialStartTime =
          _startTime!.subtract(Duration(minutes: minutesPastInterval));
    } else {
      /*show only*/
      DateTime now = DateTime.now();
      int minutesPastInterval = now.minute.remainder(10);
      initialStartTime = now.subtract(Duration(minutes: minutesPastInterval));
    }

    DateTime initialEndTime;

    if (_endTime != null) {
      int minutesPastInterval = _endTime!.minute.remainder(10);
      initialEndTime =
          _endTime!.subtract(Duration(minutes: minutesPastInterval));
    } else {
      initialEndTime = initialStartTime;
    }
    DateTime maximumDate;
    if (_endAnytime || _endTime == null) {
      maximumDate = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        23,
        59,
      );
    } else {
      maximumDate = DateTime(
        _endTime!.year,
        _endTime!.month,
        _endTime!.day,
        _endTime!.hour,
        _endTime!.minute,
      );
    }
    DateTime minimumDate;
    if (_startAnytime || _startTime == null) {
      minimumDate = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        0,
        0,
      );
    } else {
      minimumDate = DateTime(
        _startTime!.year,
        _startTime!.month,
        _startTime!.day,
        _startTime!.hour,
        _startTime!.minute,
      );
    }
    return Column(
      children: [
        Text('2023년 03월 23일 (수)'),
        Text('몇시부터 몇시까지?'),
        Wrap(
          spacing: 5,
          children: [
            CustomFilterChip(
              label: "아무때나",
              selected: _startAnytime && _endAnytime,
              onSelected: (bool selected) {
                HapticFeedback.lightImpact();
                setState(() {
                  if (!_anytime) {
                    _anytime = true;
                    _startAnytime = true;
                    _endAnytime = true;
                    _startTimeTextField.text = "아무때나";
                    _endTimeTextField.text = "아무때나";
                  } else {
                    _anytime = false;
                    _startAnytime = false;
                    _endAnytime = false;
                    if (_startTime == null) {
                      _startTimeTextField.text = "언제부터";
                    } else {
                      _startTimeTextField.text =
                          DateFormat('a h시 mm분', 'ko').format(_startTime!);
                    }
                    if (_endTime == null) {
                      _endTimeTextField.text = "언제까지";
                    } else {
                      _endTimeTextField.text =
                          DateFormat('a h시 mm분', 'ko').format(_endTime!);
                    }
                  }
                });
              },
            ),
            CustomFilterChip(
              label: "시작시간 미정",
              selected: _startAnytime,
              onSelected: (bool selected) {
                HapticFeedback.lightImpact();
                setState(() {
                  if (!_startAnytime) {
                    _startAnytime = true;
                    _startTimeTextField.text = "아무때나";
                  } else {
                    _startAnytime = false;
                    _anytime = false;
                    if (_startTime == null) {
                      _startTimeTextField.text = "언제부터";
                    } else {
                      _startTimeTextField.text =
                          DateFormat('a h시 mm분', 'ko').format(_startTime!);
                    }
                  }
                });
              },
            ),
            CustomFilterChip(
              label: "끝나는 시간 미정",
              selected: _endAnytime,
              onSelected: (bool selected) {
                HapticFeedback.lightImpact();
                setState(() {
                  if (!_endAnytime) {
                    _endAnytime = true;
                    _endTimeTextField.text = "아무때나";
                  } else {
                    _endAnytime = false;
                    if (_endTime == null) {
                      _endTimeTextField.text = "언제까지";
                    } else {
                      _endTimeTextField.text =
                          DateFormat('a h시 mm분', 'ko').format(_endTime!);
                    }
                  }
                });
              },
            ),
          ],
        ),
        TextField(
          readOnly: true,
          showCursor: false,
          controller: _startTimeTextField,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              color: ColorTheme.activeIcon,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorTheme.primary, width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            border: OutlineInputBorder(
              borderSide:
              BorderSide(color: ColorTheme.inactiveIcon, width: 0.1),
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
          ),
          onTap: () {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  decoration: const BoxDecoration(
                    color: ColorTheme.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  height: 200,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('취소',
                                  style: TextStyle(
                                      color: ColorTheme.black, fontSize: 18)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('확인',
                                  style: TextStyle(
                                      color: ColorTheme.black, fontSize: 18)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: CupertinoDatePicker(
                          maximumDate: maximumDate,
                          mode: CupertinoDatePickerMode.time,
                          use24hFormat: true,
                          minuteInterval: 10,
                          initialDateTime: initialStartTime,
                          onDateTimeChanged: (picked) {
                            setState(() {
                              _startAnytime = false;
                              _startTime = picked;
                              _startTimeTextField.text =
                                  DateFormat('a h시 mm분', 'ko').format(picked);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        TextField(
          readOnly: true,
          showCursor: false,
          controller: _endTimeTextField,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              color: ColorTheme.activeIcon,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorTheme.primary, width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            border: OutlineInputBorder(
              borderSide:
              BorderSide(color: ColorTheme.inactiveIcon, width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
          ),
          onTap: () {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: ColorTheme.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('취소',
                                style: TextStyle(
                                    color: ColorTheme.black, fontSize: 18)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('확인',
                                style: TextStyle(
                                    color: ColorTheme.black, fontSize: 18)),
                          ),
                        ],
                      ),
                      Expanded(
                        child: CupertinoDatePicker(
                          minimumDate: minimumDate,
                          mode: CupertinoDatePickerMode.time,
                          use24hFormat: true,
                          minuteInterval: 10,
                          initialDateTime: initialEndTime,
                          onDateTimeChanged: (picked) {
                            setState(() {
                              _endAnytime = false;
                              _endTime = picked;
                              _endTimeTextField.text =
                                  DateFormat('a h시 mm분', 'ko').format(picked);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
