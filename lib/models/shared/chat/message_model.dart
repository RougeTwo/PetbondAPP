import 'package:flutter/material.dart';
class MessageModel {
  final int id;
  final String advertName;
  int unreadMessageCount;
  bool hasMessages;

  MessageModel({
    required this.id,
    required this.advertName,
    required this.unreadMessageCount,
    required this.hasMessages,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    num unreadMessages = 0;
    bool hasChat = false;
    for (dynamic d in json['chats']) {
      unreadMessages += d['unread_messages_count'];

      if (d['messages_count'] > 0) {
        hasChat = true;
      }
    }

    return MessageModel(
      id: json['id'],
      advertName: json['advert_name'],
      unreadMessageCount: unreadMessages.toInt(),
      hasMessages: hasChat,
    );
  }
}
