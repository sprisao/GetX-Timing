import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timing/models/ModelProvider.dart';
import 'package:timing/models/schedule_model.dart';
import 'package:timing/view/add_schedule/add_preview.dart';
import 'package:timing/view/components/timing_appbar.dart';
import 'package:timing/viewmodel/timing_viewmodel.dart';

import 'add_schedule/add_activity.dart';
import 'add_schedule/add_date.dart';
import 'add_schedule/add_location.dart';
import 'add_schedule/add_time.dart';

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
              HapticFeedback.heavyImpact();
              _showMultiScreenBottomSheet(context);
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
                      .map((e) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              /*date in korean format*/
                              Text(DateFormat('d일 E요일', 'ko').format(e.date)),
                              Column(
                                children: [
                                  Text(DateFormat('hh:mm a')
                                      .format(e.startTime.toLocal())),
                                  Text(DateFormat('hh:mm a')
                                      .format(e.endTime.toLocal())),
                                ],
                              )
                              /*time in korea time zone*/
                            ],
                          )))
                      .toList(),
                ),
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
  bool isDateSelected = false;
  late PageController _pageController;
  int _currentPage = 0;

  CreateScheduleModel schedule = CreateScheduleModel(
    date: DateTime.now(),
    startTime: DateTime.now(),
    endTime: DateTime.now(),
    locationList: [],
    activityItemList: [],
    privacy: Privacy.ALL,
  );

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void updateSchedule(CreateScheduleModel newSchedule) {
    setState(() {
      schedule = newSchedule;
    });
  }

  void onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void onDateSelected(bool selected){
    setState(() {
      isDateSelected = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.52,
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
                    icon: const Icon(Icons.close)),
              ],
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: onPageChanged,
                children: [
                  AddScreen1(
                    schedule: schedule,
                    onUpdate: updateSchedule,
                    goToPage: goToPage,
                    currentPage: _currentPage,
                    onDateSelected: onDateSelected,
                    isDateSelected: isDateSelected,
                  ),
                  AddScreen2(
                    schedule: schedule,
                    onUpdate: updateSchedule,
                    goToPage: goToPage,
                    currentPage: _currentPage,
                  ),
                  AddScreen3(
                    schedule: schedule,
                    onUpdate: updateSchedule,
                    goToPage: goToPage,
                    currentPage: _currentPage,
                  ),
                  AddScreen4(
                    schedule: schedule,
                    onUpdate: updateSchedule,
                    goToPage: goToPage,
                    currentPage: _currentPage,
                  ),
                  AddPreviewScreen(
                    schedule: schedule,
                    goToPage: goToPage,
                    currentPage: _currentPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
