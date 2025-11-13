class PetModel {
  final dynamic price;

  PetModel({this.price});

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      price: json['price'],
    );
  }
}
