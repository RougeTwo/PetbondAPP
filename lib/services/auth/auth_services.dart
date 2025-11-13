import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:petbond_uk/core/routes/routes.dart';
import 'package:petbond_uk/core/services/base_services.dart';
import 'package:petbond_uk/core/utils/base_url.dart';
import 'package:petbond_uk/core/utils/helper.dart';
import 'package:petbond_uk/core/utils/response_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:petbond_uk/core/widgets/globals.dart' as globals;

class AuthServices extends BaseService {
  //-----------------LOGIN API------------------------------

  login(
      {required String email,
      required String password,
      required bool redirect,
      required BuildContext context}) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    method = 'post';
    Map<String, String> body = {
      'email': email,
      'password': password,
    };
    this.context = context;
    redirectOn = redirect;
    data = body;
    ResponseModel _responseModel = await request("login");
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      storage.setStore('token', _responseModel.body['access_token']);
      storage.setStore('auth_id', _responseModel.body['user']['id'].toString());
      storage.setStore('role', _responseModel.body['user']['role']);
      storage.setStore(
          'email_verified', _responseModel.body['user']['email_verified_at']);
      storage.setStore(
          'onBoard_status', _responseModel.body['on_board_status'].toString());
      storage.setStore('transferUnable',
          _responseModel.body['is_transfer_enabled'].toString());
      if (_responseModel.body['user']['email_verified_at'].toString().isEmpty) {
        globals.GlobalData.showVerifyPopUp = true;
      }
      if (_responseModel.body['on_board_status'] == false) {
        globals.GlobalData.showStripeAccountPopUp = true;
      }
      if (_responseModel.body['is_transfer_enabled'] == false) {
        globals.GlobalData.showTransferUnablePopUp = true;
      }
      if (_responseModel.body['user']['role'] == 'veterinarian') {
        Navigator.pushNamedAndRemoveUntil(
            context, vetDashBoardScreen, (route) => false);
      } else if (_responseModel.body['user']['role'] == 'charity') {
        Navigator.pushNamedAndRemoveUntil(
            context, charityDashBoardScreen, (route) => false);
      } else if (_responseModel.body['user']['role'] == 'breeder') {
        storage.setStore('qr_code', _responseModel.body['user']['qr_code']);
        Navigator.pushNamedAndRemoveUntil(
            context, breederDashBoardScreen, (route) => false);
      }
      return null;
    }
  }

  //-----------------FORGET PASSWORD API------------------------------
  forgetPassword({required String email, required BuildContext context}) async {
    method = 'post';
    Map<String, String> body = {
      'email': email,
    };
    this.context = context;
    data = body;
    ResponseModel _responseModel = await request("forget_password");
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      Helper.showErrorAlert(context,
          title: "Sent",
          content: _responseModel.message.toString(), onPressed: () {
        Navigator.pop(context);
      });
    }
  }

  //-----------------RESEND VERIFICATION EMAIL API------------------------------
  Future<dynamic> resendVerificationEmail(
      {required BuildContext context}) async {
    method = "get";
    context = context;
    ResponseModel _responseModel = await request('verify_email');
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      return _responseModel.statusCode;
    }
    return null;
  }

  //-----------------LOGOUT API------------------------------

  Future<dynamic> logout({required BuildContext context}) async {
    method = "get";
    context = context;
    ResponseModel _responseModel = await request('logout');
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      storage.deleteAll();
      globals.GlobalData.showVerifyPopUp = false;
      globals.GlobalData.showStripeAccountPopUp = false;
      Navigator.pushNamedAndRemoveUntil(context, loginScreen, (route) => false);
      return _responseModel.statusCode;
    }
    return null;
  }

  //-----------------VETERINARIAN SIGN_UP API------------------------------
  vetSignUp(
      {required String first_name,
      required String last_name,
      required String email,
      required String phoneNo,
      required String address,
      required String postalCode,
      required String practice_name,
      required String cityId,
      required String rNumber,
      required String fbUrl,
      required String instaUrl,
      required String password,
      required String confirmPassword,
      required String lat,
      required String long,
      required BuildContext context}) async {
    method = 'post';
    Map<String, String> body = {
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
      'phone_number': phoneNo,
      'address': address,
      'postal_code': postalCode,
      'city_id': cityId,
      'rcvs_number': rNumber,
      'practice_name': practice_name,
      'fb_url': fbUrl,
      'insta_url': instaUrl,
      'lat': lat,
      'long': long,
    };
    this.context = context;
    data = body;
    ResponseModel _responseModel = await request("vet_signup");
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      storage.setStore('token', _responseModel.body['access_token']);
      storage.setStore('auth_id', _responseModel.body['user']['id'].toString());
      storage.setStore('role', _responseModel.body['user']['role']);
      storage.setStore(
          'email_verified', _responseModel.body['user']['email_verified_at']);
      if (_responseModel.body['user']['email_verified_at'] == null) {
        globals.GlobalData.showVerifyPopUp = true;
      }
      Navigator.pushNamedAndRemoveUntil(
          context, vetDashBoardScreen, (route) => false);
      return '';
    }
  }

  //-----------------CHARITY SIGN_UP API------------------------------
  charitySignUp(
      {required String first_name,
      required String last_name,
      required String email,
      required String phoneNo,
      required String address,
      required String postalCode,
      required String cityId,
      required String charityNumber,
      required String password,
      required String lat,
      required String long,
      required String confirmPassword,
      required BuildContext context}) async {
    method = 'post';
    Map<String, String> body = {
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
      'phone_number': phoneNo,
      'address': address,
      'postal_code': postalCode,
      'city_id': cityId,
      'lat': lat,
      'long': long,
      'charity_number': charityNumber,
    };
    this.context = context;
    data = body;
    ResponseModel _responseModel = await request("charity_signup");
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      storage.setStore('token', _responseModel.body['access_token']);
      storage.setStore('auth_id', _responseModel.body['user']['id'].toString());
      storage.setStore('role', _responseModel.body['user']['role']);
      storage.setStore(
          'email_verified', _responseModel.body['user']['email_verified_at']);
      if (_responseModel.body['user']['email_verified_at'] == null) {
        globals.GlobalData.showVerifyPopUp = true;
      }
      Navigator.pushNamedAndRemoveUntil(
          context, charityDashBoardScreen, (route) => false);
      return '';
    }
  }

  //-----------------BREEDER SIGN_UP API------------------------------
  breederSignup({
    required String first_name,
    required String last_name,
    required String email,
    required String phoneNo,
    required String address,
    required String postalCode,
    required String cityId,
    required String confirmPassword,
    required String lat,
    required String long,
    required BuildContext context,
    required String password,
  }) async {
    EasyLoading.show(
        status: 'loading...', maskType: EasyLoadingMaskType.custom);
    Map<String, String> headers = {
      "m-access-key":
          "\$2a\$12\$KECVUQRPLWJvidTm7cbPbOhaZMbKngt.X2RYTB1ctS/PVo7rOGVje"
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(BaseUrl.getBaseUrl() + "register/breeder"));
    request.headers.addAll(headers);
    // request.files
    //     .add(await http.MultipartFile.fromPath('proof_of_address', filepath));
    request.fields['first_name'] = first_name;
    request.fields['last_name'] = last_name;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['password_confirmation'] = confirmPassword;
    request.fields['phone_number'] = phoneNo;
    request.fields['address'] = address;
    request.fields['postal_code'] = postalCode;
    request.fields['city_id'] = cityId;
    request.fields['lat'] = lat;
    request.fields['long'] = long;

    var res = await request.send();
    var responed = await http.Response.fromStream(res);
    var responseData = json.decode(responed.body);
    if (responseData['status'] == 200) {
      storage.setStore('token', responseData['data']['access_token']);
      storage.setStore(
          'auth_id', responseData['data']['user']['id'].toString());
      storage.setStore('role', responseData['data']['user']['role']);
      storage.setStore('qr_code', responseData['data']['user']['qr_code']);
      storage.setStore(
          'email_verified', responseData['data']['user']['email_verified_at']);
      storage.setStore(
          'onBoard_status', responseData['data']['on_board_status'].toString());
      if (responseData['data']['user']['email_verified_at'] == null) {
        globals.GlobalData.showVerifyPopUp = true;
      }
      if (responseData['data']['on_board_status'] == false) {
        globals.GlobalData.showStripeAccountPopUp = true;
      }
      EasyLoading.dismiss(animation: true);

      Navigator.pushNamedAndRemoveUntil(
          context, breederDashBoardScreen, (route) => false);
    } else {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showError(responseData['message'] ?? "Something went wrong");
    }
  }
}
