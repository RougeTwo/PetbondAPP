import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:petbond_uk/core/utils/file_universal.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petbond_uk/core/services/base_services.dart';
import 'package:petbond_uk/core/utils/base_url.dart';
import 'package:petbond_uk/core/utils/response_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:petbond_uk/core/values/styles.dart';
import 'package:petbond_uk/models/veterinarian/advert/adverts_model.dart';
import 'package:petbond_uk/models/veterinarian/advert_puppies_model/advert_puppies_model.dart';
import 'package:petbond_uk/models/veterinarian/breeder_search_result.dart';
import 'package:petbond_uk/models/veterinarian/connected_breeder_model.dart';
import 'package:petbond_uk/models/veterinarian/vet_view_model.dart';
import 'package:http/http.dart' as http;
import 'package:petbond_uk/modules/veterinarian/vet_dashboard.dart';

import '../../models/shared/chip_model.dart';
import '../../modules/veterinarian/vet_edit_adverts/puppy_form/draft_advert_puppy_model.dart';

class VeterinarianServices extends BaseService {
  //-----------REGISTER BREEDER--------------------
  registerVetBreeder(
      {required String firstName,
      required String lastName,
      required String email,
      required String phoneNo,
      required String password,
      required GlobalKey<FormState> key,
      required BuildContext context}) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    method = 'post';
    Map<String, String> body = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNo,
      'password': password,
    };
    this.context = context;
    data = body;
    ResponseModel _responseModel = await request("vet_breeder_register");
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      EasyLoading.showSuccess("Breeder Registered Successfully");
      key.currentState!.reset();
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const VetDashBoardScreen()));
      });
    }
  }

  //-----------ADD VET STAFF--------------------

  addVetStaff(
      {required String firstName,
      required String lastName,
      required String email,
      required String password,
      required GlobalKey<FormState> key,
      required BuildContext context}) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    method = 'post';
    Map<String, String> body = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
    };
    this.context = context;
    data = body;
    ResponseModel _responseModel = await request("add_vet_staff");
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      EasyLoading.showSuccess("Staff Added Successfully");
      key.currentState!.reset();
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    }
  }

  //-----------ADD DRAFT ADVERT--------------------

  addDraftAdvert(
      {required String advertName,
      int? breederId,
      required String chipNumber,
      required List<DraftAdvertPuppyModel> puppies,
      required BuildContext context}) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    method = 'post';
    Map<String, String> body = {};
    body['breeder_id'] = breederId.toString();
    body['chip_number'] = chipNumber;
    body['advert_name'] = advertName;
    int index = 0;
    for (var puppy in puppies) {
      body['new_puppies[$index][name]'] = puppy.name.toString();
      body['new_puppies[$index][color]'] = puppy.color.toString();
      index++;
    }
    this.context = context;
    data = body;
    ResponseModel _responseModel = await request("create_draft_advert");
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      EasyLoading.showSuccess("Added Successfully");
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
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
    ResponseModel _responseModel = await request("update_vet_location");
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      EasyLoading.showSuccess("Location updated Successfully");
    }
  }

  //-----------GET CONNECTED BREEDER LIST--------------------

  Future<List<ConnectedBreederModel>> getConnectedBreederList(
      {required BuildContext context}) async {
    method = "get";
    this.context = context;
    ResponseModel _responseModel = await request('vet_connected_breeder');
    List<ConnectedBreederModel> connectedBreederList = [];
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      connectedBreederList = _responseModel.body
          .map<ConnectedBreederModel>(
              (breederList) => ConnectedBreederModel.fromJson(breederList))
          .toList();
      return connectedBreederList;
    }
    return connectedBreederList;
  }

  //-----------GET VET VIEW MODEL--------------------

  Future<VetViewModel?> getVetViewModel({required BuildContext context}) async {
    method = "get";
    context = context;
    ResponseModel _responseModel = await request('vet_view');
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      VetViewModel viewModel = VetViewModel.fromJson(_responseModel.body);
      return viewModel;
    }
    return null;
  }

  //-----------UPDATE PROFILE INFO--------------------
  updateVetProfileInfo(
      {required String first_name,
      required String last_name,
      required String phone_number,
      required String postal_code,
      required String address,
      required String rcvs_number,
      required String fb_url,
      required String insta_url,
      required String practice_name,
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
      'rcvs_number': rcvs_number,
      'fb_url': fb_url,
      'insta_url': insta_url,
      'practice_name': practice_name,
      'city_id': city_id,
      'lat': lat,
      'long': lng,
    };
    this.context = context;
    data = body;
    ResponseModel _responseModel = await request("vet_update_profile");
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      storage.setStore('practice_name', practice_name);
      EasyLoading.showSuccess(CustomStyles.saveText);
      return '';
    }
  }

  //-----------SEARCH BREEDER BY EMAIL--------------------

  Future<SearchResultModel?> getSearchResult(
      {required String email, required BuildContext context}) async {
    method = 'post';
    Map<String, String> body = {
      'email': email,
    };
    this.context = context;
    data = body;
    ResponseModel _responseModel = await request('vet_search_breeder');
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      SearchResultModel searchResultModel =
          SearchResultModel.fromJson(_responseModel.body);
      return searchResultModel;
    }
    return null;
  }

  //-----------CONNECT TO BREEDER BY EMAIL--------------------

  Future<String?> connectToBreederByEmail(
      {required String breeder_id, required BuildContext context}) async {
    method = 'post';
    Map<String, String> body = {
      'breeder_id': breeder_id,
    };
    this.context = context;
    data = body;
    ResponseModel _responseModel = await request('connect_breeder');
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      EasyLoading.showSuccess("Connected Successfully");
      return _responseModel.message;
    }
    return _responseModel.message;
  }

  //-----------CONNECT TO BREEDER BY QR SCANNER--------------------

  Future<String?> connectToBreederByQR(
      {required String qr_id, required BuildContext context}) async {
    method = 'post';
    Map<String, String> body = {
      'qr_id': qr_id,
    };
    this.context = context;
    data = body;
    ResponseModel _responseModel = await request('connect_breeder');
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      return _responseModel.message;
    }
    return _responseModel.message;
  }

  //-----------DELETE CONNECTED BREEDER--------------------
  Future<void> deleteConnection(
      {int? breeder_id, required BuildContext context}) async {
    method = 'delete';
    requestUrl = generateURL("delete_connection") + breeder_id.toString();
    Map<String, String> body = {};
    this.context = context;
    data = body;
    ResponseModel _responseModel = await request(null);
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      EasyLoading.showSuccess("Connection Deleted Successfully!");
    }
  }

  //-----------GET BREEDER ADVERT LIST--------------------

  Future<List<AdvertsModel>> getAdvertsList(
      {required BuildContext context, int? breeder_id}) async {
    method = "get";
    requestUrl = generateURL("get_adverts") + breeder_id.toString();
    this.context = context;
    ResponseModel _responseModel = await request(null);
    List<AdvertsModel> advertsList = [];
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      advertsList = _responseModel.body
          .map<AdvertsModel>(
              (advertsList) => AdvertsModel.fromJson(advertsList))
          .toList();
      return advertsList;
    }
    return advertsList;
  }

  //-----------GET STAFF LIST--------------------

  Future<List<SearchResultModel>> getStaffListing(
      {required BuildContext context, required bool addStaffName}) async {
    method = "get";
    this.context = context;
    ResponseModel _responseModel = await request('get_sub_vet_list');
    List<SearchResultModel> subVetList = [];
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      subVetList = _responseModel.body
          .map<SearchResultModel>(
              (breederList) => SearchResultModel.fromJson(breederList))
          .toList();
    }
    if (addStaffName == true) {
      subVetList.insert(
          0, SearchResultModel(first_name: "Select staff name", id: 00));
      return subVetList;
    }
    return subVetList;
  }

  //-----------GET STAFF LIST FOR ADVERT PUPPIES--------------------

  Future<List<SearchResultModel>> getStaffNameListing(
      {required BuildContext context}) async {
    method = "get";
    this.context = context;
    activateLoader = false;
    ResponseModel _responseModel = await request('get_sub_vet_list');
    List<SearchResultModel> subVetList = [];
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      subVetList = _responseModel.body
          .map<SearchResultModel>(
              (breederList) => SearchResultModel.fromJson(breederList))
          .toList();
    }
    subVetList.insert(
        0,
        SearchResultModel(
            first_name: "Select", last_name: "staff name", id: 00));
    return subVetList;
  }

  //-----------EDIT STAFF--------------------

  Future<SearchResultModel?> getStaffEditModel(
      {required BuildContext context, int? advert_id}) async {
    method = "get";
    requestUrl = generateURL("get_edit_vet_staff") + advert_id.toString();
    this.context = context;
    ResponseModel _responseModel = await request(null);

    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      SearchResultModel editStaffModel =
          SearchResultModel.fromJson(_responseModel.body);
      return editStaffModel;
    }
    return null;
  }

  //-----------UPDATE STAFF INFO--------------------

  Future<void> updateVetStaffInfo(
      {required int user_id,
      required String first_name,
      required String last_name,
      required String email,
      required BuildContext context}) async {
    method = 'post';
    Map<String, String> body = {
      'user_id': user_id.toString(),
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
    };
    this.context = context;
    data = body;
    ResponseModel _responseModel = await request("update_vet_staff_info");
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      EasyLoading.showSuccess(CustomStyles.saveText);
    }
  }

  //-----------DELETE VET STAFF--------------------

  Future<void> deleteVetStaff(
      {int? vet_staff_id, required BuildContext context}) async {
    method = 'delete';
    requestUrl = generateURL("delete_vet_staff_info") + vet_staff_id.toString();
    Map<String, String> body = {};
    this.context = context;
    data = body;
    ResponseModel _responseModel = await request(null);
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      return EasyLoading.showSuccess("Staff Deleted Successfully!");
    }
  }

  //-----------GET VET ADVERT LIST--------------------

  Future<AdvertPuppiesModel?> getAdvertPuppyList(
      {required BuildContext context, int? breeder_id}) async {
    method = "get";
    requestUrl = generateURL("get_advert_puppy") + breeder_id.toString();
    this.context = context;
    ResponseModel _responseModel = await request(null);
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      AdvertPuppiesModel advertsList =
          AdvertPuppiesModel.fromJson(_responseModel.body);
      return advertsList;
    }
    return null;
  }

  //-----------UPDATE PASSWORD--------------------

  vetChangePassword(
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
    ResponseModel _responseModel = await request("vet_change_password");
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      EasyLoading.showSuccess("Password Changed Successfully");
    }
  }

  //-----------UPDATE PUPPIES LIST--------------------
  vetUpdatePuppiesList({
    int? pet_id,
    int? push_id,
    int? user_id,
    int? verification_id,
    required String chip_no,
    String? examination_note,
    String? physical_defect,
    String? significance_defect,
    required List<File?> images,
    required List<String> deleteCertificates,
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
        Uri.parse(BaseUrl.getBaseUrl() + "veterinarian/connect/breeder/advert/pet-verification/" +
            pet_id.toString()));
    request.headers.addAll(headers);
    List<http.MultipartFile> newList = [];
    for (int i = 0; i < images.length; i++) {
      File imageFile = File(images[i]!.path);

      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();

      var multipartFile = http.MultipartFile(
          "certificate_details[$i]", stream, length,
          filename: basename(imageFile.path));
      newList.add(multipartFile);
    }
    request.files.addAll(newList);
    for (String item in deleteCertificates) {
      request.files.add(
          http.MultipartFile.fromString('delete_certificates[$item]', item));
    }
    if (verification_id != null) {
      request.fields['verification_id'] = verification_id.toString();
    }
    if (examination_note != null) {
      request.fields['note'] = examination_note;
    }
    request.fields['chip_number'] = chip_no;
    if (physical_defect != null) {
      request.fields['physical_defect'] = physical_defect;
    }
    if (significance_defect != null) {
      request.fields['significance'] = significance_defect;
    }
    if (user_id != null && user_id != 0) {
      request.fields['user_id'] = user_id.toString();
    }
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    var responseData = json.decode(response.body);
    if (responseData['status'] == 200) {
      EasyLoading.showSuccess(CustomStyles.saveText);
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });

      EasyLoading.dismiss(animation: true);
    } else {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showError(responseData['message'] ?? "Something went wrong");
    }
  }

  //-----------------GET BREEDER CHIP LIST FOR CREATE DRAFT ADVERT------------

  Future<List<ChipListModel>> getChipList(
      {required BuildContext context, int? breederId}) async {
    activateLoader = false;
    this.context = context;
    requestUrl =
        generateURL("get_chip_create_draft_advert") + breederId.toString();
    ResponseModel _responseModel = await request(null);
    List<ChipListModel> chipList = [];
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      chipList = _responseModel.body
          .map<ChipListModel>((chip) => ChipListModel.fromJson(chip))
          .toList();
    }
    chipList.insert(
        0,
        ChipListModel(
          chip_number: "Select chip number",
        ));

    return chipList;
  }

  //--------------------ADD BREEDER MICROCHIP NUMBER API-------------

  Future<void> breederAddMicroChipInfo(
      {required String chip_number,
      required String breed_id,
      int? breeder_id,
      required BuildContext context}) async {
    method = 'post';
    Map<String, String> body = {
      'chip_number': chip_number,
      'breed_id': breed_id,
      'breeder_id': breeder_id.toString(),
    };
    this.context = context;
    data = body;
    ResponseModel _responseModel = await request("save_chip");
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      EasyLoading.showSuccess('Added Successfully!');
    }
  }

  //-----------Stream Builder Testing--------------------

  //get-staff-listing

  Stream<List<SearchResultModel>> getStaffStreamListing(
      {required BuildContext context, required bool addStaffName}) async* {
    method = "get";
    this.context = context;
    ResponseModel _responseModel = await request('get_sub_vet_list');
    List<SearchResultModel> subVetList = [];
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      subVetList = _responseModel.body
          .map<SearchResultModel>(
              (breederList) => SearchResultModel.fromJson(breederList))
          .toList();
    }
    if (addStaffName == true) {
      subVetList.insert(
          0, SearchResultModel(first_name: "Select staff name", id: 00));
      yield subVetList;
    }
    yield subVetList;
  }

  //get-connectedBreederList
  Stream<List<ConnectedBreederModel>> getStreamConnectedBreederList(
      {required BuildContext context}) async* {
    method = "get";
    this.context = context;
    ResponseModel _responseModel = await request('vet_connected_breeder');
    List<ConnectedBreederModel> connectedBreederList = [];
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      connectedBreederList = _responseModel.body
          .map<ConnectedBreederModel>(
              (breederList) => ConnectedBreederModel.fromJson(breederList))
          .toList();
      yield connectedBreederList;
    }
    yield connectedBreederList;
  }
}
