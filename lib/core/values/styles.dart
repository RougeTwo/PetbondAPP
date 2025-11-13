import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'color_values.dart';

class CustomStyles {
    static const String saveText = "Saved Successfully!";
  static const TextStyle cardTitleStyle = TextStyle(
      color: ColorValues.fontColor, fontSize: 29, fontFamily: "FredokaOne");
  static const TextStyle cardTitleStyleTwo = TextStyle(
      color: ColorValues.fontColor, fontSize: 20, fontFamily: "FredokaOne");
  static const TextStyle textStyle =
      TextStyle(fontFamily: "NotoSans", color: ColorValues.darkerGreyColor);
  static const TextStyle textStyle1 = TextStyle(
      fontFamily: "NotoSans",
      color: ColorValues.fontColor,
      decoration: TextDecoration.underline);
}
