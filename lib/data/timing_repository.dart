import 'package:amplify_api/model_mutations.dart';
import 'package:amplify_api/model_queries.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:timing/models/ModelProvider.dart';

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
  Future<void> createSchedule() async {
    /*필요한것 :
    *  1. User 객체
    *  2. Location 객체
    *  3. Activity 객체
    * 각각의 객체들은 Schedule을 생성할때 한번에 가져와야 할까?*/

    /*Location, */

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
  Future<List<Location?>> getLocationList() async {
    try {
      final request = ModelQueries.list(Location.classType);
      final response = await Amplify.API.query(request: request).response;

      final items = response.data?.items;
      if (items == null) {
        safePrint('errors: ${response.errors}');
        return <Location?>[];
      }
      return items;
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
    }
    return <Location?>[];
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
}
