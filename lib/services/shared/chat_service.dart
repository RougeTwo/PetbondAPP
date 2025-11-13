import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:petbond_uk/core/services/base_services.dart';
import 'package:petbond_uk/models/breeder/advert/advert_model.dart';
import 'package:petbond_uk/models/shared/chat/advert_message_model.dart';
import 'package:petbond_uk/models/shared/chat/chat_detail_model.dart';
import 'package:petbond_uk/models/shared/chat/message_model.dart';
import 'package:petbond_uk/models/shared/user_model.dart';

import '../../core/utils/response_model.dart';
import '../../models/shared/chat/chat_message_model.dart';

class ChatService extends BaseService {
  Future<List<MessageModel>> listMessages(
      {required BuildContext context, required String role}) async {
    method = 'get';
    context = context;
    ResponseModel _responseModel = role == 'breeder'
        ? await request('breeder_list_messages')
        : await request('charity_list_messages');
    List<MessageModel> recentList = [];
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      recentList = _responseModel.body.map<MessageModel>((advert) {
        return MessageModel.fromJson(advert);
      }).toList();
    }

    return recentList;
  }

  Future<AdvertMessageModel> listAdvertMessages({
    required BuildContext context,
    required int advertId,
    required String role,
  }) async {
    method = 'get';
    context = context;
    requestUrl = generateURL('breeder_list_advert_messages')
        .replaceAll(':advert_id', advertId.toString());

    requestUrl = role == 'breeder'
        ? generateURL('breeder_list_advert_messages')
            .replaceAll(':advert_id', advertId.toString())
        : generateURL('charity_list_advert_messages')
            .replaceAll(':advert_id', advertId.toString());
    ResponseModel _responseModel = await request(null);
    AdvertMessageModel advertMessageModel =
        AdvertMessageModel(advertName: '', chats: []);
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      advertMessageModel = AdvertMessageModel.fromJson(_responseModel.body);
    }

    return advertMessageModel;
  }

  Future<int> unreadMessagesCount(
      {required BuildContext context, required String role}) async {
    method = 'get';
    context = context;
    activateLoader = false;

    int count = 0;
    ResponseModel _responseModel = role == 'breeder'
        ? await request('breeder_unread_messages_count')
        : await request('charity_unread_messages_count');
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      count = _responseModel.body['unread_messages_count'];
    }

    return count;
  }

  Future<ChatDetailModel> viewChat({
    required BuildContext context,
    required int chatId,
    required String role,
  }) async {
    method = 'get';
    context = context;
    requestUrl = role == 'breeder'
        ? generateURL('breeder_view_chat')
            .replaceAll(':chat_id', chatId.toString())
        : generateURL('charity_view_chat')
            .replaceAll(':chat_id', chatId.toString());

    ResponseModel _responseModel = await request(null);
    ChatDetailModel chatDetailModel = ChatDetailModel(
      advert: AdvertModel(),
      buyerInfo: UserModel(),
      messages: [],
    );
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      chatDetailModel = ChatDetailModel.fromJson(_responseModel.body);
    }

    chatDetailModel.messages.insert(
        0,
        ChatMessageModel(
          id: 0,
          message: '',
          isRead: true,
          senderId: 0,
        ));

    return chatDetailModel;
  }

  Future<void> sendMessage({
    required BuildContext context,
    required int chatId,
    required String message,
    required String role,
  }) async {
    method = 'post';
    this.context = context;
    Map<String, String> body = {
      'message': message,
    };
    data = body;
    activateLoader = false;
    requestUrl = role == 'breeder'
        ? generateURL('breeder_send_message')
            .replaceAll(':chat_id', chatId.toString())
        : generateURL('charity_send_message')
            .replaceAll(':chat_id', chatId.toString());

    await request(null);
  }
}
