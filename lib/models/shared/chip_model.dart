import 'package:flutter/material.dart';
class ChipListModel {
  final String chip_number;

  ChipListModel({
    required this.chip_number,
  });

  factory ChipListModel.fromJson(Map<String, dynamic> json) {
    return ChipListModel(
      chip_number: json['chip_number'],
    );
  }
}
