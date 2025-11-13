import 'package:flutter/material.dart';
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
    final a = (c.a * 255.0).round() & 0xff;
    final r = (c.r * 255.0).round() & 0xff;
    final g = (c.g * 255.0).round() & 0xff;
    final b = (c.b * 255.0).round() & 0xff;
    return Color.fromARGB(
      a,
      r + ((255 - r) * p).round(),
      g + ((255 - g) * p).round(),
      b + ((255 - b) * p).round(),
    );
  }

  convertColor({required String value}) {
    String htmlColour = value;
    String fixedColour = htmlColour.replaceAll("#", '0xFF');
    return fixedColour;
  }
}

class ColorValue {
  final Color nameColor;

  ColorValue(this.nameColor);
}
