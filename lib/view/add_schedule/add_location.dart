import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/timing_viewmodel.dart';
import '../components/add_section.dart';
import '../components/timing_filterchip.dart';

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
                          .map((e) => CustomFilterChip(
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
