import 'package:petbond_uk/models/breeder/advert/pet.dart';

class AdvertModel {
  final int? id;
  final String? advert_name;
  final String? name;
  final String? status;
  final String? cover_photo;
  final String? mother_name;
  final String? father_name;
  final String? dob;
  final String? advert_url;
  final dynamic price;
  final int? pet_count;
  final int? sold_count;
  final List<PetModel>? pets;

  AdvertModel({
    this.id,
    this.advert_name,
    this.name,
    this.status,
    this.cover_photo,
    this.mother_name,
    this.father_name,
    this.advert_url,
    this.dob,
    this.price,
    this.pet_count,
    this.sold_count,
    this.pets,
  });

  factory AdvertModel.fromJson(Map<String, dynamic> json) {
    return AdvertModel(
      id: json['id'],
      advert_name: json['advert_name'],
      name: json['name'],
      status: json['status'],
      cover_photo: json['cover_photo'],
      mother_name: json['mother_name'],
      father_name: json['father_name'],
      dob: json['dob'],
      advert_url: json['advert_url'],
      price: json['price'],
      pet_count: json['pet_count'],
      sold_count: json['sold_count'],
      pets: json.containsKey('pets') && json['pets'].length > 0
          ? json['pets']
              .map<PetModel>((petModel) => PetModel.fromJson(petModel))
              .toList()
          : [],
    );
  }
}
