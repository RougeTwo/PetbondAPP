import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:petbond_uk/core/utils/base_url.dart';

import '../services/secure_storage.dart';

class PusherService {
  static const String apiKEY = '5f526fa356074f0c8e5a';
  static const String cluster = 'eu';

  static void onConnectionStateChange(
      dynamic currentState, dynamic previousState) {
    print("Connection: $currentState");
  }

  static dynamic onAuthorizer(
      String channelName, String socketId, dynamic options) async {
    SecureStorage storage = SecureStorage();
    String? token = await storage.readStore('token');
    String authUrl = BaseUrl.getStripeAuthUrl();

    var result = await http.post(
      Uri.parse(authUrl),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token',
      },
      body: 'socket_id=' + socketId + '&channel_name=' + channelName,
    );

    return jsonDecode(result.body);
  }
}
