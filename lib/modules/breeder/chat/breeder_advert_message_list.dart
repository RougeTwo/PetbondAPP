import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/widgets/base_widget.dart';
import 'package:petbond_uk/core/widgets/shared/header.dart';
import 'package:petbond_uk/models/shared/chat/advert_message_model.dart';
import 'package:petbond_uk/modules/breeder/chat/breeder_message_list.dart';
import 'package:petbond_uk/modules/breeder/chat/view_chat.dart';
import 'package:petbond_uk/services/shared/chat_service.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../core/services/secure_storage.dart';
import '../../../core/utils/pusher_service.dart';
import '../../../core/utils/sizing_information_model.dart';
import '../../../core/widgets/custom_widgets.dart';
import '../../../core/widgets/drawer_buttons.dart';
import '../../../services/auth/auth_services.dart';
import '../advertise_pet/advertise_pet_step_two_create.dart';
import '../breeder-profile_setting.dart';
import '../breeder_account_setting.dart';
import '../breeder_dashboard.dart';
import '../breeder_listed_pets.dart';
import '../breeder_my_sale.dart';

class BreederAdvertMessageList extends StatefulWidget {
  final int advertId;
  final Future<void> Function() reloadData;

  const BreederAdvertMessageList(
      {Key? key, required this.advertId, required this.reloadData})
      : super(key: key);

  @override
  State<BreederAdvertMessageList> createState() =>
      _BreederAdvertMessageListState();
}

class _BreederAdvertMessageListState extends State<BreederAdvertMessageList> {
  ChatService chatService = ChatService();
  AdvertMessageModel advertMessageModel = AdvertMessageModel(
    advertName: '',
    chats: [],
  );
  String channelToSubscribe = '';
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  SecureStorage storage = SecureStorage();

  @override
  void initState() {
    super.initState();
    _loadDataFromAPIAndConnectPusher();
  }

  Future<void> _loadDataFromAPIAndConnectPusher() async {
    _loadDataFromAPI();
    _connectPusher();
  }

  Future<void> _loadDataFromAPI() async {
    AdvertMessageModel advertMessage = await chatService.listAdvertMessages(
        context: context, advertId: widget.advertId, role: 'breeder');
    setState(() {
      advertMessageModel = advertMessage;
    });
  }

  _connectPusher() async {
    int userId = int.parse(await storage.readStore('auth_id') ?? '0');
    await pusher.init(
      apiKey: PusherService.apiKEY,
      cluster: PusherService.cluster,
      onConnectionStateChange: PusherService.onConnectionStateChange,
      onAuthorizer: PusherService.onAuthorizer,
    );
    channelToSubscribe = "private-general-notifications-$userId";
    await pusher.subscribe(
      channelName: channelToSubscribe,
      onEvent: (event) {
        var data = jsonDecode(event.data)['data'];
        if (event.eventName == 'unread-messages') {
          int index = advertMessageModel.chats.indexWhere(
              (element) => element.chatId == data['chat_info']['chat_id']);

          if (index != -1) {
            setState(() {
              advertMessageModel.chats[index].unreadMessageCount =
                  data['chat_info']['unread_count'];
              advertMessageModel.chats[index].messagesCount +=
                  advertMessageModel.chats[index].unreadMessageCount;
            });
          } else {
            // if new advert is added and was not available in list
            _loadDataFromAPI();
          }
        }
      },
    );
    await pusher.connect();
  }

  @override
  void dispose() async {
    _disconnectPusher();
    super.dispose();
  }

  _disconnectPusher() {
    pusher.disconnect();
    pusher.unsubscribe(channelName: channelToSubscribe);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.reloadData();
        return true;
      },
      child: BaseWidget(builder: (context, sizingInformation) {
        return Scaffold(
          drawer: Theme(
            data:
                Theme.of(context).copyWith(canvasColor: ColorValues.fontColor),
            child: Align(
              alignment: Alignment.topLeft,
              child: ClipRect(
                child: Drawer(
                  elevation: 10,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 42,
                        ),
                        Material(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: Row(
                              children: [
                                const Text(
                                  "Breeder DashBoard",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                const Spacer(),
                                IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 25,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _drawerItems(sizingInformation: sizingInformation)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: ColorValues.backgroundColor,
          body: AuthorizedHeader(
            showHeader: true,
            dashBoardTitle: "BREEDER",
            widget: _body(sizingInformation: sizingInformation),
            sizingInformation: sizingInformation,
          ),
        );
      }),
    );
  }

  _drawerItems({required SizingInformationModel sizingInformation}) {
    return Column(
      children: [
        DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              _disconnectPusher();
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BreederDashBoardScreen()));
            },
            buttonColor: Colors.white.withOpacity(0.25),
            btnLable: "Overview"),
        DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              _disconnectPusher();
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdvertisePetStepTwoCreate(
                            behaviour: 'create',
                            id: null,
                          )));
            },
            buttonColor: Colors.white.withOpacity(0.25),
            btnLable: "Sell a pet"),
        DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              _disconnectPusher();
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BreederProfileSetting()));
            },
            buttonColor: Colors.white.withOpacity(0.25),
            btnLable: "Profile"),
        DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              _disconnectPusher();
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BreederListedPets()));
            },
            buttonColor: Colors.white.withOpacity(0.25),
            btnLable: "Listed pet"),
        DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              _disconnectPusher();
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BreederMySale()));
            },
            buttonColor: Colors.white.withOpacity(0.25),
            btnLable: "My Sales"),
        DrawerButton(
          sizingInformation: sizingInformation,
          onTap: () {
            _disconnectPusher();
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BreederMessageList()));
          },
          buttonColor: Colors.white.withOpacity(0.25),
          btnLable: "Advert Messages",
          showMessageCounter: true,
        ),
        DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              _disconnectPusher();
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BreederAccountSetting()));
            },
            buttonColor: Colors.white.withOpacity(0.25),
            btnLable: "Settings"),
        InkWell(
            onTap: () {
              _disconnectPusher();
              AuthServices authServices = AuthServices();
              authServices.logout(context: context);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 35, 10),
              child: Container(
                height: 45,
                width: sizingInformation.screenWidth,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4)),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }

  _body({required SizingInformationModel sizingInformation}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        children: [_listAdvertMessages(sizingInformation: sizingInformation)],
      ),
    );
  }

  _listAdvertMessages({required SizingInformationModel sizingInformation}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomWidgets.cardTitle(title: advertMessageModel.advertName),
        const SizedBox(
          height: 10,
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: advertMessageModel.chats.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Text(advertMessageModel.chats[index].fullName)),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5, right: 5),
                        child: CustomWidgets.buttonWithoutFontFamily(
                          text:
                              advertMessageModel.chats[index].messagesCount > 0
                                  ? 'View Messages'
                                  : 'No Messages',
                          width: 50,
                          onPressed: () {
                            if (advertMessageModel.chats[index].messagesCount >
                                0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BreederViewChat(
                                          chatId: advertMessageModel
                                              .chats[index].chatId,
                                          reloadData:
                                              _loadDataFromAPIAndConnectPusher,
                                        )),
                              );
                            }
                          },
                          buttonColor: ColorValues.loginBackground,
                          sizingInformation: sizingInformation,
                          borderColor: ColorValues.loginBackground,
                        ),
                      ),
                      advertMessageModel.chats[index].unreadMessageCount > 0
                          ? Positioned(
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: ColorValues.counterContainerColor,
                                  shape: BoxShape.circle,
                                ),
                                height: 28,
                                width: 28,
                                alignment: Alignment.center,
                                child: Text(
                                  advertMessageModel
                                              .chats[index].unreadMessageCount >
                                          99
                                      ? '+99'
                                      : advertMessageModel
                                          .chats[index].unreadMessageCount
                                          .toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              color: ColorValues.buttonTextColor,
              // Customize the color of the divider line
              thickness: 1,
              // Customize the thickness of the divider line
              height: 1, // Customize the height of the divider line
            );
          },
        )
      ],
    );
  }
}
