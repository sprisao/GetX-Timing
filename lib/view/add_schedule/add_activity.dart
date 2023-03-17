import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timing/models/activity_model.dart';
import 'package:timing/models/schedule_model.dart';

import '../../style/theme.dart';
import '../../viewmodel/timing_viewmodel.dart';
import '../components/add_section.dart';

class AddScreen4 extends StatefulWidget {
  final Function(CreateScheduleModel) onUpdate;
  final CreateScheduleModel schedule;

  const AddScreen4({Key? key, required this.onUpdate, required this.schedule})
      : super(key: key);

  @override
  State<AddScreen4> createState() => _AddScreen4State();
}

class _AddScreen4State extends State<AddScreen4> {
  List<ActivityItemModel> _selectedActivities = [];

  @override
  void initState() {
    super.initState();
    Provider.of<TimingViewModel>(context, listen: false)
        .queryActivityCatWithItem();
  }

  void _updateActivities(List<ActivityItemModel> activities) {
    setState(() {
      _selectedActivities = activities;
    });
    widget.onUpdate(CreateScheduleModel(
        date: widget.schedule.date,
        startTime: widget.schedule.startTime,
        endTime: widget.schedule.endTime,
        locationList: widget.schedule.locationList,
        activityItemList: _selectedActivities,
        privacy: widget.schedule.privacy));
  }

  @override
  Widget build(BuildContext context) {
    _selectedActivities = widget.schedule.activityItemList;

    return Consumer<TimingViewModel>(builder: (context, viewModel, child) {
      return SingleChildScrollView(
        child: Column(
          children: [
            AddTimingSection(
                title: "활동",
                subTitle: "무엇을 하고 싶으신가요? \n하고 싶은 활동을 최대 7개까지 골라보세요!",
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: viewModel.activityCatWithItems.map((entry) {
                      final categoryTitle = entry.titleKR;
                      final activities = entry.activityItems;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          Text(
                            categoryTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 6,
                            runSpacing: -4,
                            children: activities.map((activity) {
                              return FilterChip(
                                  backgroundColor: Colors.transparent,
                                  showCheckmark: false,
                                  shadowColor: Colors.transparent,
                                  side: BorderSide(
                                      color: _selectedActivities
                                              .contains(activity)
                                          ? _selectedActivities
                                                      .indexOf(activity) <
                                                  3
                                              ? ColorTheme.primary
                                              : ColorTheme.secondary
                                          : ColorTheme.inactiveIcon,
                                      width: 1),
                                  labelStyle: TextStyle(
                                      fontSize: 15,
                                      color: _selectedActivities
                                                  .indexOf(activity) <
                                              3
                                          ? ColorTheme.black
                                          : ColorTheme.white),
                                  label:
                                      Text(activity.emoji + activity.titleKR),
                                  selected:
                                      _selectedActivities.contains(activity),
                                  selectedColor:
                                      _selectedActivities.indexOf(activity) <
                                              3
                                          ? ColorTheme.primaryLight
                                          : ColorTheme.secondaryLight,
                                  onSelected: (isSelected) {
                                    HapticFeedback.mediumImpact();
                                    setState(() {
                                      if (_selectedActivities
                                          .contains(activity)) {
                                        _updateActivities(_selectedActivities
                                            .where((element) =>
                                                element != activity)
                                            .toList());
                                      } else {
                                        if (_selectedActivities.length < 7) {
                                          _updateActivities([
                                            ..._selectedActivities,
                                            activity
                                          ]);
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: const Text(
                                                      '최대 7개까지 선택할 수 있어요.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('확인',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: ColorTheme
                                                                  .black)),
                                                    ),
                                                  ],
                                                );
                                              });
                                        }
                                      }
                                    });
                                  });
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Divider(
                            color: ColorTheme.inactiveIcon,
                            thickness: 0.2,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                )),
          ],
        ),
      );
    });
  }
}
