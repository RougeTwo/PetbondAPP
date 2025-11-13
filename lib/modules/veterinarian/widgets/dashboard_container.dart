import 'package:flutter/material.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';

class CustomContainer extends StatelessWidget {
  final SizingInformationModel sizingInformation;
  final String txt;
  final String description;

  const CustomContainer(
      {Key? key,
      required this.sizingInformation,
      required this.txt,
      required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
              color: ColorValues.fontColor,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              child: Text(
                txt,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(description)
      ],
    );
  }
}
