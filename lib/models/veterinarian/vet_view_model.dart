import 'package:petbond_uk/models/veterinarian/vet_view_detail_model.dart';

class VetViewModel {
  final String first_name;
  final String last_name;
  final String email;
  final String phone_number;
  final String address;
  final dynamic lat;
  final dynamic long;
  final String postal_code;
  final String? avatar;
  final int city_id;
  final VetViewDetailModel detail;

  VetViewModel({
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.phone_number,
    required this.address,
    required this.lat,
    required this.long,
    required this.postal_code,
    this.avatar,
    required this.city_id,
    required this.detail,
  });

  factory VetViewModel.fromJson(Map<String, dynamic> json) {
    return VetViewModel(
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
      detail: VetViewDetailModel.fromJson(json['detail']),
    );
  }
}
