import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timing/models/activity_model.dart';
import 'package:timing/models/location_model.dart';
import 'package:timing/viewmodel/timing_viewmodel.dart';

import '../../models/Privacy.dart';
import '../../models/schedule_model.dart';
import '../../style/theme.dart';

class AddPreviewScreen extends StatefulWidget {
  final CreateScheduleModel schedule;
  final Function(int page) goToPage;
  final int currentPage;

  const AddPreviewScreen(
      {Key? key,
      required this.schedule,
      required this.goToPage,
      required this.currentPage})
      : super(key: key);


  @override
  State<AddPreviewScreen> createState() => _AddPreviewScreenState();
}

class _AddPreviewScreenState extends State<AddPreviewScreen> {
  Privacy privacy = Privacy.ALL;

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('d일').format(widget.schedule.date);
    String weekDay = DateFormat('E요일', 'ko').format(widget.schedule.date);
    String startTime = DateFormat('hh:mm a').format(widget.schedule.startTime);
    String endTime = DateFormat('hh:mm a').format(widget.schedule.endTime);
    List<LocationModel> locations = widget.schedule.locationList;
    List<ActivityItemModel>? mainActivities = widget.schedule.activityItemList
        .sublist(
            0,
            widget.schedule.activityItemList.length >= 3
                ? 3
                : widget.schedule.activityItemList.length);
    List<ActivityItemModel>? subActivities = widget.schedule.activityItemList
        .sublist(widget.schedule.activityItemList.length >= 3
            ? 3
            : widget.schedule.activityItemList.length);

    return Consumer<TimingViewModel>(builder: (context, viewModel, child) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: Colors.red,
                        child: Column(children: [
                          Expanded(
                            flex: 5,
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(date),
                                  Text(weekDay),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 4,
                              child: Container(
                                width: double.infinity,
                                color: Colors.blue,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(startTime),
                                    Text(endTime),
                                  ],
                                ),
                              )),
                        ]),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        color: Colors.green,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Wrap(
                                  children: mainActivities.map((e) {
                                return Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(e.titleKR),
                                );
                              }).toList()),
                            ]),
                            Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 5.0,
                              runSpacing: 5.0,
                              children: subActivities.map((e) {
                                return Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(e.titleKR),
                                );
                              }).toList(),
                            ),
                            Row(children: [
                              Text('📍'),
                              Row(
                                children: locations
                                    .map((e) => Text(e.titleKR))
                                    .toList(),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 10),
            Text('누구에게 보여줄까요?'),
            SizedBox(height: 10),
            TextField(
              readOnly: true,
              showCursor: false,
              controller: TextEditingController(text: '전체공개'),
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
                showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    context: context,
                    builder: (context) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 200,
                        child: CupertinoPicker(
                          itemExtent: 45,
                          onSelectedItemChanged: (value) {
                            if (value == 0) {
                              print('전체공개');
                              setState(() {
                                privacy = Privacy.ALL;
                              });
                            } else if (value == 1) {
                              print('친구에게만');
                              setState(() {
                                privacy = Privacy.ONLYFRIENDS;
                              });
                            } else if (value == 2) {
                              print('친구가 아닌 사람에게만');
                              privacy = Privacy.ONLYPUBLIC;
                            }
                          },
                          children: [
                            Text('전체공개'),
                            Text('친구에게만'),
                            Text('친구가 아닌 사람에게만'),
                          ],
                        ),
                      );
                    });
              },
            ),
            SizedBox(height: 10),
            FilledButton(
              onPressed: () {
                viewModel.createSchedule(widget.schedule, privacy);
              },
              child: Text('저장하기'),
            ),
          ],
        ),
      );
    });
  }
}
