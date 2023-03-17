import 'package:timing/models/ModelProvider.dart';
import 'package:timing/models/activity_model.dart';
import 'package:timing/models/location_model.dart';

import 'Privacy.dart';

class ScheduleModel {
  final String? id;
  late final DateTime date;
  late final DateTime startTime;
  late final DateTime endTime;
  final Privacy privacy;
  final List<String> locationList;
  final List<String> activityItemList;

  ScheduleModel({
    this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.privacy,
    required this.locationList,
    required this.activityItemList,
  });

  ScheduleModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        date = DateTime.parse(json['date']),
        startTime = DateTime.parse(json['startTime']),
        endTime = DateTime.parse(json['endTime']),
        privacy = Privacy.values.firstWhere(
            (element) => element.toString() == 'Privacy.${json['privacy']}'),
        locationList = List<String>.from(json['locationList']),
        activityItemList = List<String>.from(json['activityItemList']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'privacy': privacy.toString(),
        'locationList': locationList,
        'activityItemList': activityItemList,
      };
}

class CreateScheduleModel {
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final Privacy privacy;
  final List<LocationModel> locationList;
  final List<ActivityItemModel> activityItemList;

  CreateScheduleModel({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.privacy,
    required this.locationList,
    required this.activityItemList,
  });

}