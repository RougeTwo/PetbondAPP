
class CharityAdvertPetModel {
  final int? pet_id;
  final String? name;
  final int? price;
  final String? color;
  final String? photo;
  final String? chip_number;
  final String? gender;

  CharityAdvertPetModel({
    this.pet_id,
    this.name,
    this.price,
    this.color,
    this.photo,
    this.chip_number,
    this.gender,
  });

  factory CharityAdvertPetModel.fromJson(Map<String, dynamic> json) {
    return CharityAdvertPetModel(
      pet_id: json['pet_id'],
      name: json['name'],
      price: json['price'],
      color: json['color'],
      photo: json['photo'],
      chip_number: json['chip_number'],
      gender: json['gender'],
    );
  }
}
