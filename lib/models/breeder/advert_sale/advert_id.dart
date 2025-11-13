import 'package:flutter/material.dart';
class AdvertIdModel {
  final int? advert_id;

  AdvertIdModel({
    this.advert_id,
  });

  factory AdvertIdModel.fromJson(Map<String, dynamic> json) {
    return AdvertIdModel(
      advert_id: json['advert_id'],
    );
  }
}
