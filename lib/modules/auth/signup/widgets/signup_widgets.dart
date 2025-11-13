import 'package:flutter/material.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpWidgets {
  static Widget selectionCard(
      {required String title,
      required String image,
      required String description,
      required VoidCallback onTap}) {
    const double circleRadius = 90.0;
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        child: Stack(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: circleRadius / 2.0),

                  ///here we create space for the circle avatar to get ut of the box
                  child: Container(
                    //height: 250.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8.0,
                          offset: Offset(0.0, 5.0),
                        ),
                      ],
                    ),
                    width: double.infinity,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: circleRadius / 2.0,
                            ),
                            Text(
                              title,
                              style: const TextStyle(
                                  fontFamily: 'FredokaOne',
                                  color: ColorValues.fontColor,
                                  fontSize: 18.0),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                description,
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.black45, fontSize: 15.0),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(20),
                                child: ButtonTheme(
                                    buttonColor: ColorValues.loginBackground,
                                    minWidth: double.infinity,
                                    child: MaterialButton(
                                      color: ColorValues.loginBackground,
                                      onPressed: onTap,
                                      child: const Text('Register',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'FredokaOne')),
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color:
                                                  ColorValues.loginBackground,
                                              width: 1,
                                              style: BorderStyle.solid),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ))),
                          ],
                        )),
                  ),
                ),

                ///Image Avatar
                Container(
                  width: circleRadius,
                  height: circleRadius,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorValues.fontColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                        offset: Offset(0.0, 5.0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(
                      child: SvgPicture.asset(image, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  static Widget signUpTitle({required String txt}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        txt,
        textAlign: TextAlign.start,
        style: const TextStyle(
            color: ColorValues.fontColor,
            //fontWeight: FontWeight.bold,
            fontSize: 30.0,
            fontFamily: 'FredokaOne'),
      ),
    );
  }

  static Widget signUptextField(
      {required TextInputType textInputType,
      String? Function(String?)? validator,
      required String hintText,
      Color? textColor,
      Color? fillColor,
      bool? enabled,
      Widget? suffix,
      bool? filled,
      required TextEditingController textController,
      void Function(String)? onFieldSubmitted,
      required SizingInformationModel sizingInformation,
      int lines = 1}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
      child: SizedBox(
        // height: sizingInformation.safeBlockHorizontal * 0.06,
        height: sizingInformation.safeBlockHorizontal * 18,
        child: TextFormField(
          controller: textController,
          enabled: enabled,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          keyboardType: textInputType,
          onFieldSubmitted: onFieldSubmitted,
          style: const TextStyle(fontSize: 15.0, color: ColorValues.fontColor),
          decoration: InputDecoration(
            fillColor: fillColor,
            suffix: suffix,
            filled: filled,
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: ColorValues.fontColor, width: 2.0),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide:
                  BorderSide(color: ColorValues.lightGreyColor, width: 2.0),
            ),
            contentPadding: const EdgeInsets.all(8),
            hintText: hintText,
            labelStyle: const TextStyle(color: ColorValues.darkerGreyColor),
            labelText: hintText,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(width: 1, color: Colors.black)),
          ),
        ),
      ),
    );
  }

  static Widget customtextField({
    required TextInputType textInputType,
    String? Function(String?)? validator,
    required String hintText,
    String? labelText,
    double? width,
    TextStyle? errorStyle,
    Color? fillColor,
    bool? enabled,
    bool? filled,
    Icon? suffixIcon,
    Color? textColor,
    int? maxLength,
    void Function(String)? onFieldSubmitted,
    InputDecoration? inputDecoration,
    VoidCallback? onTap,
    required TextEditingController textController,
    required SizingInformationModel sizingInformation,
  }) {
    return SizedBox(
      width: width,
      height: sizingInformation.safeBlockHorizontal * 18,
      child: TextFormField(
        keyboardType: textInputType,
        maxLength: maxLength,
        controller: textController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        enabled: enabled,
        style: TextStyle(
            fontSize: 15.0, color: textColor ?? ColorValues.fontColor),
        decoration: InputDecoration(
          fillColor: fillColor,
          errorStyle: errorStyle,
          filled: filled,
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.all(8),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: ColorValues.fontColor, width: 2.0),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide:
                BorderSide(color: ColorValues.lightGreyColor, width: 2.0),
          ),
          hintText: hintText,
          labelText: labelText ?? hintText,
          // label: Text("Something"),
          labelStyle: const TextStyle(color: ColorValues.darkerGreyColor),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide:
                  BorderSide(width: 1, color: ColorValues.lightGreyColor)),
        ),
      ),
    );
  }
}
