import 'package:flutter/material.dart';
import 'package:petbond_uk/core/routes/routes.dart';
import 'package:petbond_uk/core/services/secure_storage.dart';
import 'package:petbond_uk/core/utils/api.dart';
import 'package:petbond_uk/core/utils/helper.dart';
import 'package:petbond_uk/core/utils/response_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'http_request.dart';

class BaseService {
  final http = HttpRequest();
  SecureStorage storage = SecureStorage();
  GlobalKey<State> key = GlobalKey<State>();

  BuildContext? context;
  late String method;
  String? requestUrl;
  late String contentType;
  bool redirectOn = true;

  late bool activateLoader;
  late Map<String, String> data;

  BaseService() {
    method = 'get';
    contentType = 'json';
    activateLoader = true;
    context = context;
  }

  String generateURL(String key) {
    return Api.getUrl(key);
  }

  Future<ResponseModel> request(String? key) async {
    try {
      String? url = key != null ? generateURL(key) : requestUrl;
      if (activateLoader) {
        EasyLoading.show(
            status: 'loading...', maskType: EasyLoadingMaskType.custom);
      }
      ResponseModel _responseModel;
      Uri uri = Uri.parse(url!);

      switch (method) {
        case 'post':
          _responseModel = await http
              .post(uri, data, contentType: contentType);
          break;
        case 'put':
          _responseModel = await http.put(uri, data);
          break;
        case 'patch':
          _responseModel = await http.patch(uri, data);
          break;
        case 'delete':
          _responseModel = await http.delete(uri, data);
          break;
        default:
          _responseModel = await http.get(uri);
          break;
      }
      if (activateLoader) {
        // Loader.hide();
        EasyLoading.dismiss(animation: true);
      }
      // Unauthenticated
      if (_responseModel.statusCode == 401 && redirectOn == true) {
        storage.deleteAll();
        Helper.showErrorAlert(
          context,
          title: 'Error',
          content: _responseModel.message!,
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context!, loginScreen, (route) => false);
          },
        );
      } else if (_responseModel.statusCode >= 400) {
        // Helper.showErrorAlert(
        //   this.context,
        //   title: 'Error',
        //   content: _responseModel.message!,
        //   onPressed: () {},
        // );
        EasyLoading.showError(_responseModel.message!);
      }
      // else if (_responseModel.statusCode == 403) {
      //   // Helper.showErrorAlert(
      //   //   this.context,
      //   //   title: 'Error',
      //   //   content: _responseModel.message!,
      //   //   onPressed: () {},
      //   // );
      //   EasyLoading.showToast(_responseModel.message!);
      // }
      _resetTypes();

      return _responseModel;
    } catch (e) {
      _resetTypes();
      EasyLoading.dismiss(animation: true);
      var error = e.toString();
      if (error.contains("SocketException") == true) {
        Helper.showErrorAlert(
          context,
          title: 'Connection Error!',
          content: "Please check your internet connection",
          onPressed: () {},
        );
      } else {
        Helper.showErrorAlert(
          context,
          title: 'Error',
          content: error,
          onPressed: () {},
        );
      }

      return ResponseModel(
        statusCode: 400,
        message: 'Something went wrong',
        body: null,
      );
    }
  }

  void _resetTypes() {
    method = 'get';
    contentType = 'json';
    requestUrl = null;
    activateLoader = true;
    redirectOn = true;
  }
}
