class LocationModel {
  final String id;
  final String name;
  final String titleKR;

  LocationModel({required this.id, required this.name, required this.titleKR});

  LocationModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        titleKR = json['titleKR'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'titleKR': titleKR,
  };
}
