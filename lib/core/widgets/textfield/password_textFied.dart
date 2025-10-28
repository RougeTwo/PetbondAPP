import 'package:flutter/material.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/utils/validator.dart';

import '../../values/color_values.dart';

class CustomPasswordTextField extends StatelessWidget {
  final SizingInformationModel sizingInformation;
  final TextEditingController textEditingController;
  final VoidCallback eyeTap;
  final bool obscureValue;
  final String hintText;
  final String? Function(String?)? validator;

  CustomPasswordTextField(
      {required this.sizingInformation,
      required this.textEditingController,
      required this.eyeTap,
      this.validator,
      required this.obscureValue,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
      child: Container(
        height: sizingInformation.safeBlockHorizontal * 18,
        child: TextFormField(
          controller: textEditingController,
          obscureText: obscureValue,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          style: TextStyle(fontSize: 15.0, color: ColorValues.fontColor),
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: eyeTap,
              child: obscureValue
                  ? Icon(
                      Icons.visibility_off,
                      color: ColorValues.lightGreyColor,
                    )
                  : Icon(Icons.visibility, color: ColorValues.fontColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: ColorValues.fontColor, width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide:
                  BorderSide(color: ColorValues.lightGreyColor, width: 2.0),
            ),
            contentPadding: EdgeInsets.all(8),
            hintText: hintText,
            labelStyle: TextStyle(color: ColorValues.darkerGreyColor),
            labelText: hintText,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(width: 1, color: Colors.black)),
          ),
        ),
      ),
    );
    ;
  }
}
