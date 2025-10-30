import 'package:flutter/material.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';

import '../../values/color_values.dart';

class RatingContainer {
  static Widget oneFilledContainer() {
    return Row(
      children: [
        CustomWidgets.filledContainer(),
        CustomWidgets.unfilledContainer(),
        CustomWidgets.unfilledContainer(),
        CustomWidgets.unfilledContainer(),
        CustomWidgets.unfilledContainer(),
      ],
    );
  }

  static Widget twoFilledContainer() {
    return Row(
      children: [
        CustomWidgets.filledContainer(),
        CustomWidgets.filledContainer(),
        CustomWidgets.unfilledContainer(),
        CustomWidgets.unfilledContainer(),
        CustomWidgets.unfilledContainer(),
      ],
    );
  }

  static Widget threeFilledContainer() {
    return Row(
      children: [
        CustomWidgets.filledContainer(),
        CustomWidgets.filledContainer(),
        CustomWidgets.filledContainer(),
        CustomWidgets.unfilledContainer(),
        CustomWidgets.unfilledContainer(),
      ],
    );
  }

  static Widget fourFilledContainer() {
    return Row(
      children: [
        CustomWidgets.filledContainer(),
        CustomWidgets.filledContainer(),
        CustomWidgets.filledContainer(),
        CustomWidgets.filledContainer(),
        CustomWidgets.unfilledContainer(),
      ],
    );
  }

  static Widget fiveFilledContainer() {
    return Row(
      children: [
        CustomWidgets.filledContainer(),
        CustomWidgets.filledContainer(),
        CustomWidgets.filledContainer(),
        CustomWidgets.filledContainer(),
        CustomWidgets.filledContainer(),
      ],
    );
  }

  static Widget unFilledContainer() {
    return Row(
      children: [
        CustomWidgets.unfilledContainer(),
        CustomWidgets.unfilledContainer(),
        CustomWidgets.unfilledContainer(),
        CustomWidgets.unfilledContainer(),
        CustomWidgets.unfilledContainer(),
      ],
    );
  }

  static Widget getContainer(String value) {
    switch (value) {
      case '1':
        return oneFilledContainer();
      case '2':
        return twoFilledContainer();
      case '3':
        return threeFilledContainer();
      case '4':
        return fourFilledContainer();
      case '5':
        return fiveFilledContainer();
      default:
        return unFilledContainer();
    }
  }
}
