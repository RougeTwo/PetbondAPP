import 'package:flutter/material.dart';
import 'package:petbond_uk/models/breeder/view_detail_model.dart';

class ViewModel {
  final String first_name;
  final String last_name;
  final String email;
  final String phone_number;
  String? address;
  String? postal_code;
  final String? avatar;
  final dynamic lat;
  final dynamic long;
  int? city_id;
  final ViewDetailModel? detail;

  ViewModel({
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

  factory ViewModel.fromJson(Map<String, dynamic> json) {
    return ViewModel(
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
      phone_number: json['phone_number'],
      address: json['address'],
      lat: json['lat'],
      long: json['long'],
      postal_code: json['postal_code'],
      city_id: json['city_id'],
      avatar: json['avatar'],
      detail: json.containsKey('detail') && json['detail'] != null
          ? ViewDetailModel.fromJson(json['detail'])
          : null,
    );
  }
}
