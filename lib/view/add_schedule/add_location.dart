import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timing/models/location_model.dart';
import 'package:timing/models/schedule_model.dart';

import '../../style/theme.dart';
import '../../viewmodel/timing_viewmodel.dart';
import '../components/add_section.dart';
import '../components/timing_filterchip.dart';

class AddScreen3 extends StatefulWidget {
  final Function(CreateScheduleModel) onUpdate;
  final CreateScheduleModel schedule;
  final Function(int page) goToPage;
  final int currentPage;
  final Function(bool selected) onLocationSelected;
  final bool isLocationSelected;

  const AddScreen3(
      {Key? key,
      required this.onUpdate,
      required this.schedule,
      required this.goToPage,
      required this.currentPage,
      required this.onLocationSelected,
      required this.isLocationSelected})
      : super(key: key);

  @override
  State<AddScreen3> createState() => _AddScreen3State();
}

class _AddScreen3State extends State<AddScreen3> {
  late List<LocationModel> selectedLocations;

  @override
  void initState() {
    super.initState();
    selectedLocations = widget.schedule.locationList;
  }

  void _updateLocations(List<LocationModel> locations) {
    setState(() {
      selectedLocations = locations;
      selectedLocations.isNotEmpty
          ? widget.onLocationSelected(true)
          : widget.onLocationSelected(false);
    });
    widget.onUpdate(CreateScheduleModel(
        date: widget.schedule.date,
        startTime: widget.schedule.startTime,
        endTime: widget.schedule.endTime,
        locationList: selectedLocations,
        activityItemList: widget.schedule.activityItemList,
        privacy: widget.schedule.privacy));
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
                          .map((e) => CustomFilterChip(
                                label: e.titleKR,
                                selected: selectedLocations.contains(e)
                                    ? true
                                    : false,
                                onSelected: (selected) {
                                  HapticFeedback.lightImpact();
                                  if (selected) {
                                    if (selectedLocations.length < 3) {
                                      setState(() {
                                        _updateLocations(
                                            [...selectedLocations, e]);
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
                                                      '최대 3개의 지역을 선택 하실 수 있어요~'),
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
                                      _updateLocations(
                                        [...selectedLocations]..removeWhere(
                                            (element) => element.id == e.id),
                                      );
                                    });
                                  }
                                },
                              ))
                          .toList(),
                    );
                  }
                },
              ),
              FilledButton(
                onPressed: widget.isLocationSelected
                    ? () {
                        widget.goToPage(3);
                      }
                    : null,
                style: widget.isLocationSelected
                    ? FilledButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: ColorTheme.primary,
                      )
                    : FilledButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.grey,
                      ),
                child: const Text('다음'),
              ),
            ],
          ),
        ));
  }
}
