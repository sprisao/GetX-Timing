import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timing/view/components/timing_appbar.dart';
import 'package:timing/view/components/timing_filterchip.dart';
import 'package:timing/viewmodel/timing_viewmodel.dart';

class AddScheduleScreen extends StatefulWidget {
  const AddScheduleScreen({Key? key}) : super(key: key);

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {

  final List<String> selectedLocations = [];
  final List<String> selectedActivities = [];

  @override
  void initState() {
    super.initState();
    Provider.of<TimingViewModel>(context, listen: false).queryLocationList();
    Provider.of<TimingViewModel>(context, listen: false)
        .queryActivityCatWithItem();
  }

  @override
  Widget build(BuildContext context) {
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                spacing: 6,
                runSpacing: -9,
                children: viewModel.locations
                    .map((e) => CustomFilterChip(
                          label: (e.titleKR),
                          selected:
                              selectedLocations.contains(e.id) ? true : false,
                          onSelected: (selected) {
                            HapticFeedback.lightImpact();
                            safePrint(selectedLocations.length);
                            safePrint(e.titleKR);
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
                                            child:
                                                Text('최대 5개의 지역을 선택 하실 수 있어요~'),
                                          ),
                                        ),
                                        actions: [
                                          Center(
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
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
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: viewModel.activityCatWithItems.map((e) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Text(
                              e.titleKR,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Wrap(
                        spacing: 6,
                        runSpacing: -9,
                        children: e.activityItems
                            .map((e) => CustomFilterChip(
                                  label: e.titleKR,
                                  selected: selectedActivities.contains(e.id)
                                      ? true
                                      : false,
                                  onSelected: (selected) {
                                    HapticFeedback.lightImpact();
                                    if (selected) {
                                      if (selectedActivities.length < 5) {
                                        setState(() {
                                          selectedActivities.add(e.id);
                                        });
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                ),
                                                // title: const Text('Alert'),
                                                content: const SizedBox(
                                                  height: 75,
                                                  child: Center(
                                                    child: Text(
                                                        '최대 5개의 활동을 선택 하실 수 있어요~'),
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
                                        selectedActivities.remove(e.id);
                                      });
                                    }
                                  },
                                ))
                            .toList(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                }).toList(),
              ),
              FilledButton(
                  onPressed: () {
                    viewModel.createSchedule(
                      selectedLocations,
                      selectedActivities,
                    );
                  },
                  child: Text('스케쥴 생성'))
            ],
          ),
        ),
      );
    });
  }
}
