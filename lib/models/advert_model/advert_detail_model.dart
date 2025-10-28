import 'package:petbond_uk/models/breeder/edit_advert/edit_advert_pets.dart';
import '../breeder/view_detail_model.dart';
import 'advert__detail_view_pet_model.dart';

class AdvertDetailViewModel {
  final int? id;
  final int? user_id;
  final String? description;
  final String? cover_photo;
  final String? mother_name;
  final String? father_name;
  final String? dob;
  final String? advert_name;
  final String? name;
  final String? chip_number;
  final String? energy;
  final String? energy_desc;
  final String? size;
  final String? size_desc;
  final String? life_span;
  final String? life_span_desc;
  final String? grooming;
  final String? grooming_desc;
  final String? living_space;
  final String? living_space_desc;
  final List<AdvertViewMotherExamination>? mother_examinations;
  final List<AdvertDetailViewPetModel>? pets;
  final AdvertViewUserModel? user;

  AdvertDetailViewModel(
      {this.id,
      this.user_id,
      this.description,
      this.cover_photo,
      this.mother_name,
      this.father_name,
      this.dob,
      this.advert_name,
      this.name,
      this.chip_number,
      this.energy,
      this.energy_desc,
      this.size,
      this.size_desc,
      this.life_span,
      this.life_span_desc,
      this.grooming,
      this.grooming_desc,
      this.mother_examinations,
      this.living_space,
      this.living_space_desc,
      this.pets,
      this.user});

  factory AdvertDetailViewModel.fromJson(Map<String, dynamic> json) {
    return AdvertDetailViewModel(
      id: json['id'],
      user_id: json['user_id'],
      description: json['description'],
      cover_photo: json['cover_photo'],
      mother_name: json['mother_name'],
      father_name: json['father_name'],
      dob: json['dob'],
      advert_name: json['advert_name'],
      name: json['name'],
      chip_number: json['chip_number'],
      energy: json['energy'],
      energy_desc: json['energy_desc'],
      size: json['size'],
      size_desc: json['size_desc'],
      life_span: json['life_span'],
      life_span_desc: json['life_span_desc'],
      grooming: json['grooming'],
      grooming_desc: json['grooming_desc'],
      living_space: json['living_space'],
      living_space_desc: json['living_space_desc'],
      mother_examinations: json.containsKey('mother_examinations') &&
              json['mother_examinations'].length > 0
          ? json['mother_examinations']
              .map<AdvertViewMotherExamination>(
                  (petModel) => AdvertViewMotherExamination.fromJson(petModel))
              .toList()
          : [],
      pets: json.containsKey('pets') && json['pets'].length > 0
          ? json['pets']
              .map<AdvertDetailViewPetModel>(
                  (petModel) => AdvertDetailViewPetModel.fromJson(petModel))
              .toList()
          : [],
      user: json['user'] != null
          ? AdvertViewUserModel.fromJson(json['user'])
          : null,
    );
  }
}

class AdvertViewUserModel {
  int? id;
  int? city_id;
  final String? first_name;
  final String? last_name;
  final String? email;
  final String? role;
  final String? avatar;
  final String? proof_of_address;
  final String? license_number;
  final String? reg_number;
  final String? kenney_club;
  final String? bio;
  //
  // final ViewDetailModel? detail;
  final AdvertViewCityModel? city;

  AdvertViewUserModel({
    this.id,
    this.first_name,
    this.last_name,
    this.email,
    this.role,
    this.avatar,
    this.city_id,
    this.proof_of_address,
    this.license_number,
    this.reg_number,
    this.kenney_club,
    this.bio,
    // this.detail,
    this.city,
  });

  factory AdvertViewUserModel.fromJson(Map<String, dynamic> json) {
    return AdvertViewUserModel(
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
      role: json['role'],
      city_id: json['city_id'] ?? null,
      avatar: json['avatar'] ?? null,
      proof_of_address: json['proof_of_address'] ?? null,
      license_number: json['license_number'] ?? null,
      reg_number: json['reg_number'] ?? null,
      kenney_club: json['kenney_club'] ?? null,
      bio: json['bio'] ?? null,
      // detail: json.containsKey('detail') && json['detail'] != null
      //     ? ViewDetailModel.fromJson(json['detail'])
      //     : null,
      city: json.containsKey('city') && json['city'] != null
          ? AdvertViewCityModel.fromJson(json['city'])
          : null,
    );
  }
}

class AdvertViewCityModel {
  final String? name;
  int? city_id;

  AdvertViewCityModel({
    this.name,
    this.city_id,
  });

  factory AdvertViewCityModel.fromJson(Map<String, dynamic> json) {
    return AdvertViewCityModel(
      name: json['name'],
      city_id: json['city_id'],
    );
  }
}

class AdvertViewMotherExamination {
  final int? id;
  final String? name;
  final String? icon;

  AdvertViewMotherExamination({
    this.id,
    this.name,
    this.icon,
  });

  factory AdvertViewMotherExamination.fromJson(Map<String, dynamic> json) {
    return AdvertViewMotherExamination(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }
}
