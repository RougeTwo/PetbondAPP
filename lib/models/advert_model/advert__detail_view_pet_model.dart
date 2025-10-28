class AdvertDetailViewPetModel {
  int? pet_id;
  String? name;
  dynamic? price;
  String? color;
  String? photo;
  String? chip_number;
  String? pet_verified_by;
  String? gender;

  AdvertDetailViewPetModel({
    this.pet_id,
    this.name,
    this.price,
    this.color,
    this.photo,
    this.chip_number,
    this.pet_verified_by,
    this.gender,
  });

  factory AdvertDetailViewPetModel.fromJson(Map<String, dynamic> json) {
    return AdvertDetailViewPetModel(
      pet_id: json['pet_id'],
      name: json['name'],
      price: json['price'],
      color: json['color'],
      photo: json['photo'],
      chip_number: json['chip_number'],
      pet_verified_by: json['pet_verified_by'],
      gender: json['gender'] != null
          ? json['gender'].toString()[0].toUpperCase() +
              json['gender'].substring(1)
          : null,
    );
  }
}
