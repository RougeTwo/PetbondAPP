import 'package:flutter/material.dart';

class ColorValues {
  static const Color white = Colors.white;
  static const Color backgroundColor = Colors.white;
  static const Color loginBackground = Color(0xffE4A039);
  static const Color fontColor = Color(0xff61489D);
  static const Color lighBlueButton = Color(0xffB2D5EF);
  static const Color buttonTextColor = Color(0xff61489D);
  static const Color bottomContainerColor = Color(0xff6455A9);
  static const Color counterContainerColor = Color(0xff42388d);
  static const Color lightGreyColor = Color(0xffCCCCCC);
  static const Color greyTextColor = Color(0xff666666);
  static const Color greyButtonColor = Color(0xff999999);
  static const Color darkerGreyColor = Color(0xff545454);
  static const Color parrotColor = Color(0xff00D819);
  static const Color redColor = Color(0xffFF0000);
  static const Color kennyColor = Color(0xff3aa379);
  static const Color dullRed = Color(0xffd73232);

  static Color lighten(Color c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(
        c.alpha,
        c.red + ((255 - c.red) * p).round(),
        c.green + ((255 - c.green) * p).round(),
        c.blue + ((255 - c.blue) * p).round());
  }

  convertColor({required String Value}) {
    String html_colour = Value;
    String fixedColour = html_colour.replaceAll("#", '0xFF');
    return fixedColour;
  }
}

class ColorValue {
  final Color nameColor;

  ColorValue(this.nameColor);
}
