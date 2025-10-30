class SaleMicroChipModel {
  final int? id;
  final int? breed_id;
  final String? chip_number;
  final BreedModel? breed;

  SaleMicroChipModel({
    this.id,
    this.breed_id,
    this.chip_number,
    this.breed,
  });

  factory SaleMicroChipModel.fromJson(Map<String, dynamic> json) {
    return SaleMicroChipModel(
      id: json['id'],
      breed_id: json['breed_id'],
      chip_number: json['chip_number'],
      breed: json.containsKey('breed') && json['breed'] != null
          ? BreedModel.fromJson(json['breed'])
          : null,
    );
  }
}

class BreedModel {
  final int? id;
  final String? name;

  BreedModel({
    this.id,
    this.name,
  });

  factory BreedModel.fromJson(Map<String, dynamic> json) {
    return BreedModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
