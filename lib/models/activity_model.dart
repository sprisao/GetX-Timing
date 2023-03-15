class ActivityCategoryModel {
  final String id;
  final String titleKR;
  final List<ActivityItemModel> activityItems;

  ActivityCategoryModel(
      {required this.id, required this.titleKR, required this.activityItems});

  ActivityCategoryModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        titleKR = json['titleKR'],
        activityItems = [] {
    if (json['activityItems'] != null) {
      json['activityItems']['items'].forEach(
        (item) {
          if (item['_deleted'] == null) {
            return activityItems.add(ActivityItemModel.fromJson(item));
          }
        },
      );
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': titleKR,
        'activityItems': activityItems.toString(),
      };
}

class ActivityItemModel {
  final String id;
  final String emoji;
  final String titleKR;

  ActivityItemModel(
      {required this.id, required this.emoji, required this.titleKR});

  ActivityItemModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        emoji = json['emoji'],
        titleKR = json['titleKR'];
}
