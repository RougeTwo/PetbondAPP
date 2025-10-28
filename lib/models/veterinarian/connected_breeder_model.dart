class ConnectedBreederModel {
  final int? id;
  final String? first_name;
  final String? last_name;
  final String? email;
  final String? phone_number;

  ConnectedBreederModel({
    this.id,
    this.first_name,
    this.last_name,
    this.email,
    this.phone_number,
  });

  factory ConnectedBreederModel.fromJson(Map<String, dynamic> json) {
    return ConnectedBreederModel(
      id: json['id'] ?? null,
      first_name: json['first_name'] ?? null,
      last_name: json['last_name'] ?? null,
      email: json['email'] ?? null,
      phone_number: json['phone_number'] ?? null,
    );
  }
}
