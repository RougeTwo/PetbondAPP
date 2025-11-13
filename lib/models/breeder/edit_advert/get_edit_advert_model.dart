import 'package:petbond_uk/core/utils/base_url.dart';

import 'edit_advert_pets.dart';

class GetEditAdvertModel {
  final int? id;
  final int? user_id;
  final String? description;
  final String? cover_photo;
  final String? mother_name;
  final String? father_name;
  final String? dob;
  final String? advert_name;
  final String? chip_number;
  final int? breed_id;
  final List<EditAdvertPetModel>? pets;
  final TestResportDetail? test_report_detail;
  final List<EditAdvertMotherExamination>? mother_advert_examinations;
  final List<EditAdvertFatherExamination>? father_advert_examinations;

  GetEditAdvertModel({
    this.id,
    this.user_id,
    this.description,
    this.cover_photo,
    this.mother_name,
    this.father_name,
    this.dob,
    this.advert_name,
    this.chip_number,
    this.breed_id,
    this.pets,
    this.test_report_detail,
    this.mother_advert_examinations,
    this.father_advert_examinations,
  });

  factory GetEditAdvertModel.fromJson(Map<String, dynamic> json) {
    return GetEditAdvertModel(
      id: json['id'],
      user_id: json['user_id'],
      description: json['description'],
      cover_photo: json['cover_photo'],
      mother_name: json['mother_name'],
      father_name: json['father_name'],
      dob: json['dob'],
      advert_name: json['advert_name'],
      chip_number: json['chip_number'].contains(RegExp(r'[a-z]'))
          ? null
          : json['chip_number'],
      breed_id: json['breed_id'],
      pets: json.containsKey('pets') && json['pets'].length > 0
          ? json['pets']
              .map<EditAdvertPetModel>(
                  (petModel) => EditAdvertPetModel.fromJson(petModel))
              .toList()
          : [],
      test_report_detail: json['test_report_detail'] != null
          ? TestResportDetail.fromJson(json['test_report_detail'])
          : null,
      mother_advert_examinations: json
                  .containsKey('mother_advert_examinations') &&
              json['mother_advert_examinations'].length > 0
          ? json['mother_advert_examinations']
              .map<EditAdvertMotherExamination>(
                  (petModel) => EditAdvertMotherExamination.fromJson(petModel))
              .toList()
          : [],
      father_advert_examinations: json
                  .containsKey('father_advert_examinations') &&
              json['father_advert_examinations'].length > 0
          ? json['father_advert_examinations']
              .map<EditAdvertFatherExamination>(
                  (petModel) => EditAdvertFatherExamination.fromJson(petModel))
              .toList()
          : [],
    );
  }
}

class TestResportDetail {
  final List father_reports;
  final List mother_reports;

  TestResportDetail({
    required this.father_reports,
    required this.mother_reports,
  });

  factory TestResportDetail.fromJson(Map<String, dynamic> json) {
    return TestResportDetail(
      father_reports: json.containsKey('father_reports') &&
              json['father_reports'].length > 0
          ? json['father_reports']
              .map((imagePath) => BaseUrl.getImageBaseUrl() + imagePath)
              .toList()
          : [],
      mother_reports: json.containsKey('mother_reports') &&
              json['mother_reports'].length > 0
          ? json['mother_reports']
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
