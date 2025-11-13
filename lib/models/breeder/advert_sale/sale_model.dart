
import 'package:petbond_uk/models/breeder/advert_sale/sale_pet_model.dart';

class AdvertSale {
  final int? id;
  final int? pet_id;
  final String? type;
  final dynamic remaining_amount;
  final SalePetModel? pet;
  final TransactionModel? total_transactions_price;

  AdvertSale({
    this.id,
    this.pet_id,
    this.type,
    this.remaining_amount,
    this.pet,
    this.total_transactions_price,
  });

  factory AdvertSale.fromJson(Map<String, dynamic> json) {
    return AdvertSale(
      id: json['id'],
      pet_id: json['pet_id'],
      type: json['type'],
      remaining_amount: json['remaining_amount'],
      pet: json.containsKey('pet') && json['pet'] != null
          ? SalePetModel.fromJson(json['pet'])
          : null,
      total_transactions_price: json.containsKey('total_transactions_price') && json['total_transactions_price'] != null
        ? TransactionModel.fromJson(json['total_transactions_price'])
        : null,
    );
  }
}
class TransactionModel {
  final int? order_id;
  final dynamic total_amount;

  TransactionModel({
    this.order_id,
    this.total_amount,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      order_id: json['order_id'],
      total_amount: json['total_amount'],
    );
  }
}
