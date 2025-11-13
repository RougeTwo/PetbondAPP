import 'package:flutter/material.dart';
import 'package:petbond_uk/models/shared/chat/chat_model.dart';

class AdvertMessageModel {
  final String advertName;
  final List<ChatModel> chats;

  AdvertMessageModel({
    required this.advertName,
    required this.chats,
  });

  factory AdvertMessageModel.fromJson(Map<String, dynamic> json) {
    return AdvertMessageModel(
      advertName: json['advert_name'],
      chats: json['advert_buyers'].map<ChatModel>((chat) {
        return ChatModel.fromJson(chat);
      }).toList(),
    );
  }
}
