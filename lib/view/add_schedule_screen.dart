import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timing/view/components/timing_appbar.dart';
import 'package:timing/viewmodel/timing_viewmodel.dart';

import '../models/ModelProvider.dart';

class AddScheduleScreen extends StatefulWidget {
  const AddScheduleScreen({Key? key}) : super(key: key);

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class LocalActivityItem {
  String name;
  String emoji;
  String titleKR;
  String category;

  LocalActivityItem({required this.name, required this.emoji, required this.titleKR, required this.category});
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {

  Future<List<LocalActivityItem>> convertAndAdd() async{
    String jsonString = await rootBundle.loadString('assets/activity_item.json');
    final jsonData = json.decode(jsonString);
    List<LocalActivityItem> localActivityItems = [];
    for (var item in jsonData) {
      String category = item['activitycategoryID'];
      for (var activityItem in item['items']) {
        localActivityItems.add(LocalActivityItem(
          name: activityItem['name'],
          emoji: activityItem['emoji'],
          titleKR: activityItem['titleKR'],
          category: category,
        ));
      }
    }
    return localActivityItems;
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                  onPressed: () {
                    Future<List<LocalActivityItem>> localActivityItems = convertAndAdd();
                    localActivityItems.then((value) {
                      for (var item in value) {
                        safePrint(item.titleKR);
                        // viewModel.createActivityItem(
                        //     name: item.name,
                        //     emoji: item.emoji,
                        //     titleKR: item.titleKR,
                        //     category: item.category);
                       viewModel.createActivityItem(
                            name: item.name,
                            emoji: item.emoji,
                            titleKR: item.titleKR,
                            category: item.category);
                      }
                    });
                  },
                  child: Text('활동 데이터 가져오기')
              ),
              FilledButton(
                  onPressed: () {
                    Future<List<Location?>> locationList =
                        viewModel.queryLocationList();
                    locationList.then((value) {
                      safePrint(value);
                    });
                  },
                  child: Text('지역 데이터 가져오기')),
              FilledButton(onPressed: () {
                var activityCategories = viewModel.queryActivityCategoryList();
                activityCategories.then((value) {
                  safePrint(value);
                });
              }, child: Text('활동 카테고리  불러오기')),
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
