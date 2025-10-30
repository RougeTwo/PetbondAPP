import 'package:flutter/material.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/services/shared/chat_service.dart';

import '../values/color_values.dart';

class DrawerButton extends StatelessWidget {
  final ChatService chatService = ChatService();
  final VoidCallback onTap;
  final Color buttonColor;
  final SizingInformationModel sizingInformation;
  final String btnLable;
  final String role;
  bool showMessageCounter;
  int messageCounter = 0;

  DrawerButton({
    required this.sizingInformation,
    required this.onTap,
    required this.buttonColor,
    required this.btnLable,
    this.showMessageCounter = false,
    this.role = 'breeder',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 35, 10),
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 45,
              width: sizingInformation.screenWidth,
              decoration: BoxDecoration(
                  color: buttonColor, borderRadius: BorderRadius.circular(4)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    btnLable,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
        showMessageCounter
            ? FutureBuilder(
                future: chatService.unreadMessagesCount(
                  context: context,
                  role: role,
                ),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  } else {
                    messageCounter = snapshot.data;
                    return messageCounter > 0
                        ? Positioned(
                            right: 30,
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
                                messageCounter > 99
                                    ? '+99'
                                    : messageCounter.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox();
                  }
                })
            : const SizedBox(),
      ],
    );
  }
}
