class VetViewDetailModel {
  final String? rcvs_number;
  final String? practice_name;
  final String? fb_url;
  final String? insta_url;

  VetViewDetailModel({
    this.rcvs_number,
    this.practice_name,
    this.fb_url,
    this.insta_url,
  });

  factory VetViewDetailModel.fromJson(Map<String, dynamic> json) {
    return VetViewDetailModel(
      rcvs_number: json['rcvs_number'],
      practice_name: json['practice_name'],
      fb_url: json['fb_url'],
      insta_url: json['insta_url'],
    );
  }
}
