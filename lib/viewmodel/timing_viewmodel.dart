import 'package:flutter/widgets.dart';

import '../data/timing_repository.dart';

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


  /*Query ActivityCategory List*/
  Future<void> queryActivityCategoryList() async {
    await _repository.getActivityCategoryList();
    notifyListeners();
  }
}
