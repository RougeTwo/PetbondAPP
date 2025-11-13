import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:petbond_uk/core/values/color_values.dart';

class CustomRadioButton extends StatelessWidget {
  final VoidCallback onYesTap;
  final VoidCallback onNoTap;
  final int value;
  final String title;

  const CustomRadioButton(
      {Key? key, required this.onYesTap,
      required this.onNoTap,
      required this.title,
      required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: ColorValues.greyTextColor),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Text(
              "Yes",
              style: TextStyle(color: ColorValues.greyTextColor),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: onYesTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  border:
                      Border.all(width: 2, color: ColorValues.lightGreyColor),
                ),
                child: value == 1
                    ? const Card(
                        color: ColorValues.fontColor,
                        child: SizedBox(
                          height: 16,
                          width: 16,
                        ),
                      )
                    : const SizedBox(
                        height: 24,
                        width: 24,
                      ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            const Text(
              "No",
              style: TextStyle(color: ColorValues.greyTextColor),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: onNoTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  border:
                      Border.all(width: 2, color: ColorValues.lightGreyColor),
                ),
                child: value == 2
                    ? const Card(
                        color: ColorValues.fontColor,
                        child: SizedBox(
                          height: 16,
                          width: 16,
                        ),
                      )
                    : const SizedBox(
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
