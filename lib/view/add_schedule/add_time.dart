import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:timing/models/schedule_model.dart';

import '../../style/theme.dart';
import '../components/timing_filterchip.dart';

class AddScreen2 extends StatefulWidget {
  final Function(CreateScheduleModel) onUpdate;
  final CreateScheduleModel schedule;
  final Function(int page) goToPage;
  final int currentPage;

  final Function(bool selected) onStartTimeSelected;
  final Function(bool selected) onEndTimeSelected;

  final bool isStartTimeSelected;
  final bool isEndTimeSelected;

  const AddScreen2(
      {Key? key,
      required this.onUpdate,
      required this.schedule,
      required this.goToPage,
      required this.currentPage,
      required this.onStartTimeSelected,
      required this.onEndTimeSelected,
      required this.isStartTimeSelected,
      required this.isEndTimeSelected})
      : super(key: key);

  @override
  State<AddScreen2> createState() => _AddScreen2State();
}

class _AddScreen2State extends State<AddScreen2> {
  late DateTime _startTime;
  late DateTime _endTime;

  final TextEditingController _startTimeTextField = TextEditingController();
  final TextEditingController _endTimeTextField = TextEditingController();

  bool _anytime = false;
  bool _startAnytime = false;
  bool _endAnytime = false;

  @override
  void initState() {
    super.initState();
    _startTime = widget.schedule.startTime;
    _endTime = widget.schedule.endTime;
    _startTimeTextField.text = "언제부터";
    _endTimeTextField.text = "언제까지";
  }

  void _updateTimes(DateTime newStartTime, DateTime newEndTime) {
    setState(() {
      _startTime = newStartTime;
      _endTime = newEndTime;
    });
    widget.onUpdate(CreateScheduleModel(
        date: widget.schedule.date,
        startTime: _startTime,
        endTime: _endTime,
        locationList: widget.schedule.locationList,
        activityItemList: widget.schedule.activityItemList,
        privacy: widget.schedule.privacy));
  }

  @override
  Widget build(BuildContext context) {
    _startTime = widget.schedule.startTime;
    _endTime = widget.schedule.endTime;

    DateTime initialStartTime;
    if (_startTime != null) {
      int minutesPastInterval = _startTime.minute.remainder(10);
      initialStartTime =
          _startTime.subtract(Duration(minutes: minutesPastInterval));
    } else {
      /*show only*/
      DateTime now = DateTime.now();
      int minutesPastInterval = now.minute.remainder(10);
      initialStartTime = now.subtract(Duration(minutes: minutesPastInterval));
    }

    DateTime initialEndTime;

    if (_endTime != null) {
      int minutesPastInterval = _endTime.minute.remainder(10);
      initialEndTime =
          _endTime.subtract(Duration(minutes: minutesPastInterval));
    } else {
      initialEndTime = initialStartTime;
    }

    DateTime maximumDate;

    if (_endAnytime) {
      maximumDate = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        23,
        59,
      );
    } else {
      maximumDate = DateTime(
        _endTime.year,
        _endTime.month,
        _endTime.day,
        _endTime.hour,
        _endTime.minute,
      );
    }
    DateTime minimumDate;
    minimumDate = DateTime.now();

    return Column(
      children: [
        /*2023년 m월 d일*/
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 5),
              child: Text(
                DateFormat('yyyy년 M월 d일 E요일', 'ko').format(widget.schedule.date),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Text('원하시는 시간대를 설정해주세요!'),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
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
                              borderSide:
                                  BorderSide(color: ColorTheme.primary, width: 0.5),
                              borderRadius: BorderRadius.all(Radius.circular(14)),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ColorTheme.inactiveIcon, width: 0.1),
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('취소',
                                                  style: TextStyle(
                                                      color: ColorTheme.black,
                                                      fontSize: 18)),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('확인',
                                                  style: TextStyle(
                                                      color: ColorTheme.black,
                                                      fontSize: 18)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: CupertinoDatePicker(
                                          minimumDate: DateTime(
                                                    widget.schedule.date.year,
                                                    widget.schedule.date.month,
                                                    widget.schedule.date.day,
                                                  ) ==
                                                  DateTime(
                                                      DateTime.now().year,
                                                      DateTime.now().month,
                                                      DateTime.now().day)
                                              ? DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month,
                                                  DateTime.now().day,
                                                  DateTime.now().hour,
                                                  DateTime.now().minute,
                                                )
                                              : null,
                                          mode: CupertinoDatePickerMode.time,
                                          use24hFormat: true,
                                          minuteInterval: 10,
                                          initialDateTime: initialStartTime,
                                          onDateTimeChanged: (picked) {
                                            setState(() {
                                              widget.onStartTimeSelected(true);
                                              _startAnytime = false;
                                              _updateTimes(picked, _endTime);
                                              _startTimeTextField.text =
                                                  DateFormat('a h시 mm분', 'ko')
                                                      .format(picked);
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
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        '부터',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
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
                              borderSide:
                                  BorderSide(color: ColorTheme.primary, width: 0.5),
                              borderRadius: BorderRadius.all(Radius.circular(14)),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ColorTheme.inactiveIcon, width: 0.5),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('취소',
                                                style: TextStyle(
                                                    color: ColorTheme.black,
                                                    fontSize: 18)),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('확인',
                                                style: TextStyle(
                                                    color: ColorTheme.black,
                                                    fontSize: 18)),
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
                                            widget.onEndTimeSelected(true);
                                            setState(() {
                                              _endAnytime = false;
                                              _updateTimes(_startTime, picked);
                                              _endTimeTextField.text =
                                                  DateFormat('a h시 mm분', 'ko')
                                                      .format(picked);
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
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        '까지',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        // Wrap(
        //   spacing: 5,
        //   children: [
        //     CustomFilterChip(
        //       label: "아무때나",
        //       selected: _startAnytime && _endAnytime,
        //       onSelected: (bool selected) {
        //         HapticFeedback.lightImpact();
        //         setState(() {
        //           if (!_anytime) {
        //             _anytime = true;
        //             _startAnytime = true;
        //             _endAnytime = true;
        //             _startTimeTextField.text = "아무때나";
        //             _endTimeTextField.text = "아무때나";
        //             /*todo : 시작과 종료 시간을 00:00 으로 변경 */
        //           } else {
        //             _anytime = false;
        //             _startAnytime = false;
        //             _endAnytime = false;
        //             if (_startTime == null) {
        //               _startTimeTextField.text = "언제부터";
        //             } else {
        //               _startTimeTextField.text =
        //                   DateFormat('a h시 mm분', 'ko').format(_startTime);
        //             }
        //             if (_endTime == null) {
        //               _endTimeTextField.text = "언제까지";
        //             } else {
        //               _endTimeTextField.text =
        //                   DateFormat('a h시 mm분', 'ko').format(_endTime);
        //             }
        //           }
        //         });
        //       },
        //     ),
        //     CustomFilterChip(
        //       label: "시작시간 미정",
        //       selected: _startAnytime,
        //       onSelected: (bool selected) {
        //         HapticFeedback.lightImpact();
        //         setState(() {
        //           if (!_startAnytime) {
        //             _startAnytime = true;
        //             _startTimeTextField.text = "아무때나";
        //           } else {
        //             _startAnytime = false;
        //             _anytime = false;
        //             if (_startTime == null) {
        //               _startTimeTextField.text = "언제부터";
        //             } else {
        //               _startTimeTextField.text =
        //                   DateFormat('a h시 mm분', 'ko').format(_startTime);
        //             }
        //           }
        //         });
        //       },
        //     ),
        //     CustomFilterChip(
        //       label: "끝나는 시간 미정",
        //       selected: _endAnytime,
        //       onSelected: (bool selected) {
        //         HapticFeedback.lightImpact();
        //         setState(() {
        //           if (!_endAnytime) {
        //             _endAnytime = true;
        //             _endTimeTextField.text = "아무때나";
        //             /*todo: 끝나는 시간을 23:50 으로 설정*/
        //           } else {
        //             _endAnytime = false;
        //             if (_endTime == null) {
        //               _endTimeTextField.text = "언제까지";
        //             } else {
        //               _endTimeTextField.text =
        //                   DateFormat('a h시 mm분', 'ko').format(_endTime);
        //             }
        //           }
        //         });
        //       },
        //     ),
        //   ],
        // ),
        FilledButton(
          onPressed: widget.isEndTimeSelected && widget.isStartTimeSelected ? () {
            widget.goToPage(2);
          } : null,
          child: Text('다음'),
          style: widget.isEndTimeSelected && widget.isStartTimeSelected
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
