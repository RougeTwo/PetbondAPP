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
  final bool showMessageCounter;
  final int messageCounter;

  DrawerButton({
    Key? key,
    required this.sizingInformation,
    required this.onTap,
    required this.buttonColor,
    required this.btnLable,
    this.showMessageCounter = false,
    this.role = 'breeder',
    this.messageCounter = 0,
  }) : super(key: key);

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
                color: buttonColor,
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                btnLable,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),

        if (showMessageCounter)
          FutureBuilder(
            future: chatService.unreadMessagesCount(
              context: context,
              role: role,
            ),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) return const SizedBox();

              final count = snapshot.data ?? 0;

              return count > 0
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
                    count > 99 ? '+99' : count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ),
              )
                  : const SizedBox();
            },
          ),
      ],
    );
  }
}
