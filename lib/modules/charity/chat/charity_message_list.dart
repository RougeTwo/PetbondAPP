import 'package:flutter/material.dart' hide DrawerButton;
import 'dart:convert';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/widgets/base_widget.dart';
import 'package:petbond_uk/core/widgets/shared/header.dart';
import 'package:petbond_uk/models/shared/chat/message_model.dart';
import 'package:petbond_uk/modules/charity/chat/charity_advert_message_list.dart';
import 'package:petbond_uk/services/shared/chat_service.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../core/services/secure_storage.dart';
import '../../../core/utils/pusher_service.dart';
import '../../../core/utils/sizing_information_model.dart';
import '../../../core/widgets/custom_widgets.dart';
import '../../../core/widgets/drawer_buttons.dart' as custom;
import '../../../services/auth/auth_services.dart';
import '../advertise_pet/charity_advert_create.dart';
import '../charity_account_setting.dart';
import '../charity_dashboard.dart';
import '../charity_listed_pets.dart';

class CharityMessageList extends StatefulWidget {
  const CharityMessageList({Key? key}) : super(key: key);

  @override
  State<CharityMessageList> createState() => _CharityMessageListState();
}

class _CharityMessageListState extends State<CharityMessageList> {
  ChatService chatService = ChatService();
  List<MessageModel> recentList = [];
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
          int index = recentList.indexWhere(
              (element) => element.id == data['advert_info']['advert_id']);

          if (index != -1) {
            setState(() {
              recentList[index].unreadMessageCount =
                  data['advert_info']['unread_count'];
              recentList[index].hasMessages = true;
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

  Future<void> _loadDataFromAPI() async {
    List<MessageModel> message = await chatService.listMessages(
      context: context,
      role: 'charity',
    );
    setState(() {
      recentList = message;
    });
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
    return BaseWidget(builder: (context, sizingInformation) {
      return Scaffold(
        drawer: Theme(
          data: Theme.of(context).copyWith(canvasColor: ColorValues.fontColor),
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
    });
  }

  _drawerItems({required SizingInformationModel sizingInformation}) {
    return Column(
      children: [
        custom.DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              _disconnectPusher();
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CharityDashBoardScreen()));
            },
            buttonColor: Colors.white.withValues(alpha: 0.25),
            btnLable: "Overview"),
        custom.DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              _disconnectPusher();
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CharityAdvertCreate(
                            id: null,
                          )));
            },
            buttonColor: Colors.white.withValues(alpha: 0.25),
            btnLable: "Sell a pet"),
        custom.DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              _disconnectPusher();
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CharityListedPets()));
            },
            buttonColor: Colors.white.withValues(alpha: 0.25),
            btnLable: "Listed pet"),
        custom.DrawerButton(
          sizingInformation: sizingInformation,
          onTap: () {
            Navigator.pop(context);
          },
          buttonColor: ColorValues.loginBackground,
          btnLable: "Advert Messages",
          showMessageCounter: true,
          role: 'charity',
        ),
        custom.DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              _disconnectPusher();
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CharityAccountSetting()));
            },
            buttonColor: Colors.white.withValues(alpha: 0.25),
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
                    color: Colors.black.withValues(alpha: 0.2),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomWidgets.cardTitle(title: "Advert Messages"),
          const SizedBox(
            height: 10,
          ),
          _listAdvertMessages(sizingInformation: sizingInformation)
        ],
      ),
    );
  }

  _listAdvertMessages({required SizingInformationModel sizingInformation}) {
    return recentList.isEmpty
        ? SizedBox(
            height: sizingInformation.screenHeight,
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: recentList.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text(recentList[index].advertName)),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5, right: 5),
                          child: CustomWidgets.buttonWithoutFontFamily(
                            text: recentList[index].hasMessages
                                ? 'View Messages'
                                : 'No Messages',
                            width: 50,
                            onPressed: () {
                              if (recentList[index].hasMessages) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CharityAdvertMessageList(
                                            advertId: recentList[index].id,
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
                        recentList[index].unreadMessageCount > 0
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
                                    recentList[index].unreadMessageCount > 99
                                        ? '+99'
                                        : recentList[index]
                                            .unreadMessageCount
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
          );
  }
}

