import 'package:petbond_uk/core/utils/base_url.dart';

class VetVerificationModel {
  final int? id;
  final int? user_id;
  final int? pet_id;
  final String? chip_number;
  final List? certificate_details;
  final NoteModel? note;

  VetVerificationModel({
    this.id,
    this.user_id,
    this.pet_id,
    this.note,
    this.chip_number,
    this.certificate_details,
  });

  factory VetVerificationModel.fromJson(Map<String, dynamic> json) {
    // List list = json['certificate_details'];
    // List<String> listOfString = [];
    // list.forEach((element) {
    //   listOfString.add(element as String);
    // });
    //     .map((imagePath) => BaseUrl.getImageBaseUrl() + imagePath)
    //     .toList());
    return VetVerificationModel(
      id: json['id'],
      user_id: json['user_id'],
      pet_id: json['pet_id'],
      chip_number: json['chip_number'],
      certificate_details: json.containsKey('certificate_details') &&
              json['certificate_details'].length > 0
          ? json['certificate_details']
              .map((imagePath) => BaseUrl.getImageBaseUrl() + imagePath)
              .toList()
          : [],
      note: NoteModel.fromJson(json['note']),
    );
  }
}

class NoteModel {
  String? note;
  String? physical_defect;
  String? significance;

  NoteModel({
    this.note,
    this.physical_defect,
    this.significance,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      note: json['note'],
      physical_defect: json['physical_defect'],
      significance: json['significance'],
    );
  }
}
