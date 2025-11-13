import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/models/breeder/advert/advert_model.dart';
import 'package:petbond_uk/models/shared/user_model.dart';
import 'package:petbond_uk/services/shared/chat_service.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../core/services/secure_storage.dart';
import '../../../core/utils/pusher_service.dart';
import '../../../core/widgets/base_widget.dart';
import '../../../core/widgets/custom_bullet_span.dart';
import '../../../models/shared/chat/chat_detail_model.dart';
import '../../../models/shared/chat/chat_message_model.dart';

class CharityViewChat extends StatefulWidget {
  final int chatId;
  final Future<void> Function() reloadData;

  const CharityViewChat(
      {Key? key, required this.chatId, required this.reloadData})
      : super(key: key);

  @override
  State<CharityViewChat> createState() => _CharityViewChatState();
}

class _CharityViewChatState extends State<CharityViewChat> {
  final ScrollController _scrollController = ScrollController();
  final ChatService chatService = ChatService();
  final TextEditingController _textEditingController = TextEditingController();
  String channelToSubscribe = '';
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  int _numLines = 1;
  late int userId;
  SecureStorage storage = SecureStorage();

  bool isLoaded = false;
  ChatDetailModel chatMessageDetail = ChatDetailModel(
    advert: AdvertModel(),
    buyerInfo: UserModel(),
    messages: [],
  );

  @override
  void initState() {
    super.initState();
    _connectPusher(widget.chatId);
  }

  _connectPusher(int chatId) async {
    userId = int.parse(await storage.readStore('auth_id') ?? '0');
    await pusher.init(
      apiKey: PusherService.apiKEY,
      cluster: PusherService.cluster,
      onConnectionStateChange: PusherService.onConnectionStateChange,
      onAuthorizer: PusherService.onAuthorizer,
    );
    channelToSubscribe = "presence-chat-$chatId";
    await pusher.subscribe(
      channelName: channelToSubscribe,
      onEvent: (event) {
        var data = jsonDecode(event.data);
        if (event.eventName == 'message-receive' &&
            data['message']['sender_id'] != userId) {
          _updateMessageList(data['message']);
        }
      },
    );
    await pusher.connect();
  }

  _updateMessageList(eventData) {
    setState(() {
      chatMessageDetail.messages.add(ChatMessageModel.fromJson(eventData));
    });
    _scrollToBottom();
  }

  @override
  void dispose() async {
    _disconnectPusher();
    _scrollController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  _disconnectPusher() {
    pusher.disconnect();
    pusher.unsubscribe(channelName: channelToSubscribe);
  }

  _scrollToBottom() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(microseconds: 1),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void loadDataFromAPI() async {
    // Make your API call here to load data
    // Once the data is loaded, call the method to scroll to the bottom
    chatMessageDetail = await chatService.viewChat(
      context: context,
      chatId: widget.chatId,
      role: 'charity',
    );

    _scrollToBottom();
    setState(() {
      isLoaded = true;
    });
  }

  // Call this method when you want to reload the data
  Future<void> reloadAndPop() async {
    await widget.reloadData();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await widget.reloadData();
        if (mounted) Navigator.pop(context);
      },
      child: BaseWidget(builder: (context, sizingInformation) {
        return Scaffold(
          appBar: _appBarContainer(),
          body: _bodyContainer(sizingInformation: sizingInformation),
        );
      }),
    );
  }

  _appBarContainer() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: ColorValues.buttonTextColor,
      flexibleSpace: SafeArea(
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                reloadAndPop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: ColorValues.white,
              ),
            ),
            const Expanded(
              child: Text(
                "Test Advert for Checking Test Advert for Checking",
                style: TextStyle(
                  color: ColorValues.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _bodyContainer({required SizingInformationModel sizingInformation}) {
    return Stack(
      children: <Widget>[
        isLoaded
            ? ListView.builder(
                itemCount: chatMessageDetail.messages.length,
                shrinkWrap: true,
                padding:
                    EdgeInsets.only(top: 10, bottom: 60 + (_numLines * 20)),
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return index == 0
                      ? Container(
                          padding: const EdgeInsets.only(
                            left: 14,
                            right: 14,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Container(
                            width: sizingInformation.screenWidth,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: ColorValues.loginBackground,
                                border: Border.all(
                                    color: ColorValues.loginBackground)),
                            padding: const EdgeInsets.all(16),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Stay protected And Use The PetBond Payment System',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: ColorValues.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                BulletSpan(
                                  text:
                                      'FREE Vet Vaccinations & Health Checks for all puppies sold through our site',
                                ),
                                BulletSpan(
                                  text: 'FREE to advertise on our site',
                                ),
                                BulletSpan(
                                  text:
                                      'FREE Genetic testing for parent dogs before breeding when a puppy is sold through PetBond',
                                ),
                              ],
                            ),
                          ))
                      : Container(
                          padding: EdgeInsets.only(
                            left: (chatMessageDetail.messages[index].senderId ==
                                    chatMessageDetail.buyerInfo.id
                                ? 14
                                : 30),
                            right:
                                (chatMessageDetail.messages[index].senderId ==
                                        chatMessageDetail.buyerInfo.id
                                    ? 30
                                    : 14),
                            top: 10,
                            bottom: 10,
                          ),
                          child: Align(
                            alignment:
                                (chatMessageDetail.messages[index].senderId ==
                                        chatMessageDetail.buyerInfo.id
                                    ? Alignment.topLeft
                                    : Alignment.topRight),
                            child: Container(
                              width: sizingInformation.screenWidth,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: (chatMessageDetail
                                              .messages[index].senderId ==
                                          chatMessageDetail.buyerInfo.id
                                      ? ColorValues.buttonTextColor
                                      : ColorValues.white),
                                  border: Border.all(
                                      color: ColorValues.buttonTextColor)),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: (chatMessageDetail
                                            .messages[index].senderId ==
                                        chatMessageDetail.buyerInfo.id
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.start),
                                children: [
                                  Text(
                                    (chatMessageDetail
                                                .messages[index].senderId ==
                                            chatMessageDetail.buyerInfo.id
                                        ? chatMessageDetail
                                                .buyerInfo.firstName ??
                                            ''
                                        : 'You'),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: (chatMessageDetail
                                                  .messages[index].senderId ==
                                              chatMessageDetail.buyerInfo.id
                                          ? ColorValues.white
                                          : ColorValues.buttonTextColor),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    chatMessageDetail.messages[index].message,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: (chatMessageDetail
                                                  .messages[index].senderId ==
                                              chatMessageDetail.buyerInfo.id
                                          ? ColorValues.white
                                          : ColorValues.buttonTextColor),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                },
              )
            : Container(),
        _sendMessageContainer(),
      ],
    );
  }

  _sendMessageContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
        height: 70 + ((_numLines - 1) * 20),
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            const SizedBox(
              height: 30,
              width: 20,
            ),
            Expanded(
              child: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                    hintText: "Write message...",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none),
                // textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                onTap: () => Future.delayed(
                  const Duration(milliseconds: 300),
                  () => _scrollToBottom(),
                ),
                onChanged: (value) {
                  final lines = value.split('\n');

                  if (lines.length < 4) {
                    setState(() {
                      _numLines = lines.length;
                    });
                  }
                },
                maxLines: 3,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            FloatingActionButton(
              onPressed: () {
                if (_textEditingController.text.trim().isNotEmpty) {
                  chatService.sendMessage(
                    context: context,
                    chatId: widget.chatId,
                    message: _textEditingController.text,
                    role: 'charity',
                  );

                  Map<String, dynamic> data = {
                    'id': 1,
                    'message': _textEditingController.text,
                    'is_read': 0,
                    'sender_id': userId,
                  };

                  _updateMessageList(data);
                  _numLines = 1;

                  _textEditingController.text = '';
                }
              },
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
              backgroundColor: ColorValues.loginBackground,
              elevation: 0,
            ),
          ],
        ),
      ),
    );
  }
}
