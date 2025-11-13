import 'package:flutter/material.dart';
import 'package:petbond_uk/core/services/base_services.dart';
import 'package:petbond_uk/core/widgets/globals.dart' as globals;
import 'package:petbond_uk/core/utils/response_model.dart';
import 'package:petbond_uk/modules/createStripe/webview_stripe.dart';

class ConnectServices extends BaseService {

  //-----------CREATE STRIPE ACCOUNT--------------------
  createStripeAccount({required BuildContext context}) async {
    method = 'post';
    Map<String, String> body = {};
    this.context = context;
    data = body;
    ResponseModel _responseModel = await request("create_stripe");
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WebViewScreen(url: _responseModel.body['url'])));

    }
  }

  //-----------CHECK ON_BOARD STATUS--------------------

  Future<bool> checkOnBoard({required BuildContext context}) async {
    method = 'post';
    Map<String, String> body = {};
    this.context = context;
    data = body;
    ResponseModel _responseModel = await request("check_onBoard");
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      globals.GlobalData.showStripeAccountPopUp = false;
      storage.setStore('onBoard_status', "true");
    } else {
      return globals.GlobalData.showStripeAccountPopUp = false;
    }
    return false;
  }
}
