import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../style/theme.dart';
import '../../viewmodel/timing_viewmodel.dart';
import '../components/add_section.dart';

class AddScreen4 extends StatefulWidget {
  const AddScreen4({Key? key}) : super(key: key);

  @override
  State<AddScreen4> createState() => _AddScreen4State();
}

class _AddScreen4State extends State<AddScreen4> {
  final List<String> _selectedActivities = [];

  @override
  void initState() {
    super.initState();
    Provider.of<TimingViewModel>(context, listen: false)
        .queryActivityCatWithItem();
  }

  @override
  Widget build(BuildContext context) {
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
                                      color:
                                      _selectedActivities.contains(activity.id)
                                          ? _selectedActivities
                                          .indexOf(activity.id) <
                                          3
                                          ? ColorTheme.primary
                                          : ColorTheme.secondary
                                          : ColorTheme.inactiveIcon,
                                      width: 1),
                                  labelStyle: TextStyle(
                                      fontSize: 15,
                                      color: _selectedActivities
                                          .indexOf(activity.id) <
                                          3
                                          ? ColorTheme.black
                                          : ColorTheme.white),
                                  label: Text(activity.emoji + activity.titleKR),
                                  selected:
                                  _selectedActivities.contains(activity.id),
                                  selectedColor:
                                  _selectedActivities.indexOf(activity.id) < 3
                                      ? ColorTheme.primaryLight
                                      : ColorTheme.secondaryLight,
                                  onSelected: (isSelected) {
                                    HapticFeedback.mediumImpact();
                                    setState(() {
                                      if (_selectedActivities
                                          .contains(activity.id)) {
                                        _selectedActivities.remove(activity.id);
                                      } else {
                                        if (_selectedActivities.length < 7) {
                                          _selectedActivities.add(activity.id);
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
