
import 'edit_pet_details.dart';

class CharityAdvertEditModel {
  final int? id;
  final int? user_id;
  final int? breed_id;
  final String? description;
  final String? cover_photo;
  final String? chip_number;
  final String? advert_name;
  final List<CharityAdvertPetModel>? pets;

  CharityAdvertEditModel({
    this.id,
    this.user_id,
    this.breed_id,
    this.description,
    this.cover_photo,
    this.chip_number,
    this.advert_name,
    this.pets,
  });

  factory CharityAdvertEditModel.fromJson(Map<String, dynamic> json) {
    return CharityAdvertEditModel(
      id: json['id'],
      user_id: json['user_id'],
      breed_id: json['breed_id'],
      description: json['description'],
      chip_number: json['chip_number'],
      cover_photo: json['cover_photo'],
      advert_name: json['advert_name'],
      pets: json.containsKey('pets') && json['pets'].length > 0
          ? json['pets']
              .map<CharityAdvertPetModel>(
                  (petModel) => CharityAdvertPetModel.fromJson(petModel))
              .toList()
          : [],
    );
  }
}
