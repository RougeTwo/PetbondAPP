import 'package:flutter/material.dart';
import 'package:petbond_uk/core/services/base_services.dart';
import 'package:petbond_uk/core/utils/response_model.dart';
import 'package:petbond_uk/models/advert_model/advert_detail_model.dart';
import 'package:petbond_uk/models/shared/breed_list_model.dart';
import 'package:petbond_uk/models/shared/chip_model.dart';
import 'package:petbond_uk/models/shared/city_model.dart';
import 'package:petbond_uk/models/shared/examinations.dart';
import 'package:petbond_uk/core/widgets/globals.dart' as Globals;
import '../../core/routes/routes.dart';

class SharedServices extends BaseService {
  //-----------GET COUNTY/CITY LIST--------------------
  Future<List<CityModel>> getCitiesList({required BuildContext context}) async {
    activateLoader = false;
    this.context = context;
    ResponseModel _responseModel = await request('get_cities');
    List<CityModel> citiesList = [];
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      citiesList = _responseModel.body
          .map<CityModel>((language) => CityModel.fromJson(language))
          .toList();
    }
    citiesList.insert(0, CityModel(name: "Select county", id: 00));

    return citiesList;
  }

  //-----------GET BREED LIST--------------------
  Future<List<BreedListModel>> getBreedList(
      {required BuildContext context}) async {
    activateLoader = false;
    this.context = context;
    ResponseModel _responseModel = await request('get_breed');
    List<BreedListModel> breedList = [];
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      breedList = _responseModel.body
          .map<BreedListModel>((breed) => BreedListModel.fromJson(breed))
          .toList();
    }
    breedList.insert(0, BreedListModel(name: "Select breed", id: 00));

    return breedList;
  }

  //-----------GET CHIP_NUMBER LIST--------------------

  Future<List<ChipListModel>> getChipList(
      {required BuildContext context}) async {
    activateLoader = false;
    this.context = context;
    ResponseModel _responseModel = await request('get_breeder_chip_list');
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

  //-----------GET EXAMINATION LIST--------------------

  Future<List<ExaminationModel>> getExaminationList(
      {required BuildContext context}) async {
    activateLoader = false;
    this.context = context;
    ResponseModel _responseModel = await request('get_examinations');
    List<ExaminationModel> examinationList = [];
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      examinationList = _responseModel.body
          .map<ExaminationModel>(
              (examination) => ExaminationModel.fromJson(examination))
          .toList();
    }
    return examinationList;
  }

  //-----------GET ADVERT DETAIL--------------------
  Future<AdvertDetailViewModel?> getAdvertDetailViewModel(
      {required BuildContext context, int? id}) async {
    method = "get";
    requestUrl = generateURL("detail_advert_view") + id.toString();
    context = context;
    ResponseModel _responseModel = await request(null);
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      AdvertDetailViewModel viewModel =
          AdvertDetailViewModel.fromJson(_responseModel.body);
      return viewModel;
    }
    return null;
  }

  //-----------------DELETE ACCOUNT------------------------------
  Future<dynamic> deleteAccount(
      {required BuildContext context, required String password}) async {
    method = "post";
    Map<String, String> body = {
      'password': password,
    };
    this.context = context;
    data = body;
    context = context;
    ResponseModel _responseModel = await request('delete_account');

    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      storage.deleteAll();
      Globals.GlobalData.showVerifyPopUp = false;
      Globals.GlobalData.showStripeAccountPopUp = false;
      Navigator.pushNamedAndRemoveUntil(context, loginScreen, (route) => false);
      return _responseModel.statusCode;
    }

    return null;
  }
}
