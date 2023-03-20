import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/Privacy.dart';
import '../../models/schedule_model.dart';
import '../../util/time_manager.dart';
import '../../viewmodel/timing_viewmodel.dart';
import 'add_activity.dart';
import 'add_date.dart';
import 'add_location.dart';
import 'add_preview.dart';
import 'add_time.dart';

class MultiScreenBottomSheet extends StatefulWidget {
  const MultiScreenBottomSheet({Key? key}) : super(key: key);

  @override
  State<MultiScreenBottomSheet> createState() => _MultiScreenBottomSheetState();
}

class _MultiScreenBottomSheetState extends State<MultiScreenBottomSheet> {
  bool isDateSelected = false;
  bool isStartTimeSelected = false;
  bool isEndTimeSelected = false;
  bool isLocationSelected = false;
  bool isActivitySelected = false;
  bool isPrivacySelected = false;

  late PageController _pageController;
  int _currentPage = 0;

  late CreateScheduleModel schedule;

  @override
  void initState() {
    super.initState();
    Provider.of<TimingViewModel>(context, listen: false)
        .queryActivityCatWithItem();
    Provider.of<TimingViewModel>(context, listen: false).queryLocationList();
    _pageController = PageController(initialPage: _currentPage);
    schedule = CreateScheduleModel(
      date: DateTime.now(),
      startTime: DateTimeUtils.roundToNearest(DateTime.now(), 5),
      endTime: DateTimeUtils.roundToNearest(DateTime.now(), 5),
      locationList: [],
      activityItemList: [],
      privacy: Privacy.ALL,
    );
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

  void onDateSelected(bool selected) {
    setState(() {
      isDateSelected = selected;
    });
  }

  void onStartTimeSelected(bool selected) {
    setState(() {
      isStartTimeSelected = selected;
    });
  }

  void onEndTimeSelected(bool selected) {
    setState(() {
      isEndTimeSelected = selected;
    });
  }

  void onLocationSelected(bool selected) {
    setState(() {
      isLocationSelected = selected;
    });
  }

  void onActivitySelected(bool selected) {
    setState(() {
      isActivitySelected = selected;
    });
  }

  void onPrivacySelected(bool selected) {
    setState(() {
      isPrivacySelected = selected;
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _currentPage == 0
                    ? const SizedBox()
                    : IconButton(
                        onPressed: () {
                          _pageController.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        },
                        icon: const Icon(Icons.arrow_back_ios)),
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
                    onStartTimeSelected: onStartTimeSelected,
                    onEndTimeSelected: onEndTimeSelected,
                  ),
                  AddScreen2(
                    schedule: schedule,
                    onUpdate: updateSchedule,
                    goToPage: goToPage,
                    currentPage: _currentPage,
                    onStartTimeSelected: onStartTimeSelected,
                    onEndTimeSelected: onEndTimeSelected,
                    isStartTimeSelected: isStartTimeSelected,
                    isEndTimeSelected: isEndTimeSelected,
                  ),
                  AddScreen3(
                    schedule: schedule,
                    onUpdate: updateSchedule,
                    goToPage: goToPage,
                    currentPage: _currentPage,
                    onLocationSelected: onLocationSelected,
                    isLocationSelected: isLocationSelected,
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
