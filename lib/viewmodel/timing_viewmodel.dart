import 'package:flutter/widgets.dart';
import 'package:timing/models/activity_model.dart';

import '../data/timing_repository.dart';
import '../models/ModelProvider.dart';
import '../models/location_model.dart';
import '../models/schedule_model.dart';

class TimingViewModel with ChangeNotifier {
  final TimingRepository _repository;

  List<LocationModel> _locations = [];
  List<ActivityCategoryModel> _activityCatWithItems = [];
  List<ScheduleModel> _myScheduleList = [];

  TimingViewModel({TimingRepository? repository})
      : _repository = repository ?? TimingRepository();

  List<LocationModel> get locations => _locations;
  List<ActivityCategoryModel> get activityCatWithItems => _activityCatWithItems;
  List<ScheduleModel> get myScheduleList => _myScheduleList;

  ScheduleModel createNewScheduleModel() {
    return ScheduleModel(
      date: DateTime.now(),
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      privacy: Privacy.ONLYPUBLIC,
      locationList: [],
      activityItemList: [],
    );
  }

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
  Future<void> queryLocationList() async {
    _locations = await _repository.getLocationList();
    notifyListeners();
  }

  Future<void> queryActivityCatWithItem() async {
    _activityCatWithItems = await _repository.getActivityCatWithItems();
    notifyListeners();
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
  Future<void> createSchedule(
      CreateScheduleModel schedule, Privacy privacy) async {
    await _repository.createSchedule(schedule, privacy);
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

  Future<void> getMyScheduleList() async {
    _myScheduleList = await _repository.getMyScheduleList();
    notifyListeners();
  }
}
