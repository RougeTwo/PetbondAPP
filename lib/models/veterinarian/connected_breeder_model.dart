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
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
      phone_number: json['phone_number'],
    );
  }
}
