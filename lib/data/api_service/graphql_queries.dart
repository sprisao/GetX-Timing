class GraphQlQueries {
  static const String getLocationList = '''
    query MyQuery {
      listLocations {
        items {
          id
          name
          titleKR
        }
      }
    }
    ''';

  static const String getActivityCategoryWithItems = '''
      query MyQuery {
      listActivityCategories {
        items {
          id
          titleKR
          name
          activityItems {
            items {
              emoji
              id
              titleKR
            }
          }
        }
      }
    }
    ''';

  static const String getScheduleByUserID = '''
  query MyQuery(\$userID: ID!) {
  schedulesByUserID(userID: \$userID) {
    items{
      id
      date
      startTime
      endTime
      privacy
      locationList
      activityItemList
    }
  }
}
''';
}
