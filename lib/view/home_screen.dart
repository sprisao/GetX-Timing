import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:timing/view/components/timing_appbar.dart';
import 'package:timing/viewmodel/timing_viewmodel.dart';

import '../style/theme.dart';
import 'components/timing_filterchip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<TimingViewModel>(context, listen: false).getMyScheduleList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimingViewModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: const AppbarWithLogo(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              /*navigate to AddTimingScreen*/
              HapticFeedback.heavyImpact();
              _showMultiScreenBottomSheet(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const AddScheduleScreen(),
              //   ),
              // );
            },
            child: const Icon(Icons.add),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListView(
                  shrinkWrap: true,
                  children: model.myScheduleList
                      .map((e) =>
                      ListTile(
                        title: Text(e.startTime.toString()),
                        subtitle: Text(e.endTime.toString()),
                      ))
                      .toList(),
                ),
                FilledButton(
                    onPressed: () {}, child: Text('Show Friends list')),
                FilledButton(
                    onPressed: () {}, child: Text("Show Friend's Schedule")),
              ],
            ),
          ),
        );
      },
    );
  }
}

void _showMultiScreenBottomSheet(BuildContext context) {
  showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.black,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return const MultiScreenBottomSheet();
      });
}

class MultiScreenBottomSheet extends StatefulWidget {
  const MultiScreenBottomSheet({Key? key}) : super(key: key);

  @override
  State<MultiScreenBottomSheet> createState() => _MultiScreenBottomSheetState();
}

class _MultiScreenBottomSheetState extends State<MultiScreenBottomSheet> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.52,
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close)),
              ],
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                children: const [AddScreen1(), AddScreen2(), AddScreen3()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddScreen1 extends StatefulWidget {
  const AddScreen1({Key? key}) : super(key: key);

  @override
  State<AddScreen1> createState() => _AddScreen1State();
}

class _AddScreen1State extends State<AddScreen1> {
  DateTime? _date = DateTime.now();
  TextEditingController _dateTextField = TextEditingController();

  DateTime _firstDateOfCurrentMonth() {
    final now = DateTime.now();
    final daysToFirstDayOfWeek = now.weekday - DateTime.monday;
    return now.subtract(Duration(days: daysToFirstDayOfWeek));
  }

  DateTime _lastDateOfCurrentMonth() {
    final now = DateTime.now();
    final daysToLastDayOfWeek = DateTime.sunday - now.weekday;
    final lastDayOfCurrentWeek = now.add(Duration(days: daysToLastDayOfWeek));
    final lastDayOfNextWeek = lastDayOfCurrentWeek.add(Duration(days: 7));
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
              _dateTextField.text = _date.toString();
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
        DateTime
            .now()
            .year,
        DateTime
            .now()
            .month,
        DateTime
            .now()
            .day,
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
        DateTime
            .now()
            .year,
        DateTime
            .now()
            .month,
        DateTime
            .now()
            .day,
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

class AddScreen3 extends StatefulWidget {
  const AddScreen3({Key? key}) : super(key: key);

  @override
  State<AddScreen3> createState() => _AddScreen3State();
}

class _AddScreen3State extends State<AddScreen3> {
  final List<String> selectedLocations = [];

  @override
  void initState() {
    super.initState();
    Provider.of<TimingViewModel>(context, listen: false).queryLocationList();
  }

  @override
  Widget build(BuildContext context) {
    return AddTimingSection(
        title: "지역",
        subTitle: "이동 가능한 지역을 선택 해 주세요!",
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Consumer<TimingViewModel>(
                builder: (context, model, child) {
                  if (model.locations.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Wrap(
                      spacing: 6,
                      runSpacing: -9,
                      children: model.locations
                          .map((e) =>
                          CustomFilterChip(
                            label: e.titleKR,
                            selected: selectedLocations.contains(e.id)
                                ? true
                                : false,
                            onSelected: (selected) {
                              HapticFeedback.lightImpact();
                              if (selected) {
                                if (selectedLocations.length < 5) {
                                  setState(() {
                                    selectedLocations.add(e.id);
                                  });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(16.0),
                                          ),
                                          // title: const Text('Alert'),
                                          content: const SizedBox(
                                            height: 75,
                                            child: Center(
                                              child: Text(
                                                  '최대 5개의 지역을 선택 하실 수 있어요~'),
                                            ),
                                          ),
                                          actions: [
                                            Center(
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop();
                                                },
                                                child: const Text(
                                                  '확인',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                }
                              } else {
                                setState(() {
                                  selectedLocations.remove(e.id);
                                });
                              }
                            },
                          ))
                          .toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ));
  }
}

class AddTimingSection extends StatefulWidget {
  final String title;
  final String? subTitle;
  final Widget content;

  const AddTimingSection({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.content,
  }) : super(key: key);

  @override
  State<AddTimingSection> createState() => _AddTimingSectionState();
}

class _AddTimingSectionState extends State<AddTimingSection> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                if (widget.subTitle != null)
                  Text(
                    widget.subTitle!,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.normal),
                  )
              ],
            ),
          ),
          widget.content,
        ],
      ),
    );
  }
}
