import 'package:petbond_uk/core/utils/base_url.dart';
import 'package:image_picker/image_picker.dart';

class EditAdvertPetModel {
  bool? isNew;
  int? pet_id, index;
  String? name;
  dynamic? price;
  dynamic commision;
  String? color;
  String? photo;
  String? chip_number;
  String? gender;
  List? certificate_details;
  XFile? puppyPhoto;
  List<XFile?> newCertificateList = [];
  List<String> deletePuppiesImages = [];
  XFile? certificateImage;

  EditAdvertPetModel(
      {this.pet_id,
      this.name,
      this.price,
      this.commision,
      this.color,
      this.photo,
      this.chip_number,
      this.gender,
      this.certificate_details});

  factory EditAdvertPetModel.fromJson(Map<String, dynamic> json) {
    return EditAdvertPetModel(
      pet_id: json['pet_id'],
      name: json['name'] ?? "",
      price: json['price'],
      color: json['color'] ?? "",
      photo: json['photo'],
      chip_number: json['chip_number'].contains(RegExp(r'[a-z]'))
          ? null
          : json['chip_number'],
      gender: json.containsKey('gender') && json['gender'] != null
          ? json['gender'].toString()[0].toUpperCase() +
              json['gender'].substring(1)
          : null,
      certificate_details: json.containsKey('certificate_detail') &&
              json['certificate_detail'] != null
          ? json['certificate_detail']
              .map((imagePath) => BaseUrl.getImageBaseUrl() + imagePath)
              .toList()
          : [],
    );
  }
}

class EditAdvertMotherExamination {
  final int? advert_id;
  final int? examination_id;

  EditAdvertMotherExamination({
    this.advert_id,
    this.examination_id,
  });

  factory EditAdvertMotherExamination.fromJson(Map<String, dynamic> json) {
    return EditAdvertMotherExamination(
      advert_id: json['advert_id'],
      examination_id: json['examination_id'],
    );
  }
}

class EditAdvertFatherExamination {
  final int? advert_id;
  final int? examination_id;

  EditAdvertFatherExamination({
    this.advert_id,
    this.examination_id,
  });

  factory EditAdvertFatherExamination.fromJson(Map<String, dynamic> json) {
    return EditAdvertFatherExamination(
      advert_id: json['advert_id'],
      examination_id: json['examination_id'],
    );
  }
}
