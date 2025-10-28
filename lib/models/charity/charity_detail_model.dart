class CharityViewDetailModel {
  final String? charity_number;
  final String? charity_name;
  final String? kenney_club;
  final String? bio;

  CharityViewDetailModel({
    this.charity_number,
    this.charity_name,
    this.kenney_club,
    this.bio,
  });

  factory CharityViewDetailModel.fromJson(Map<String, dynamic> json) {
    return CharityViewDetailModel(
      charity_number: json['charity_number'] ?? null,
      charity_name: json['charity_name'] ?? null,
      kenney_club: json['kenney_club'] ?? null,
      bio: json['bio'] ?? null,
    );
  }
}
