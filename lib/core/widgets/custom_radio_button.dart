import 'package:flutter/material.dart';
import 'package:petbond_uk/core/values/color_values.dart';

class CustomRadioButton extends StatelessWidget {
  final VoidCallback onYesTap;
  final VoidCallback onNoTap;
  final int value;
  final String title;

  CustomRadioButton(
      {required this.onYesTap,
      required this.onNoTap,
      required this.title,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: ColorValues.greyTextColor),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              "Yes",
              style: TextStyle(color: ColorValues.greyTextColor),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: onYesTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  border:
                      Border.all(width: 2, color: ColorValues.lightGreyColor),
                ),
                child: value == 1
                    ? Card(
                        color: ColorValues.fontColor,
                        child: SizedBox(
                          height: 16,
                          width: 16,
                        ),
                      )
                    : SizedBox(
                        height: 24,
                        width: 24,
                      ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              "No",
              style: TextStyle(color: ColorValues.greyTextColor),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: onNoTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  border:
                      Border.all(width: 2, color: ColorValues.lightGreyColor),
                ),
                child: value == 2
                    ? Card(
                        color: ColorValues.fontColor,
                        child: SizedBox(
                          height: 16,
                          width: 16,
                        ),
                      )
                    : SizedBox(
                        height: 24,
                        width: 24,
                      ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
