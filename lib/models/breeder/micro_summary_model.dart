import 'package:flutter/material.dart';
class MicroChipSummaryModel {
  final int? id;
  final int? breeding_count;
  final String? chip_number;
  final String? name;

  MicroChipSummaryModel({
    this.id,
    this.chip_number,
    this.breeding_count,
    this.name,
  });

  factory MicroChipSummaryModel.fromJson(Map<String, dynamic> json) {
    return MicroChipSummaryModel(
      id: json['id'],
      chip_number: json['chip_number'],
      breeding_count: json['breeding_count'],
      name: json['name'],
    );
  }
}
