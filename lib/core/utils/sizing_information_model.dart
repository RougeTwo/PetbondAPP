import 'package:flutter/material.dart';
import 'package:petbond_uk/core/utils/enum.dart';

import '../values/fontsize_values.dart';

class SizingInformationModel {
  final Orientation orientation;
  final DeviceScreenType deviceScreenType;
  final Size screenSize;
  final Size localWidgetSize;
  final MediaQueryData mediaQuery;
  final double screenWidth;
  final double screenHeight;
  final double blockSizeHorizontal;
  final double blockSizeVertical;
  final double safeAreaHorizontal;
  final double safeAreaVertical;
  final double safeBlockHorizontal;
  final double safeBlockVertical;
  final double? currentBoxSize;
  final FontSizeValues fontSize;

  SizingInformationModel({
    required this.orientation,
    required this.deviceScreenType,
    required this.screenSize,
    required this.localWidgetSize,
    required this.mediaQuery,
    required this.screenWidth,
    required this.screenHeight,
    required this.blockSizeHorizontal,
    required this.blockSizeVertical,
    required this.safeAreaHorizontal,
    required this.safeAreaVertical,
    required this.safeBlockHorizontal,
    required this.currentBoxSize,
    required this.safeBlockVertical,
    required this.fontSize,
  });

  @override
  String toString() {
    return 'Orientation:$orientation DeviceType:$deviceScreenType ScreenSize:$screenSize LocalWidgetSize:$localWidgetSize';
  }
}
