import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timing/view/components/timing_appbar.dart';
import 'package:timing/viewmodel/timing_viewmodel.dart';

import '../models/ModelProvider.dart';
import '../models/activity_model.dart';

class AddScheduleScreen extends StatefulWidget {
  const AddScheduleScreen({Key? key}) : super(key: key);

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  List<ActivityCategoryModel> activityCategories = [];
  List<Location?> locations = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<TimingViewModel>(context, listen: false)
        .queryLocationList()
        .then((value) {
      setState(() {
        locations = value;
      });
    });
    Provider.of<TimingViewModel>(context, listen: false)
        .queryActivityCatWithItem()
        .then((value) {
      setState(() {
        activityCategories = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Location> selectedLocations = [];

    return Consumer<TimingViewModel>(builder: (context, viewModel, child) {
      return Scaffold(
        appBar: AppbarWithOutLogo(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                children: [
                  for (var location in locations)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ChoiceChip(
                        label: Text(location!.name),
                        selected: selectedLocations == location,
                        onSelected: (selected) {
                          setState(() {
                            selectedLocations.add(location);
                          });
                        },
                      ),
                    )
                ],
              ),

              FilledButton(
                  onPressed: () {
                    viewModel.createSchedule();
                  },
                  child: Text('스케쥴 생성'))
            ],
          ),
        ),
      );
    });
  }
}
