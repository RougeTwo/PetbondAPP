import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:petbond_uk/core/utils/base_url.dart';
import 'package:petbond_uk/core/utils/config.dart';

import '../services/secure_storage.dart';

class PusherService {
  static String get apiKEY => AppConfig.pusherKey;
  static String get cluster => AppConfig.pusherCluster;

  static void onConnectionStateChange(
      dynamic currentState, dynamic previousState) {
    debugPrint("Connection: $currentState");
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
