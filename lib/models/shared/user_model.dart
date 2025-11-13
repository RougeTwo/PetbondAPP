class UserModel {
  final int? id;
  final String? firstName;

  UserModel({this.id, this.firstName});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['first_name'],
    );
  }
}
