import 'package:petbond_uk/models/veterinarian/advert_puppies_model/puppy_model.dart';

class AdvertPuppiesModel {
  final int? id;
  final List<PuppyModel>? pets;

  AdvertPuppiesModel({
    this.id,
    this.pets,
  });

  factory AdvertPuppiesModel.fromJson(Map<String, dynamic> json) {
    return AdvertPuppiesModel(
      id: json['id'],
      pets: json.containsKey('pets') && json['pets'].length > 0
          ? json['pets']
              .map<PuppyModel>((puppyModel) => PuppyModel.fromJson(puppyModel))
              .toList()
          : [],
    );
  }
}
