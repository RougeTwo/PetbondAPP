import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:petbond_uk/core/services/base_services.dart';
import 'package:petbond_uk/core/utils/base_url.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:petbond_uk/core/utils/response_model.dart';
import 'package:petbond_uk/core/values/styles.dart';
import 'package:petbond_uk/models/breeder/advert/advert_model.dart';
import 'package:petbond_uk/models/breeder/advert_sale/advert_id.dart';
import 'package:petbond_uk/models/breeder/advert_sale/sale_model.dart';
import 'package:petbond_uk/models/breeder/edit_advert/edit_advert_pets.dart';
import 'package:petbond_uk/models/breeder/edit_advert/get_edit_advert_model.dart';
import 'package:petbond_uk/models/breeder/micro_summary_model.dart';
import 'package:petbond_uk/models/breeder/view_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:petbond_uk/modules/breeder/advertise_pet/advertise_pet_step_two_create.dart';
import 'package:petbond_uk/modules/breeder/advertise_pet/advertise_pet_step_two_update.dart';

class BreederServices extends BaseService {
//--------------------GET BREEDER VIEW API-------------

  Future<ViewModel?> getViewModel({required BuildContext context}) async {
    method = "get";
    context = context;
    ResponseModel _responseModel = await this.request('get_breeder_view');
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      ViewModel viewModel = ViewModel.fromJson(_responseModel.body);
      return viewModel;
    }
    return null;
  }

  //--------------------GET VALIDATE TO GO ON SPECIFIC SELL/EDIT ADVERT STEPS API-------------

  Future<int> getAdvertValidate({required BuildContext context}) async {
    method = "get";
    context = context;
    ResponseModel _responseModel = await request('get_advert_validate');
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      return _responseModel.body['step'];
    }
    return 0;
  }

//--------------------UPDATE BIO API-------------

  Future<void> breederUpdateBioInfo(
      {required String bio,
      String? filepath,
      required BuildContext context,
      required String url}) async {
    EasyLoading.show(
        status: 'loading...', maskType: EasyLoadingMaskType.custom);
    String? jwt = await storage.readStore('token');
    jwt = jwt ?? '';
    Map<String, String> headers = {
      "m-access-key":
          "\$2a\$12\$KECVUQRPLWJvidTm7cbPbOhaZMbKngt.X2RYTB1ctS/PVo7rOGVje",
      "Accept": "application/json",
      'Authorization': 'Bearer ' + jwt,
    };
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);
    if (filepath != null) {
      request.files.add(await http.MultipartFile.fromPath('avatar', filepath));
    }
    request.fields['bio'] = bio;
    var res = await request.send();
    var responed = await http.Response.fromStream(res);
    var responseData = json.decode(responed.body);
    if (responseData['status'] == 200) {
      EasyLoading.showSuccess('Updated Successfully! ');
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } else {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showError(responseData['message'] ?? "Something went wrong");
    }
  }

//--------------------UPDATE ACCOUNT SETTING API-------------

  Future<void> breedUpdateAccountInfo({
    required String first_name,
    required String last_name,
    required String phoneNo,
    required String address,
    required String postalCode,
    required String cityId,
    required String lat,
    required String lng,
    String? filepath,
    required BuildContext context,
  }) async {
    EasyLoading.show(
        status: 'loading...', maskType: EasyLoadingMaskType.custom);
    String? jwt = await storage.readStore('token');
    jwt = jwt ?? '';
    Map<String, String> headers = {
      "m-access-key":
          "\$2a\$12\$KECVUQRPLWJvidTm7cbPbOhaZMbKngt.X2RYTB1ctS/PVo7rOGVje",
      "Accept": "application/json",
      'Authorization': 'Bearer ' + jwt,
    };
    var request = http.MultipartRequest('POST',
        Uri.parse("${BaseUrl.getBaseUrl()}" + "breeder/profile/update"));
    request.headers.addAll(headers);
    if (filepath != null) {
      request.files
          .add(await http.MultipartFile.fromPath('proof_of_address', filepath));
    }

    request.fields['first_name'] = first_name;
    request.fields['last_name'] = last_name;
    request.fields['phone_number'] = phoneNo;
    request.fields['postal_code'] = postalCode;
    request.fields['city_id'] = cityId;
    request.fields['address'] = address;
    request.fields['lat'] = lat;
    request.fields['long'] = lng;
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    var responseData = json.decode(response.body);
    if (responseData['status'] == 200) {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showSuccess(CustomStyles.save_text);
    } else {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showError(responseData['message'] ?? "Something went wrong");
    }
  }

  //--------------------UPDATE LICENCE INFO API-------------

  Future<void> breederUpdateLicenceInfo(
      {required String reg_number,
      required String kenney_club,
      required String local_council,
      required BuildContext context}) async {
    method = 'post';
    Map<String, String> body = {
      'reg_number': reg_number,
      'kenney_club': kenney_club,
      'local_council': local_council,
    };
    this.context = context;
    data = body;
    ResponseModel _responseModel = await this.request("update_license_info");
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      EasyLoading.showSuccess(CustomStyles.save_text);
    }
  }

//--------------------GET CHIP_NUMBER SUMMARY API-------------

  Future<List<MicroChipSummaryModel>> getMicroChipList(
      {required BuildContext context}) async {
    method = "get";
    this.context = context;
    ResponseModel _responseModel = await request('breeder_microchip_summary');
    List<MicroChipSummaryModel> microchipSummaryList = [];
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      microchipSummaryList = _responseModel.body
          .map<MicroChipSummaryModel>(
              (language) => MicroChipSummaryModel.fromJson(language))
          .toList();
      return microchipSummaryList;
    }
    return microchipSummaryList;
  }

  //--------------------GET RECENT LISTED PETS API-------------

  Future<List<AdvertModel>> getRecent({required BuildContext context}) async {
    method = "get";
    this.context = context;
    ResponseModel _responseModel = await request('breeder_recent');
    List<AdvertModel> recentList = [];
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      recentList = _responseModel.body
          .map<AdvertModel>((advert) => AdvertModel.fromJson(advert))
          .toList();
      return recentList;
    }
    return recentList;
  }

  //--------------------GET LISTED PETS API-------------

  Future<List<AdvertModel>> getListedPets(
      {required BuildContext context}) async {
    method = "get";
    this.context = context;
    ResponseModel _responseModel = await request('breeder_listed_pets');
    List<AdvertModel> recentList = [];
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      recentList = _responseModel.body
          .map<AdvertModel>((advert) => AdvertModel.fromJson(advert))
          .toList();
      return recentList;
    }
    return recentList;
  }

  //--------------------GET BREEDER SALE API-------------

  Future<List<AdvertSale>> getSaleList({required BuildContext context}) async {
    method = "get";
    this.context = context;
    ResponseModel _responseModel = await request('breeder_sale');
    List<AdvertSale> saleList = [];
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      saleList = _responseModel.body
          .map<AdvertSale>((advert) => AdvertSale.fromJson(advert))
          .toList();
      return saleList;
    }
    return saleList;
  }

  //--------------------ADD MICROCHIP NUMBER API-------------

  Future<void> breederAddMicroChipInfo(
      {required String chip_number,
      required String breed_id,
      required BuildContext context}) async {
    method = 'post';
    Map<String, String> body = {
      'chip_number': chip_number,
      'breed_id': breed_id,
    };
    this.context = context;
    data = body;
    ResponseModel _responseModel = await request("breeder_microchip_store");
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      EasyLoading.showSuccess('Added Successfully!');
    }
  }

//--------------------UPDATE PASSWORD API-------------

  changePassword(
      {required String oldPassword,
      required String newPassword,
      required String confirmPassword,
      required BuildContext context}) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    method = 'post';
    Map<String, String> body = {
      'current_password': oldPassword,
      'password': newPassword,
      'confirm_password': confirmPassword,
    };
    this.context = context;
    data = body;
    ResponseModel _responseModel = await this.request("change_password");
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      EasyLoading.showSuccess("Password Changed Successfully");
    }
  }

  //---------------DELETE ADVERT API-------------
  Future<String?> deleteAdvertFromList(
      {int? advert_id, required BuildContext context}) async {
    method = 'delete';
    requestUrl = generateURL("delete_advert") + advert_id.toString();
    Map<String, String> body = {};
    this.context = context;
    data = body;
    ResponseModel _responseModel = await request(null);
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      return _responseModel.message;
    }
  }

  //-----------GET BREEDER EDIT ADVERT API-----------------
  Future<GetEditAdvertModel?> getEditAdvertList(
      {required BuildContext context, int? advert_id}) async {
    method = "get";
    requestUrl = generateURL("get_breed_edit_advert") + advert_id.toString();
    this.context = context;
    ResponseModel _responseModel = await request(null);
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      GetEditAdvertModel getEditAdvertModel =
          GetEditAdvertModel.fromJson(_responseModel.body);
      return getEditAdvertModel;
    }
    return null;
  }

  //-----------UPDATE BREEDER ADVERT STEP ONE--------------------

  Future<void> breederUpdateAdvertStepOne(
      {required String bio,
      required String reg_number,
      required String kenney_club,
      required String behaviour,
      String? filepath,
      int? id,
      required BuildContext context,
      required String url}) async {
    EasyLoading.show(
        status: 'loading...', maskType: EasyLoadingMaskType.custom);
    String? jwt = await storage.readStore('token');
    jwt = jwt ?? '';
    Map<String, String> headers = {
      "m-access-key":
          "\$2a\$12\$KECVUQRPLWJvidTm7cbPbOhaZMbKngt.X2RYTB1ctS/PVo7rOGVje",
      "Accept": "application/json",
      'Authorization': 'Bearer ' + jwt,
    };
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);
    if (kenney_club != null) {
      request.fields['kenney_club'] = kenney_club;
    }
    if (bio != null) {
      request.fields['bio'] = bio;
    }
    if (reg_number != null) {
      request.fields['reg_number'] = reg_number;
    }

    var res = await request.send();
    var responed = await http.Response.fromStream(res);
    var responseData = json.decode(responed.body);
    if (responseData['status'] == 200) {
      EasyLoading.showSuccess('Progress saved successfully!');
      // if (behaviour == "create") {
      //   Future.delayed(Duration.zero, () {
      //     Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) =>
      //                 AdvertisePetStepTwoCreate(behaviour: behaviour, id: id)));
      //   });
      // } else if (behaviour == "edit") {
      //   Future.delayed(Duration.zero, () {
      //     Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) =>
      //                 AdvertisePetStepTwoUpdate(behaviour: behaviour, id: id)));
      //   });
      // }
    } else {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showError(responseData['message'] ?? "Something went wrong");
    }
  }

  //-----------CREATE BREEDER ADVERT API-----------------

  Future<AdvertIdModel?> createBreederAdvert({
    required String advert_name,
    required String description,
    required String mother_name,
    required String father_name,
    required String breed_id,
    String? coverImage,
    bool? is_publish,
    required List<File?> mother_reports,
    required List<File?> father_reports,
    required List<String> mother_test,
    required List<String> father_test,
    required BuildContext context,
  }) async {
    EasyLoading.show(
        status: 'loading...', maskType: EasyLoadingMaskType.custom);
    String? jwt = await storage.readStore('token');
    jwt = jwt ?? '';
    Map<String, String> headers = {
      "m-access-key":
          "\$2a\$12\$KECVUQRPLWJvidTm7cbPbOhaZMbKngt.X2RYTB1ctS/PVo7rOGVje",
      "Accept": "application/json",
      'Authorization': 'Bearer ' + jwt,
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse("${BaseUrl.getBaseUrl()}" + "breeder/advert/store"));
    request.headers.addAll(headers);

    List<http.MultipartFile> motherReportList = [];
    for (int i = 0; i < mother_reports.length; i++) {
      File imageFile = File(mother_reports[i]!.path);
      var stream =
          http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile(
          "mother_report_details[$i]", stream, length,
          filename: basename(imageFile.path));
      motherReportList.add(multipartFile);
    }
    List<http.MultipartFile> fatherReportList = [];
    for (int i = 0; i < father_reports.length; i++) {
      File imageFile = File(father_reports[i]!.path);
      var stream =
          http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile(
          "father_report_details[$i]", stream, length,
          filename: basename(imageFile.path));
      fatherReportList.add(multipartFile);
    }
    request.files.addAll(motherReportList);
    request.files.addAll(fatherReportList);
    if (coverImage != null) {
      request.files
          .add(await http.MultipartFile.fromPath('cover_photo', coverImage));
    }
    for (String item in mother_test) {
      request.files
          .add(http.MultipartFile.fromString('mother_test[$item]', item));
    }
    for (String item in father_test) {
      request.files
          .add(http.MultipartFile.fromString('father_test[$item]', item));
    }
    if (advert_name != null) {
      request.fields['advert_name'] = advert_name;
    }
    if (mother_name != null) {
      request.fields['mother_name'] = mother_name;
    }
    if (father_name != null) {
      request.fields['father_name'] = father_name;
    }
    if (breed_id != null) {
      request.fields['breed_id'] = breed_id;
    }
    if (is_publish != null) {
      request.fields['is_publish'] = is_publish.toString();
    }
    if (description != null) {
      request.fields['description'] = description;
    }

    var res = await request.send();
    var responed = await http.Response.fromStream(res);
    var responseData = json.decode(responed.body);
    if (responseData['status'] == 200) {
      AdvertIdModel advertIdModel =
          AdvertIdModel.fromJson(responseData['data']);
      EasyLoading.dismiss(animation: true);
      return advertIdModel;
    } else {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showError(responseData['message'] ?? "Something went wrong");
    }
    return null;
  }

  //-----------UPDATE BREEDER ADVERT API-----------------

  Future<dynamic> updateBreederAdvert({
    required String advert_name,
    required String description,
    int? id,
    required String mother_name,
    required String father_name,
    String? coverImage,
    bool? is_publish,
    required List<File?> mother_reports,
    required List<String> delete_mother_report_details,
    required List<String> delete_father_report_details,
    required List<File?> father_reports,
    required List<String> mother_test,
    required List<String> father_test,
    required BuildContext context,
  }) async {
    EasyLoading.show(
        status: 'loading...', maskType: EasyLoadingMaskType.custom);
    String? jwt = await storage.readStore('token');
    jwt = jwt ?? '';
    Map<String, String> headers = {
      "m-access-key":
          "\$2a\$12\$KECVUQRPLWJvidTm7cbPbOhaZMbKngt.X2RYTB1ctS/PVo7rOGVje",
      "Accept": "application/json",
      'Authorization': 'Bearer ' + jwt,
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            "${BaseUrl.getBaseUrl()}" + "breeder/advert/update/" + "${id}"));
    request.headers.addAll(headers);

    List<http.MultipartFile> motherReportList = [];
    for (int i = 0; i < mother_reports.length; i++) {
      File imageFile = File(mother_reports[i]!.path);
      var stream =
          http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile(
          "mother_report_details[$i]", stream, length,
          filename: basename(imageFile.path));
      motherReportList.add(multipartFile);
    }
    List<http.MultipartFile> fatherReportList = [];
    for (int i = 0; i < father_reports.length; i++) {
      File imageFile = File(father_reports[i]!.path);
      var stream =
          http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile(
          "father_report_details[$i]", stream, length,
          filename: basename(imageFile.path));
      fatherReportList.add(multipartFile);
    }
    request.files.addAll(motherReportList);
    request.files.addAll(fatherReportList);
    if (coverImage != null) {
      request.files
          .add(await http.MultipartFile.fromPath('cover_photo', coverImage));
    }
    for (String item in delete_mother_report_details) {
      request.files.add(http.MultipartFile.fromString(
          'delete_mother_report_details[$item]', item));
    }
    for (String item in delete_father_report_details) {
      request.files.add(http.MultipartFile.fromString(
          'delete_father_report_details[$item]', item));
    }
    if (mother_test.isEmpty) {
      request.fields['mother_test[0]'] = "";
    }
    for (String item in mother_test) {
      request.fields['mother_test[$item]'] = item;
    }
    if (father_test.isEmpty) {
      request.fields['father_test[0]'] = "";
    }
    for (String item in father_test) {
      request.fields['father_test[$item]'] = item;
    }
    if (advert_name != null) {
      request.fields['advert_name'] = advert_name;
    }
    if (mother_name != null) {
      request.fields['mother_name'] = mother_name;
    }
    if (father_name != null) {
      request.fields['father_name'] = father_name;
    }
    if (is_publish != null) {
      request.fields['is_publish'] = is_publish.toString();
    }
    if (description != null) {
      request.fields['description'] = description;
    }

    var res = await request.send();
    var responed = await http.Response.fromStream(res);
    var responseData = json.decode(responed.body);

    if (responseData['status'] == 200) {
      EasyLoading.dismiss(animation: true);
    } else {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showError(responseData['message'] ?? "Something went wrong");
    }
    return responseData['message'];
  }

  //-----------UPDATE BREEDER ADVERT STEP THREE API--------------------

  Future<dynamic> updateStepThree(
      {required int? id,
      required String dob,
      required String motherChipNumber,
      bool? is_publish,
      required bool hasChipNumber,
      required List<EditAdvertPetModel> pets}) async {
    EasyLoading.show(
        status: 'loading...', maskType: EasyLoadingMaskType.custom);
    String? jwt = await storage.readStore('token');
    jwt = jwt ?? '';
    Map<String, String> headers = {
      "m-access-key":
          "\$2a\$12\$KECVUQRPLWJvidTm7cbPbO" "haZMbKngt.X2RYTB1ctS/PVo7rOGVje",
      "Accept": "application/json",
      'Authorization': 'Bearer ' + jwt,
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            "${BaseUrl.getBaseUrl()}" + "breeder/advert/update/" + "${id}"));
    request.headers.addAll(headers);
    int newIndex = 0;
    int updateIndex = 0;
    for (var pet in pets) {
      if (pet.isNew == true) {
        request.fields['new_puppies[$newIndex][price]'] = pet.price.toString();
        request.fields['new_puppies[$newIndex][gender]'] =
            pet.gender.toString().toLowerCase();
        request.fields['new_puppies[$newIndex][name]'] = pet.name ?? "";
        request.fields['new_puppies[$newIndex][color]'] = pet.color ?? "";
        if (pet.chip_number != null && pet.chip_number!.isNotEmpty) {
          request.fields['new_puppies[$newIndex][chip_number]'] =
              pet.chip_number.toString();
        }
        if (pet.puppyPhoto != null) {
          request.files.add(http.MultipartFile.fromString(
              'new_puppies[$newIndex][photo]', pet.puppyPhoto!.path));
          var img = await http.MultipartFile.fromPath(
              'new_puppies[$newIndex][photo]', pet.puppyPhoto!.path);
          request.files.add(img);
        }
        List<http.MultipartFile> certificateDetails = [];
        for (int i = 0; i < pet.newCertificateList.length; i++) {
          File imageFile = File(pet.newCertificateList[i]!.path);
          var stream =
              http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
          var length = await imageFile.length();
          var multipartFile = http.MultipartFile(
              "new_puppies[$newIndex][certificates][$i]", stream, length,
              filename: basename(imageFile.path));
          certificateDetails.add(multipartFile);
        }
        request.files.addAll(certificateDetails);
        newIndex++;
      } else {
        request.fields['update_puppies[$updateIndex][name]'] =
            pet.name.toString();
        request.fields['update_puppies[$updateIndex][pet_id]'] =
            pet.pet_id.toString();
        request.fields['update_puppies[$updateIndex][price]'] =
            pet.price.toString();
        request.fields['update_puppies[$updateIndex][gender]'] =
            pet.gender.toString().toLowerCase();
        request.fields['update_puppies[$updateIndex][color]'] =
            pet.color.toString();
        request.fields['update_puppies[$updateIndex][chip_number]'] =
            pet.chip_number.toString();

        if (pet.puppyPhoto != null) {
          var img = await http.MultipartFile.fromPath(
              'update_puppies[$updateIndex][photo]', pet.puppyPhoto!.path);
          request.files.add(img);
        }
        for (String item in pet.deletePuppiesImages) {
          request.files.add(http.MultipartFile.fromString(
              'update_puppies[$updateIndex][delete_certificates][$item]',
              item));
        }
        List<http.MultipartFile> certificateDetails = [];
        for (int i = 0; i < pet.newCertificateList.length; i++) {
          File imageFile = File(pet.newCertificateList[i]!.path);
          var stream =
              http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
          var length = await imageFile.length();
          var multipartFile = http.MultipartFile(
              "update_puppies[$updateIndex][certificates][$i]", stream, length,
              filename: basename(imageFile.path));
          certificateDetails.add(multipartFile);
        }
        request.files.addAll(certificateDetails);
        updateIndex++;
      }
    }
    if (dob != null) {
      request.fields['dob'] = dob;
    }
    if (motherChipNumber.isNotEmpty) {
      if (hasChipNumber == false) {
        request.fields['mother_chip_number'] = motherChipNumber;
      }
    }
    if (is_publish != null) {
      request.fields['is_publish'] = is_publish.toString();
    }
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    var responseData = json.decode(response.body);
    if (responseData['status'] == 200) {
      EasyLoading.dismiss(animation: true);
    } else {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showError(responseData['message'] ?? "Something went wrong");
    }
    return responseData['message'];
  }

  //-----------UPDATE BREEDER ADVERT STEP THREE DATA IF PUPPIES NOT ADDED--------------------
  Future<dynamic> updateStepThreeDate({
    required int? id,
    required String dob,
    required bool is_publish,
  }) async {
    EasyLoading.show(
        status: 'loading...', maskType: EasyLoadingMaskType.custom);
    String? jwt = await storage.readStore('token');
    jwt = jwt ?? '';
    Map<String, String> headers = {
      "m-access-key":
          "\$2a\$12\$KECVUQRPLWJvidTm7cbPbOhaZMbKngt.X2RYTB1ctS/PVo7rOGVje",
      "Accept": "application/json",
      'Authorization': 'Bearer ' + jwt,
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            "${BaseUrl.getBaseUrl()}" + "breeder/advert/update/" + "${id}"));
    request.headers.addAll(headers);
    if (dob != null) {
      request.fields['dob'] = dob;
    }
    if (is_publish != null) {
      request.fields['is_publish'] = is_publish.toString();
    }
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    var responseData = json.decode(response.body);
    if (responseData['status'] == 200) {
      EasyLoading.dismiss(animation: true);
    } else {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showError(responseData['message'] ?? "Something went wrong");
    }
    return responseData['message'];
  }

  //-----------UPDATE LOCATION ON MAP--------------------

  updateLocation(
      {required String lat,
      required String long,
      required BuildContext context}) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    method = 'post';
    Map<String, String> body = {
      'lat': lat,
      'long': long,
    };
    this.context = context;
    data = body;

    ResponseModel _responseModel = await request("update_breeder_location");
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      EasyLoading.showSuccess("Location updated Successfully");
    }
  }

  //--------------------ADD MICROCHIP NUMBER API-------------

  Future<int?> updatePuppyMicroChipNo(
      {required String chip_number,
      required String pet_id,
      required String advert_id,
      required BuildContext context}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    method = 'post';
    requestUrl = generateURL("update_puppy_chip_no") +
        advert_id +
        "/pet/update-micro-chip-number";
    Map<String, String> body = {
      'chip_number': chip_number,
      'pet_id': pet_id,
    };
    this.context = context;
    data = body;
    ResponseModel _responseModel = await request(null);
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      EasyLoading.showSuccess('Updated Successfully!');
      return _responseModel.statusCode;
    }
  }
}
