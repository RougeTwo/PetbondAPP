import 'package:flutter/material.dart';

import 'charity_detail_model.dart';

class CharityViewModel {
  final String first_name;
  final String last_name;
  final String email;
  final String phone_number;
  String? address;
  String? postal_code;
  final String? avatar;
  int? city_id;
  final dynamic lat;
  final dynamic long;
  final CharityViewDetailModel? detail;

  CharityViewModel({
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.phone_number,
    this.address,
    required this.lat,
    required this.long,
    this.postal_code,
    this.avatar,
    this.city_id,
    this.detail,
  });

  factory CharityViewModel.fromJson(Map<String, dynamic> json) {
    return CharityViewModel(
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
      phone_number: json['phone_number'],
      lat: json['lat'],
      long: json['long'],
      address: json['address'],
      postal_code: json['postal_code'],
      city_id: json['city_id'],
      avatar: json['avatar'],
      detail: json.containsKey('detail') && json['detail'] != null
          ? CharityViewDetailModel.fromJson(json['detail'])
          : null,
    );
  }
}
