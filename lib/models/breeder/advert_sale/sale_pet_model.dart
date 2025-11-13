import 'package:petbond_uk/models/breeder/advert_sale/sale_adverts_model.dart';
import 'package:petbond_uk/models/breeder/advert_sale/sale_microchip_model.dart';

class SalePetModel {
  final int? id;
  final String? name;
  final String? photo;
  final int? micro_chip_id;
  final List<SaleAdvertsModel>? adverts;
  final SaleMicroChipModel? micro_chip;

  SalePetModel({
    this.id,
    this.name,
    this.photo,
    this.micro_chip_id,
    this.adverts,
    this.micro_chip,
  });

  factory SalePetModel.fromJson(Map<String, dynamic> json) {
    return SalePetModel(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      micro_chip_id: json['micro_chip_id'],
      adverts: json.containsKey('adverts') && json['adverts'].length > 0
          ? json['adverts']
              .map<SaleAdvertsModel>(
                  (petModel) => SaleAdvertsModel.fromJson(petModel))
              .toList()
          : [],
      micro_chip: json.containsKey('micro_chip') && json['micro_chip'] != null
          ? SaleMicroChipModel.fromJson(json['micro_chip'])
          : null,
    );
  }
}
