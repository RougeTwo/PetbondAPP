class AdvertsModel {
  final int? id;
  final String? name;

  AdvertsModel({
    this.id,
    this.name,
  });

  factory AdvertsModel.fromJson(Map<String, dynamic> json) {
    return AdvertsModel(
      id: json['id'] ?? null,
      name: json['name'] ?? null,
    );
  }
}