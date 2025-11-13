import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petbond_uk/core/services/secure_storage.dart';
import 'package:petbond_uk/core/utils/response_model.dart';

class HttpRequest {
  final SecureStorage storage = SecureStorage();
  final Map _contentTypes = {
    'json': 'application/json',
    'undefined': 'undefined',
    'form': 'application/x-www-form-urlencoded; charset=utf-8',
    'enctype': 'multipart/form-data',
  };

  Future<ResponseModel> get(Uri url) async {
    var headers = await _setHeaders();
    final response = await http.get(url, headers: headers);
    return response.body.isNotEmpty
        ? ResponseModel.fromJson(response.statusCode, json.decode(response.body))
        : ResponseModel(
            statusCode: 400, message: 'Request response malformed!');
  }

  Future<ResponseModel> post(Uri url, Map<String, String> body,
      {contentType = 'json'}) async {
    var headers = await _setHeaders(contentType: contentType);
    final response = await http.post(url, body: body, headers: headers);
    return response.body.isNotEmpty
        ? ResponseModel.fromJson(response.statusCode, json.decode(response.body))
        : ResponseModel(
            statusCode: 400, message: 'Request response malformed!');
  }
  Future<ResponseModel> put(Uri url, Map<String, dynamic> body) async {
    var headers = await _setHeaders();
    final response = await http.put(url, body: body, headers: headers);
    return ResponseModel.fromJson(response.statusCode, json.decode(response.body));
  }

  Future<ResponseModel> delete(Uri url, Map<String, dynamic> body) async {
    var headers = await _setHeaders();
    final response = await http.delete(url, body: body, headers: headers);
    return ResponseModel.fromJson(response.statusCode, json.decode(response.body));
  }

  Future<ResponseModel> patch(Uri url, Map<String, dynamic> body) async {
    var headers = await _setHeaders();
    final response = await http.patch(url, body: body, headers: headers);
    return ResponseModel.fromJson(response.statusCode, json.decode(response.body));
  }

  _setHeaders({contentType = 'json'}) async {
    String? jwt = await storage.readStore('token');
    jwt = jwt ?? '';
    var headers = {
      'Accept': _getContentType(type: contentType),
      'time-zone': DateTime.now().timeZoneName,
      'm-access-key':
          "\$2a\$12\$KECVUQRPLWJvidTm7cbPbOhaZMbKngt.X2RYTB1ctS/PVo7rOGVje",
      'Authorization': 'Bearer ' + jwt,
    };
    return headers;
  }

  String _getContentType({type = 'json'}) {
    return _contentTypes[type];
  }
}
