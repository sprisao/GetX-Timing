import 'package:flutter/widgets.dart';
import 'package:timing/models/activity_model.dart';

import '../data/timing_repository.dart';
import '../models/ModelProvider.dart';

class TimingViewModel with ChangeNotifier {
  final TimingRepository _repository;

  TimingViewModel({TimingRepository? repository})
      : _repository = repository ?? TimingRepository();

  /*Auth CurrentAuthenticatedUser*/
  Future<void> currentUserId() async {
    await _repository.currentUser();
    notifyListeners();
  }

  /*User 데이터 생성*/
  Future<void> initUser() async {
    await _repository.initUser();
    notifyListeners();
  }

  /* 지역 데이터 가져오기 */
  Future<List<LocationModel>> queryLocationList() async {
    final locationList = await _repository.getLocationList();
    notifyListeners();
    return locationList;
  }


  Future<List<ActivityCategoryModel>> queryActivityCatWithItem() async {
    final activityCatWithItem = await _repository.getActivityCatWithItems();
    notifyListeners();
    return activityCatWithItem;
  }

  /* 활동 카테고리 가져오기 */
  Future<List<ActivityCategory?>> queryActivityCategoryList() async {
    final activityCatList = await _repository.getActivityCatList();
    notifyListeners();
    return activityCatList;
  }

  /* 활동 아이템 가져오기 */
  Future<List<ActivityItem?>> queryActivityItemList() async {
    final activityItemList = await _repository.getActivityItemList();
    notifyListeners();
    return activityItemList;
  }

  /* 스케쥴 생성 */
  Future<void> createSchedule(List<LocationModel> selectedLocations, List<ActivityItemModel> selectedActivities) async {
    await _repository.createSchedule( selectedLocations, selectedActivities);
    notifyListeners();
  }

  void createActivityItem(
      {required String name,
      required String emoji,
      required String titleKR,
      required String category}) {
    _repository.createActivityItem(
        name: name, emoji: emoji, titleKR: titleKR, category: category);
    notifyListeners();
  }

  void createLocationItem(
      {required String name,
      required String titleEN,
      required String titleKR}) {
    _repository.createLocationItem(
        name: name, titleEN: titleEN, titleKR: titleKR);
  }
}
