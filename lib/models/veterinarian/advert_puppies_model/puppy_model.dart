import 'package:flutter/material.dart';
import 'package:petbond_uk/models/veterinarian/advert_puppies_model/puppy_verification_model.dart';

class PuppyModel {
  final int? id;
  final String? name;
  final String? chip_number;
  final VetVerificationModel? vet_pet_verification;

  PuppyModel({
    this.id,
    this.name,
    this.chip_number,
    this.vet_pet_verification,
  });

  factory PuppyModel.fromJson(Map<String, dynamic> json) {
    return PuppyModel(
      id: json['id'],
      name: json['name'],
      chip_number: json['chip_number'],
      vet_pet_verification: json['vet_pet_verification'] != null
          ? VetVerificationModel.fromJson(json['vet_pet_verification'])
          : null,
    );
  }
}
