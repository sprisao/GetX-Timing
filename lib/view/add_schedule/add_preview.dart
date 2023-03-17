import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import '../../models/schedule_model.dart';

class AddPreviewScreen extends StatefulWidget {
  final ScheduleModel schedule;

  const AddPreviewScreen({Key? key, required this.schedule}) : super(key: key);

  @override
  State<AddPreviewScreen> createState() => _AddPreviewScreenState();
}

class _AddPreviewScreenState extends State<AddPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(
          onPressed: () {
            safePrint(widget.schedule.date);
            safePrint(widget.schedule.startTime);
            safePrint(widget.schedule.endTime);
            safePrint(widget.schedule.locationList);
            safePrint(widget.schedule.activityItemList);
            safePrint(widget.schedule.privacy);
          },
          child: Text("ShowValues")),
    );
  }
}
