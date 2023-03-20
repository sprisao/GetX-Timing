import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timing/models/schedule_model.dart';
import 'package:timing/util/time_manager.dart';
import '../../style/theme.dart';

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

  @override
  void initState() {
    super.initState();
    _startTime = widget.schedule.startTime;
    _endTime = widget.schedule.endTime;
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
    _startTimeTextField.text = widget.isStartTimeSelected
        ? DateFormat('a h시 mm분', 'ko').format(_startTime)
        : "언제부터";
    _endTimeTextField.text = widget.isEndTimeSelected
        ? DateFormat('a h시 mm분', 'ko').format(_endTime)
        : "언제까지";

    return Column(
      children: [
        /*2023년 m월 d일*/
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 5),
              child: Text(
                DateFormat('yyyy년 M월 d일 E요일', 'ko')
                    .format(widget.schedule.date),
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
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16),
                            suffixIcon: Icon(
                              Icons.keyboard_arrow_down,
                              color: ColorTheme.activeIcon,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ColorTheme.primary, width: 0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14)),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ColorTheme.inactiveIcon, width: 0.1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14)),
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
                                          maximumDate: widget.isEndTimeSelected
                                              ? _endTime
                                              : null,
                                          minimumDate: DateTime(
                                                    widget.schedule.date.year,
                                                    widget.schedule.date.month,
                                                    widget.schedule.date.day,
                                                  ) ==
                                                  DateTime(
                                                      DateTime.now().year,
                                                      DateTime.now().month,
                                                      DateTime.now().day)
                                              ? DateTimeUtils.roundToNearest(
                                                  DateTime.now(), 5)
                                              : null,
                                          mode: CupertinoDatePickerMode.time,
                                          use24hFormat: false,
                                          minuteInterval: 10,
                                          initialDateTime: _startTime,
                                          onDateTimeChanged: (picked) {
                                            setState(() {
                                              widget.onStartTimeSelected(true);
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
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16),
                            suffixIcon: Icon(
                              Icons.keyboard_arrow_down,
                              color: ColorTheme.activeIcon,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ColorTheme.primary, width: 0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14)),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ColorTheme.inactiveIcon, width: 0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14)),
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
                                          minimumDate:
                                              widget.isStartTimeSelected
                                                  ? _startTime
                                                  : null,
                                          mode: CupertinoDatePickerMode.time,
                                          use24hFormat: false,
                                          minuteInterval: 10,
                                          initialDateTime:
                                              widget.isEndTimeSelected
                                                  ? _endTime
                                                  : _startTime,
                                          onDateTimeChanged: (picked) {
                                            widget.onEndTimeSelected(true);
                                            setState(() {
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
        FilledButton(
          onPressed: widget.isEndTimeSelected && widget.isStartTimeSelected
              ? () {
                  widget.goToPage(2);
                }
              : null,
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
