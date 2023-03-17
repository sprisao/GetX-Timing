import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timing/models/activity_model.dart';
import 'package:timing/models/location_model.dart';
import 'package:timing/style/theme.dart';

import '../../models/schedule_model.dart';

class AddPreviewScreen extends StatefulWidget {
  final CreateScheduleModel schedule;

  const AddPreviewScreen({Key? key, required this.schedule}) : super(key: key);

  @override
  State<AddPreviewScreen> createState() => _AddPreviewScreenState();
}

class _AddPreviewScreenState extends State<AddPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    String date = DateFormat('d일').format(widget.schedule.date);
    String weekDay = DateFormat('E요일').format(widget.schedule.date);
    String startTime = DateFormat('hh:mm a').format(widget.schedule.startTime);
    String endTime = DateFormat('hh:mm a').format(widget.schedule.endTime);
    List<LocationModel> locations= widget.schedule.locationList;
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

    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: ColorTheme.line,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            minHeight: 100,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(date,
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 3,
                            ),
                            Text(weekDay,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      if (startTime != "12:00 AM" && endTime != "11:59 PM")
                        Card(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: ColorTheme.line,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          elevation: 0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  startTime == "12:00 AM" ? "미정" : startTime,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  endTime == "11:59 PM" ? "미정" : endTime,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 5,
                        children: mainActivities.map((e) {
                          return Chip(
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 0),
                            label: Text(
                              (e.emoji + e.titleKR),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w300),
                            ),
                          );
                        }).toList(),
                      ),
                      Row(
                        children: [
                          const Text(
                            "지역 : ",
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            locations
                                .map((e) => e.titleKR)
                                .toList()
                                .join("•"),
                            style: const TextStyle(
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      if (subActivities.isNotEmpty)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("그 외 관심 활동 :",
                                ),
                            const SizedBox(
                              width: 5,
                            ),
                            Wrap(
                              runSpacing: -10,
                              children: subActivities
                                  .map((e) => Chip(
                                        labelPadding: const EdgeInsets.all(0),
                                        side: const BorderSide(
                                          color: ColorTheme.line,
                                        ),
                                        backgroundColor: Colors.transparent,
                                        label: Text(
                                          e.titleKR,
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
