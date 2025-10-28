class SaleAdvertsModel {
  final String? advert_name;
  final String? mother_name;
  final String? father_name;
  final String? dob;

  SaleAdvertsModel({
    this.advert_name,
    this.mother_name,
    this.father_name,
    this.dob,
  });

  factory SaleAdvertsModel.fromJson(Map<String, dynamic> json) {
    return SaleAdvertsModel(
      advert_name: json['advert_name'] ?? null,
      mother_name: json['mother_name'] ?? null,
      father_name: json['father_name'] ?? null,
      dob: json['dob'] ?? null,
    );
  }
}
