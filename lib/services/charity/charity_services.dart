import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:petbond_uk/core/routes/routes.dart';
import 'package:petbond_uk/core/services/base_services.dart';
import 'package:petbond_uk/core/utils/base_url.dart';
import 'package:petbond_uk/core/utils/response_model.dart';
import 'package:petbond_uk/core/values/styles.dart';
import 'package:petbond_uk/models/breeder/advert/advert_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:petbond_uk/models/charity/charity_view_model.dart';
import 'package:petbond_uk/models/charity/get_edit_model/edit_model.dart';

class CharityServices extends BaseService {
  //-----------GET CHARITY VIEW MODEL--------------------

  Future<CharityViewModel?> getViewModel(
      {required BuildContext context}) async {
    method = "get";
    context = context;
    ResponseModel _responseModel = await request('get_charity_view');
    print(_responseModel.body);
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      CharityViewModel viewModel =
          CharityViewModel.fromJson(_responseModel.body);
      return viewModel;
    }
    return null;
  }

  //-----------GET CHARITY ADVERT FOR EDIT--------------------
  Future<CharityAdvertEditModel?> getEditAdvert(
      {required BuildContext context, required int? id}) async {
    method = "get";
    requestUrl = generateURL("get_edit_charity_advert") + id.toString();
    context = context;
    ResponseModel _responseModel = await request(null);
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      CharityAdvertEditModel editModel =
          CharityAdvertEditModel.fromJson(_responseModel.body);
      return editModel;
    }
    return null;
  }

  //-----------UPDATE CHARITY BIO--------------------

  updateCharityBioInfo(
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

  //-----------GET RECENT ADDED PET LIST--------------------'

  Future<List<AdvertModel>> getRecent({required BuildContext context}) async {
    method = "get";
    this.context = context;
    ResponseModel _responseModel = await this.request('get_charity_recent');
    List<AdvertModel> recentList = [];
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      recentList = _responseModel.body
          .map<AdvertModel>((advert) => AdvertModel.fromJson(advert))
          .toList();
      return recentList;
    }
    return recentList;
  }

  //-----------UPDATE CHARITY ADVERT--------------------

  updateCharityAdvert({
    required String chipNo,
    int? advert_id,
    required int breed_id,
    int? pet_id,
    required String price,
    required String description,
    required String puppyName,
    required String color,
    required String advertName,
    required String gender,
    required bool isPublish,
    String? photo,
    String? coverPhoto,
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
        Uri.parse("${BaseUrl.getBaseUrl()}" +
            "charity/advert/update/" +
            "${advert_id}"));
    request.headers.addAll(headers);
    if (photo != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', photo));
    }
    if (coverPhoto != null) {
      request.files
          .add(await http.MultipartFile.fromPath('cover_photo', coverPhoto));
    }

    request.fields['chip_number'] = chipNo;
    request.fields['breed_id'] = breed_id.toString();
    request.fields['name'] = puppyName;
    request.fields['advert_name'] = advertName;
    request.fields['description'] = description;
    request.fields['gender'] = gender.toLowerCase();
    request.fields['price'] = price.toString();
    request.fields['color'] = color;
    request.fields['pet_id'] = pet_id.toString();
    request.fields['is_publish'] = isPublish.toString();

    var res = await request.send();
    var responed = await http.Response.fromStream(res);
    var responseData = json.decode(responed.body);
    if (responseData['status'] == 200) {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showSuccess(CustomStyles.save_text);
      Navigator.pushNamedAndRemoveUntil(
          context, charityDashBoardScreen, (route) => false);
    } else {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showError(responseData['message'] ?? "Something went wrong");
    }
  }

  //-----------CREATE CHARITY ADVERT--------------------

  createCharityAdvert({
    required String chipNo,
    required int breed_id,
    required String price,
    required String description,
    required String puppyName,
    required String color,
    required String advertName,
    required String gender,
    required bool isPublish,
    String? photo,
    String? coverPhoto,
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
        'POST', Uri.parse("${BaseUrl.getBaseUrl()}" + "charity/advert/store"));
    request.headers.addAll(headers);
    if (photo != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', photo));
    }
    if (coverPhoto != null) {
      request.files
          .add(await http.MultipartFile.fromPath('cover_photo', coverPhoto));
    }
    if (chipNo.isNotEmpty) {
      request.fields['chip_number'] = chipNo;
    }
    request.fields['breed_id'] = breed_id.toString();
    request.fields['name'] = puppyName;
    request.fields['advert_name'] = advertName;
    request.fields['description'] = description;
    request.fields['gender'] = gender.toLowerCase();
    request.fields['price'] = price.toString();
    request.fields['color'] = color;
    request.fields['is_publish'] = isPublish.toString();

    var res = await request.send();
    var responed = await http.Response.fromStream(res);
    var responseData = json.decode(responed.body);
    if (responseData['status'] == 200) {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showSuccess(CustomStyles.save_text);
      Navigator.pushNamedAndRemoveUntil(
          context, charityDashBoardScreen, (route) => false);
    } else {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showError(responseData['message'] ?? "Something went wrong");
    }
  }

  //-----------DELETE CHARITY ADVERT FROM LIST--------------------

  Future<String?> deleteCharityAdvertFromList(
      {int? advert_id, required BuildContext context}) async {
    method = 'delete';
    requestUrl = generateURL("charity_delete_advert") + advert_id.toString();
    Map<String, String> body = {};
    this.context = context;
    data = body;
    ResponseModel _responseModel = await request(null);
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      return _responseModel.message;
    }
  }

  //-----------GET BREEDER LISTED PETS--------------------

  Future<List<AdvertModel>> getListedPets(
      {required BuildContext context}) async {
    this.method = "get";
    this.context = context;
    ResponseModel _responseModel = await this.request('charity_listed_pets');
    List<AdvertModel> recentList = [];
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      recentList = _responseModel.body
          .map<AdvertModel>((advert) => AdvertModel.fromJson(advert))
          .toList();
      return recentList;
    }
    return recentList;
  }

  //-----------UPDATE CHARITY PROFILE INFO--------------------

  updateCharityProfileInfo(
      {required String first_name,
      required String last_name,
      required String phone_number,
      required String postal_code,
      required String address,
      required String charity_number,
      required String charity_name,
      required String city_id,
      required String lat,
      required String lng,
      required BuildContext context}) async {
    method = 'post';
    Map<String, String> body = {
      'first_name': first_name,
      'last_name': last_name,
      'phone_number': phone_number,
      'postal_code': postal_code,
      'address': address,
      'charity_number': charity_number,
      'charity_name': charity_name,
      'city_id': city_id,
      'lat': lat,
      'long': lng,
    };
    this.context = context;
    data = body;
    ResponseModel _responseModel = await request("charity_update_profile_info");
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      EasyLoading.showSuccess(CustomStyles.save_text);
      return '';
    }
  }

  //-----------UPDATE CHARITY PASSWORD--------------------

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
    ResponseModel _responseModel = await request("update_charity_password");
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      EasyLoading.showSuccess("Password Changed Successfully");
    }
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

    ResponseModel _responseModel = await request("update_charity_location");
    print(_responseModel.body);
    print(_responseModel.statusCode);
    print(_responseModel.body);
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      EasyLoading.showSuccess("Location updated Successfully");
    }
  }
}
