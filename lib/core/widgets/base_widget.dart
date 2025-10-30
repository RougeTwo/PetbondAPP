import 'package:flutter/material.dart';
import 'package:petbond_uk/core/values/fontsize_values.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/utils/ui.dart';

class BaseWidget extends StatelessWidget {
  final Widget Function(
      BuildContext context, SizingInformationModel sizingInformation) builder;

  const BaseWidget({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return LayoutBuilder(builder: (context, boxConstaints) {
      var _screenWidth = mediaQuery.size.width;
      var _screenHeight = mediaQuery.size.height;
      var _safeAreaHorizontal =
          mediaQuery.padding.left + mediaQuery.padding.right;
      var _safeAreaVertical =
          mediaQuery.padding.top + mediaQuery.padding.bottom;
      var _safeBlockHorizontal = (_screenWidth - _safeAreaHorizontal) / 100;
      var _safeBlockVertical = (_screenHeight - _safeAreaVertical) / 100;
      var fontSizeValues = FontSizeValues(_safeBlockHorizontal);
      var sizingInformation = SizingInformationModel(
        orientation: mediaQuery.orientation,
        deviceScreenType: getDeviceType(mediaQuery),
        screenSize: mediaQuery.size,
        localWidgetSize: Size(boxConstaints.maxWidth, boxConstaints.maxHeight),
        mediaQuery: mediaQuery,
        screenWidth: _screenWidth,
        screenHeight: _screenHeight,
        blockSizeHorizontal: _screenWidth / 100,
        blockSizeVertical: _screenHeight / 100,
        safeAreaHorizontal: _safeAreaHorizontal,
        safeAreaVertical: _safeAreaVertical,
        safeBlockHorizontal: _safeBlockHorizontal,
        safeBlockVertical: _safeBlockVertical,
        fontSize: fontSizeValues,
        currentBoxSize: null,
      );
      return builder(context, sizingInformation);
    });
  }
}
