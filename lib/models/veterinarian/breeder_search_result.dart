import 'package:flutter/material.dart';
class SearchResultModel {
  final int? id;
  final String? first_name;
  final String? last_name;
  final String? email;
  final String? phone_number;

  SearchResultModel({
    this.id,
    this.first_name,
    this.last_name,
    this.email,
    this.phone_number,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
      phone_number: json['phone_number'],
    );
  }
}
