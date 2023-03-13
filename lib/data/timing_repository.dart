import 'package:amplify_api/model_mutations.dart';
import 'package:amplify_api/model_queries.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import '../models/ActivityCategory.dart';
import '../models/User.dart';

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
    try {
      final userAttributes = await Amplify.Auth.fetchUserAttributes();
      for (final element in userAttributes) {
        if (element.userAttributeKey.toString() == "email") {
          final userEmail = element.value;
          final user = User(email: userEmail);

          final userDataRequest = ModelQueries.list(User.classType,
              where: User.EMAIL.eq(userEmail));
          final userDataResponse =
          await Amplify.API.query(request: userDataRequest).response;

          if (userDataResponse.data?.items.isEmpty ?? true) {
            final userCreateRequest = ModelMutations.create(user);
            final response =
            await Amplify.API.mutate(request: userCreateRequest).response;
            final createdUser = response.data;
            if (createdUser == null) {
              safePrint('errors: ${response.errors}');
              return;
            }
            safePrint('Mutation result: ${createdUser.id}');
          }
        }
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }

  /*Get ActivityCategory-lists*/

  Future<void> getActivityCategoryList() async {
    final request = ModelQueries.list(ActivityCategory.classType);
    try {
      final response = await Amplify.API.query(request: request).response;
      final activityCategoryList = response.data?.items;
      safePrint('Query result: $activityCategoryList');
      if (activityCategoryList == null) {
        safePrint('errors: ${response.errors}');
        return;
      }
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
    }
  }
}