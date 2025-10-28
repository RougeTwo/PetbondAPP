class ViewDetailModel {
  final String? proof_of_address;
  final String? local_council;
  final String? reg_number;
  final String? kenney_club;
  final String? bio;

  ViewDetailModel({
    this.proof_of_address,
    this.local_council,
    this.reg_number,
    this.kenney_club,
    this.bio,
  });

  factory ViewDetailModel.fromJson(Map<String, dynamic> json) {
    return ViewDetailModel(
      proof_of_address: json.containsKey('proof_of_address')
          ? json['proof_of_address']
          : null,
      local_council: json['local_council'] ?? null,
      reg_number: json['reg_number'] ?? null,
      kenney_club: json['kenney_club'] ?? null,
      bio: json['bio'] ?? null,
    );
  }
}
