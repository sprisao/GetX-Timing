import 'dart:convert';

import 'package:amplify_api/model_mutations.dart';
import 'package:amplify_api/model_queries.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:timing/data/api_service/graphql_queries.dart';
import 'package:timing/models/ModelProvider.dart';
import 'package:timing/models/activity_model.dart';

import '../models/location_model.dart';

class TimingRepository {
  /*Auth CurrentAuthenticatedUser*/
  Future<void> currentUser() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      safePrint('Current user: ${user.userId}');
    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }

  /*Auth SignOut*/
  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      safePrint("Sign out failed: $e");
    }
  }

/*
  User 생성 : 회원가입 하고 로그인 하면 해당 유저의 이메일 주소를 토대로 바로 UserData 생성
  1. 만약 해당 이메일로 생성된 User가 없다면 생성
  2. 만약 해당 이메일로 생성된 User가 있다면 생성하지 않음
*/
  Future<void> initUser() async {
    final user = await Amplify.Auth.getCurrentUser();
    final userId = user.userId;

    try {
      final userAttributes = await Amplify.Auth.fetchUserAttributes();
      for (final element in userAttributes) {
        if (element.userAttributeKey.toString() == "email") {
          final userEmail = element.value;
          final userDataRequest =
              ModelQueries.list(User.classType, where: User.ID.eq(userId));
          final userDataResponse =
              await Amplify.API.query(request: userDataRequest).response;

          if (userDataResponse.data?.items.isEmpty ?? true) {
            final userToCreate = User(id: userId, email: userEmail);
            final userCreateRequest = ModelMutations.create(userToCreate);
            final response =
                await Amplify.API.mutate(request: userCreateRequest).response;

            final createdUser = response.data;
            if (createdUser == null) {
              safePrint('Error creating user: ${response.errors}');
              return;
            }
            safePrint('New user created: ${createdUser.id}');
          }
          safePrint('User already exists: $userId');
        }
      }
    } on ApiException catch (e) {
      safePrint('Failed to initialize user: $e');
    }
  }

  /* 스케쥴 생성 */
  Future<void> createSchedule(List<LocationModel> selectedLocations, List<ActivityItemModel> selectedActivities) async {
    /*selectedLocations 와 selectedActivityItem을 포함한 Schedule 생성*/
    safePrint(selectedLocations.length + selectedActivities.length);

    try {
      final currentUser = await Amplify.Auth.getCurrentUser();

      final userResponse = await Amplify.API
          .query(request: ModelQueries.get(User.classType, currentUser.userId))
          .response;

      final model = Schedule(
          date: TemporalDateTime.fromString("1970-01-01T12:30:23.999Z"),
          startTime: TemporalDateTime.fromString("1970-01-01T12:30:23.999Z"),
          endTime: TemporalDateTime.fromString("1970-01-01T12:30:23.999Z"),
          privacy: Privacy.ONLYPUBLIC,
          user: userResponse.data as User,
          locations: [],
          activityItems: []);
      final request = ModelMutations.create(model);
      final response = await Amplify.API.mutate(request: request).response;

      /*Schedule 생성 후 생성된 Schedule에 Location 추가*/
      for (var i = 0; i < selectedLocations.length; i++) {
        final locationResponse = await Amplify.API
            .query(request: ModelQueries.get(Location.classType, selectedLocations[i].id))
            .response;
        final location = locationResponse.data as Location;
        final scheduleLocation = ScheduleLocation(
          schedule: model,
          location: location,
        );
        final scheduleLocationRequest = ModelMutations.create(scheduleLocation);
        final scheduleLocationResponse = await Amplify.API.mutate(request: scheduleLocationRequest).response;
        final createdScheduleLocation = scheduleLocationResponse.data;
        if (createdScheduleLocation == null) {
          safePrint('errors: ${scheduleLocationResponse.errors}');
          return;
        }
        safePrint('Mutation result: ${createdScheduleLocation.id}');
      }

      /*Schedule 생성 후 생성된 Schedule에 ActivityItem 추가*/
      for (var i = 0; i < selectedActivities.length; i++) {
        final activityItemResponse = await Amplify.API
            .query(request: ModelQueries.get(ActivityItem.classType, selectedActivities[i].id))
            .response;
        final activityItem = activityItemResponse.data as ActivityItem;
        final scheduleActivityItem = ScheduleActivityItem(
          schedule: model,
          activityItem: activityItem,
        );
        final scheduleActivityItemRequest = ModelMutations.create(scheduleActivityItem);
        final scheduleActivityItemResponse = await Amplify.API.mutate(request: scheduleActivityItemRequest).response;
        final createdScheduleActivityItem = scheduleActivityItemResponse.data;
        if (createdScheduleActivityItem == null) {
          safePrint('errors: ${scheduleActivityItemResponse.errors}');
          return;
        }
        safePrint('Mutation result: ${createdScheduleActivityItem.id}');
      }


      final createdSchedule = response.data;
      if (createdSchedule == null) {
        safePrint('errors: ${response.errors}');
        return;
      }
      safePrint('Mutation result: ${createdSchedule.id}');
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }

  /* 지역 데이터 가져오기 */
  Future<List<LocationModel>> getLocationList() async {
    try {

      var operation = Amplify.API.query(
        request: GraphQLRequest(document: GraphQlQueries.getLocationList),
      );
      var response = await operation.response;
      var data = json.decode(response.data);

      List<LocationModel> locationList = [];

      await data['listLocations']['items'].forEach((element) async {
        LocationModel location = LocationModel.fromJson(element);
        locationList.add(location);
      });

      return locationList;

    } on ApiException catch (e) {
      safePrint('Query failed: $e');
    }
   return [];
  }

  /*AcitivtyCategory with ActivityItem*/

  Future<List<ActivityCategoryModel>> getActivityCatWithItems() async {
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
            document: GraphQlQueries.getActivityCategoryWithItems),
      );
      var response = await operation.response;
      var data = json.decode(response.data);

      List<ActivityCategoryModel> activityCatList = [];

      await data['listActivityCategories']['items'].forEach((element) async {
        ActivityCategoryModel activityCat =
            ActivityCategoryModel.fromJson(element);

        List<ActivityItemModel> activityItemList = [];

        element['activityItems']['items'].forEach((item) {
          ActivityItemModel activityItem = ActivityItemModel.fromJson(item);
          activityItemList.add(activityItem);
        });

        activityCatList.add(
          ActivityCategoryModel(
            id: activityCat.id,
            titleKR: activityCat.titleKR,
            activityItems: activityItemList,
          ),
        );
      });

      return activityCatList;
    } catch (e) {
      rethrow;
    }
  }

  /* Activity 데이터 가져오기 */
  Future<List<ActivityCategory?>> getActivityCatList() async {
    try {
      final request = ModelQueries.list(ActivityCategory.classType);
      final response = await Amplify.API.query(request: request).response;

      final items = response.data?.items;
      if (items == null) {
        safePrint('errors: ${response.errors}');
        return <ActivityCategory?>[];
      }
      return items;
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
    }
    return <ActivityCategory?>[];
  }

  /* ActivityItem 데이터 가져오기 */
  Future<List<ActivityItem?>> getActivityItemList() async {
    try {
      final request = ModelQueries.list(ActivityItem.classType);
      final response = await Amplify.API.query(request: request).response;

      final items = response.data?.items;
      if (items == null) {
        safePrint('errors: ${response.errors}');
        return <ActivityItem?>[];
      }
      return items;
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
    }
    return <ActivityItem?>[];
  }

  Future<void> createActivityItem(
      {required String name,
      required String emoji,
      required String titleKR,
      required String category}) async {
    final String categoryID = category;

    try {
      final categoryResponse = await Amplify.API
          .query(
              request: ModelQueries.get(ActivityCategory.classType, categoryID))
          .response;
      final model = ActivityItem(
          name: name,
          titleKR: titleKR,
          emoji: emoji,
          activityCategory: categoryResponse.data as ActivityCategory);
      final request = ModelMutations.create(model);
      final response = await Amplify.API.mutate(request: request).response;

      final createdActivityItem = response.data;
      if (createdActivityItem == null) {
        safePrint('errors: ${response.errors}');
        return;
      }
      safePrint('Mutation result: ${createdActivityItem.id}');
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }

  Future<void> createLocationItem(
      {required String name,
      required String titleEN,
      required String titleKR}) async {
    const String provinceId = "6f490f64-6d04-4a5f-8de9-d0eb09f477cb";

    try {
      final provinceResponse = await Amplify.API
          .query(request: ModelQueries.get(Province.classType, provinceId))
          .response;
      final model = Location(
          name: name,
          titleEN: titleEN,
          titleKR: titleKR,
          province: provinceResponse.data as Province);
      final request = ModelMutations.create(model);
      final response = await Amplify.API.mutate(request: request).response;

      final createdLocation = response.data;
      if (createdLocation == null) {
        safePrint('errors: ${response.errors}');
        return;
      }
      safePrint('Mutation result: ${createdLocation.id}');
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }
}
