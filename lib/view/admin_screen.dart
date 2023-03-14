import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../viewmodel/timing_viewmodel.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  Future<List<LocalActivityItem>> getLocalActivityItems() async{
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

  Future<List<LocalLocationItem>> getLocalLocationItems() async{
    String jsonString = await rootBundle.loadString('assets/location_list.json');
    final jsonData = json.decode(jsonString);
    List<LocalLocationItem> localLocationItems = [];
    for (var item in jsonData) {
      localLocationItems.add(LocalLocationItem(
        name: item['name'],
        titleEN: item['titleEN'],
        titleKR: item['titleKR'],
      ));
    }
    return localLocationItems;
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<TimingViewModel>(builder: (context, viewModel, child)
    {
      return Scaffold(
        appBar: AppBar(
          title: Text('Admin'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                  onPressed: () {
                    Future<List<
                        LocalActivityItem>> localActivityItems = getLocalActivityItems();
                    localActivityItems.then((value) {
                      for (var item in value) {
                        safePrint(item.titleKR);
                        viewModel.createActivityItem(
                            name: item.name,
                            emoji: item.emoji,
                            titleKR: item.titleKR,
                            category: item.category);
                      }
                    });
                  },
                  child: const Text('활동 데이터 대량 생성')
              ),
              FilledButton(onPressed: () {
                Future<List<
                    LocalLocationItem>> localLocationItems = getLocalLocationItems();
                localLocationItems.then((value) {
                  for (var item in value) {
                    safePrint(item.titleKR);
                    viewModel.createLocationItem(
                        name: item.name,
                        titleEN: item.titleEN,
                        titleKR: item.titleKR);
                  }
                });
              }, child: const Text('지역 데이터 대량 생성')),

            ],
          ),
        ),
      );
    });
  }
}

class LocalActivityItem {
  String name;
  String emoji;
  String titleKR;
  String category;
  LocalActivityItem({required this.name, required this.emoji, required this.titleKR, required this.category});
}

class LocalLocationItem {
  String name;
  String titleEN;
  String titleKR;
  LocalLocationItem({required this.name, required this.titleEN, required this.titleKR});
}

