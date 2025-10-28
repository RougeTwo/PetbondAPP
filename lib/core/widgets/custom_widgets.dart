import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petbond_uk/core/values/styles.dart';

class CustomWidgets {
  static Widget loginTextField(
      {required TextInputType textInputType,
      String? Function(String?)? validator,
      required String hintText,
      required TextEditingController textController,
      required SizingInformationModel sizingInformation,
      int lines = 1}) {
    return Container(
      // height: sizingInformation.safeBlockHorizontal * 0.06,
      height: sizingInformation.safeBlockHorizontal * 18,
      child: TextFormField(
        controller: textController,
        keyboardType: textInputType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        style: TextStyle(
            fontSize: 15.0, fontFamily: 'FredokaOne', color: Colors.black),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: ColorValues.fontColor, width: 2.0),
          ),
          contentPadding: EdgeInsets.all(8),
          hintText: hintText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(width: 1, color: Colors.black)),
        ),
      ),
    );
  }

  static Widget passwordField({
    required String? Function(String?)? validator,
    required String hintText,
    required String labelText,
    required VoidCallback onIconTap,
    required bool obscureValue,
    required TextEditingController textController,
    required SizingInformationModel sizingInformation,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
      child: Container(
        // height: sizingInformation.safeBlockHorizontal * 0.06,
        height: sizingInformation.safeBlockHorizontal * 18,
        child: TextFormField(
          controller: textController,
          obscureText: obscureValue,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          style: TextStyle(fontSize: 15.0, color: ColorValues.fontColor),
          decoration: InputDecoration(
            suffix: GestureDetector(
              onTap: onIconTap,
              child: obscureValue
                  ? Icon(
                      Icons.visibility_off,
                      color: ColorValues.fontColor,
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
            labelText: labelText,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(width: 1, color: Colors.black)),
          ),
        ),
      ),
    );
  }

  // TextStyle(fontSize: 15.0, color: ColorValues.fontColor)
  static Widget buttonWithoutFontFamily({
    required String text,
    double? width,
    double? widthSizedBox,
    double? verticalPadding,
    required VoidCallback onPressed,
    required Color buttonColor,
    required Color borderColor,
    required SizingInformationModel sizingInformation,
  }) {
    return SizedBox(
      width: widthSizedBox,
      child: ButtonTheme(
          minWidth: width ?? 0,
          child: MaterialButton(
            color: buttonColor,
            onPressed: onPressed,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 0),
              child: Text(text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  )),
            ),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: borderColor, width: 1, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(6)),
          )),
    );
  }

  static Widget button({
    required String text,
    required VoidCallback onPressed,
    required Color buttonColor,
    double? width,
    required Color borderColor,
    required SizingInformationModel sizingInformation,
  }) {
    return ButtonTheme(
        minWidth: width ?? double.infinity,
        child: MaterialButton(
          color: buttonColor,
          onPressed: onPressed,
          child: Text(text,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'FredokaOne')),
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: borderColor, width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8)),
        ));
  }

  static Widget iconButton({
    required String text,
    required VoidCallback onPressed,
    required Color buttonColor,
    Color? fontColor,
    Color? iconColor,
    Color? textColor,
    required String asset,
    double? width,
    double? fontSize,
    double? width2,
    required SizingInformationModel sizingInformation,
  }) {
    return SizedBox(
      width: width,
      child: MaterialButton(
        color: buttonColor,
        onPressed: onPressed,
        child: Row(
          children: [
            Text(text,
                style: TextStyle(
                  color: fontColor ?? Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.normal,
                )),
            Spacer(),
            SvgPicture.asset(
              asset,
              color: iconColor,
              height: 15,
            )
          ],
        ),
        textColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static Widget iconButtonNext({
    required String text,
    required VoidCallback onPressed,
    required bool showPrevious,
    required SizingInformationModel sizingInformation,
  }) {
    return SizedBox(
      width: 120,
      child: MaterialButton(
        color: ColorValues.lighBlueButton,
        onPressed: onPressed,
        child: showPrevious
            ? Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: ColorValues.fontColor,
                    size: 14,
                  ),
                  Spacer(),
                  Text(text,
                      style: TextStyle(
                        color: ColorValues.fontColor,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      )),
                ],
              )
            : Row(
                children: [
                  Text(text,
                      style: TextStyle(
                        color: ColorValues.fontColor,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      )),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: ColorValues.fontColor,
                    size: 14,
                  )
                ],
              ),
        textColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static Widget divider() {
    return Divider(
      thickness: 1,
      color: ColorValues.fontColor,
    );
  }

  static Widget box(
      {required SizingInformationModel sizingInformation, String? txt}) {
    return SizedBox(
      height: sizingInformation.screenHeight,
      width: sizingInformation.screenHeight,
      child: Text(txt ?? ""),
    );
  }

  static Widget cardTitle({required String title}) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        title,
        style: CustomStyles.cardTitleStyle,
      ),
    );
  }

  static Widget customNetworkImage(
      {required String imageUrl,
      double? width,
      double? height,
      required SizingInformationModel sizingInformation}) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      child: Image.network(
        imageUrl,
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return SizedBox(
              width: sizingInformation.safeBlockHorizontal * 50,
              height: sizingInformation.safeBlockHorizontal * 18,
              child: Image.asset(
                AssetValues.placeholder,
                fit: BoxFit.cover,
              ));
        },
        width: width ?? sizingInformation.safeBlockHorizontal * 50,
        height: height ?? sizingInformation.safeBlockHorizontal * 45,
        fit: BoxFit.cover,
      ),
    );
  }

  static Widget customNetworkImageTwo(
      {required String imageUrl,
      double? width,
      double? height,
      required SizingInformationModel sizingInformation}) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      child: Image.network(
        imageUrl,
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return SizedBox(
              width: sizingInformation.safeBlockHorizontal * 50,
              height: sizingInformation.safeBlockHorizontal * 45,
              child: Image.asset(
                AssetValues.placeholder,
                fit: BoxFit.contain,
              ));
        },
        width: width ?? sizingInformation.safeBlockHorizontal * 50,
        height: height ?? sizingInformation.safeBlockHorizontal * 45,
        fit: BoxFit.cover,
      ),
    );
  }

  static Widget checkedBox() => Card(
        color: ColorValues.fontColor,
        child: SizedBox(
          height: 16,
          width: 16,
        ),
      );

  static Widget unCheckedBox() => SizedBox(
        height: 24,
        width: 24,
      );

  static Widget filledContainer() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: CircleAvatar(
          radius: 5,
          backgroundColor: ColorValues.fontColor,
        ),
      );

  static Widget unfilledContainer() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: CircleAvatar(
          radius: 5,
          backgroundColor: ColorValues.fontColor.withOpacity(0.4),
        ),
      );

  static Widget verifyPopUp(
          {required SizingInformationModel sizingInformation,
          required VoidCallback onTap}) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        child: SizedBox(
          width: sizingInformation.screenWidth,
          child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              //  / clipBehavior: Clip.none,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: RichText(
                  text: TextSpan(
                      text:
                          'Looks like your Email Address is not verified yet, ',
                      style: CustomStyles.textStyle,
                      children: <TextSpan>[
                        TextSpan(
                            text: 'click here',
                            style: CustomStyles.textStyle1,
                            recognizer: TapGestureRecognizer()..onTap = onTap),
                        TextSpan(
                            text: ' to resend again.',
                            style: CustomStyles.textStyle),
                        // TextSpan(
                        //   text:
                        //       '\n *If you verify you\'re email just ignore this message.',
                        //   style: TextStyle(
                        //       fontSize: 12, color: ColorValues.darkerGreyColor),
                        // )
                      ]),
                ),
              )),
        ),
      );

  static Widget createStripePopUp(
          {required SizingInformationModel sizingInformation,
          required VoidCallback onTap}) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        child: SizedBox(
          width: sizingInformation.screenWidth,
          child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              //  / clipBehavior: Clip.none,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: RichText(
                  text: TextSpan(
                      text:
                          'To receive payments from Petbond please connect your Stripe account or follow the instructions to create a Stripe account ',
                      style: CustomStyles.textStyle,
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Connect/Create Stripe account',
                            style: CustomStyles.textStyle1,
                            recognizer: TapGestureRecognizer()..onTap = onTap),
                      ]),
                ),
              )),
        ),
      );

  static Widget transferUnablePopUp(
          {required SizingInformationModel sizingInformation,
          required VoidCallback onTap}) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        child: SizedBox(
          width: sizingInformation.screenWidth,
          child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              //  / clipBehavior: Clip.none,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: RichText(
                  text: TextSpan(
                      text:
                          'Looks like that you have not enable Payment Transfers in your Stripe Account ',
                      style: CustomStyles.textStyle,
                      children: <TextSpan>[
                        TextSpan(
                            text: 'click here',
                            style: CustomStyles.textStyle1,
                            recognizer: TapGestureRecognizer()..onTap = onTap),
                        TextSpan(
                          text: ' to enable this option.',
                          style: CustomStyles.textStyle,
                        ),
                        // TextSpan(
                        //   text:
                        //       '\n *If you verify you\'re email just ignore this message.',
                        //   style: TextStyle(
                        //       fontSize: 12, color: ColorValues.darkerGreyColor),
                        // )
                      ]),
                ),
              )),
        ),
      );
}
