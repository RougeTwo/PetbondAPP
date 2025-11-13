import 'package:flutter/material.dart';
class SaleCommissionTaxModel {
  dynamic commissionInPercent;
  dynamic taxInPercent;

  SaleCommissionTaxModel({this.commissionInPercent, this.taxInPercent});

  factory SaleCommissionTaxModel.fromJson(Map<String, dynamic> json) {
    return SaleCommissionTaxModel(
        commissionInPercent: json['commission_in_percent'],
        taxInPercent: json['tax_in_percent']);
  }
}
