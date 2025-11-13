class BreedListModel {
  final int id;
  final String name;

  BreedListModel({
    required this.id,
    required this.name,
  });

  factory BreedListModel.fromJson(Map<String, dynamic> json) {
    return BreedListModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
