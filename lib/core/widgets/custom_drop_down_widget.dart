import 'package:flutter/material.dart';
import 'package:petbond_uk/core/values/color_values.dart';

class CustomDropdownWidget extends StatelessWidget {
  final String defaultValue;
  final String selectedValue;
  final Function(String?)? onValueChanged;
  final List<String> itemList;
  final Function validator;
  final FocusNode? focusNode;
  final GlobalKey? dropDownKey;
  final Color? selectedColor;

  const CustomDropdownWidget({Key? key, 
    required this.defaultValue,
    required this.selectedValue,
    required this.onValueChanged,
    required this.itemList,
    required this.validator,
    this.selectedColor,
    this.focusNode,
    this.dropDownKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: ColorValues.lightGreyColor, width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
          key: dropDownKey,
          focusNode: focusNode,
          isExpanded: true,
          initialValue: selectedValue,
          decoration: const InputDecoration(
              enabledBorder: InputBorder.none,
              isCollapsed: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 5)),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: selectedValue == defaultValue
                ? ColorValues.darkerGreyColor
                : selectedColor ?? ColorValues.fontColor,
          ),
          iconSize: 20,
          style: TextStyle(
            fontSize: 16,
            color: selectedValue == defaultValue
                ? ColorValues.darkerGreyColor
                : selectedColor ?? ColorValues.fontColor,
          ),
          onChanged: onValueChanged,
          items: itemList.map<DropdownMenuItem<String>>((String e) {
            return DropdownMenuItem<String>(value: e, child: Text(e));
          }).toList(),
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ),
    );
  }
}
// padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
