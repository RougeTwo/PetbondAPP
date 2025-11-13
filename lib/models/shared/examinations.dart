import 'package:flutter/material.dart';
class ExaminationModel {
  final int id;
  final String name;
  final String icon;

  ExaminationModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory ExaminationModel.fromJson(Map<String, dynamic> json) {
    return ExaminationModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }
}
