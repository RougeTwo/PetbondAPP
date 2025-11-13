import 'package:flutter/material.dart';
import '../../breeder/advert/advert_model.dart';
import '../user_model.dart';
import 'chat_message_model.dart';

class ChatDetailModel {
  final AdvertModel advert;
  final UserModel buyerInfo;

  final List<ChatMessageModel> messages;

  ChatDetailModel({
    required this.advert,
    required this.buyerInfo,
    required this.messages,
  });

  factory ChatDetailModel.fromJson(Map<String, dynamic> json) {
    return ChatDetailModel(
      advert: AdvertModel.fromJson(json['advert']),
      buyerInfo: UserModel.fromJson(json['buyer']),
      messages: json['messages'].map<ChatMessageModel>((chat) {
        return ChatMessageModel.fromJson(chat);
      }).toList(),
    );
  }
}
