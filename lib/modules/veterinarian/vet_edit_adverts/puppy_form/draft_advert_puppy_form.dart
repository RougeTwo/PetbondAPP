import 'package:flutter/material.dart';
// ignore_for_file: no_logic_in_create_state
import 'package:flutter/material.dart';
import '/core/values/color_values.dart';
import '/core/widgets/base_widget.dart';

import 'draft_advert_puppy_model.dart';

typedef OnDelete = Function();

class PuppyForm extends StatefulWidget {
  final DraftAdvertPuppyModel puppyModel;
  final state = _PuppetFormState();
  final OnDelete? onDelete;

  PuppyForm({
    Key? key,
    required this.puppyModel,
    this.onDelete,
  }) : super(key: key);

  @override
  _PuppetFormState createState() => state;

  bool isValid() => state.validate();
}

class _PuppetFormState extends State<PuppyForm> {
  final form = GlobalKey<FormState>();
  String? text;
  bool isLoading = false;

  decoration({required String hint, required String label}) {
    return InputDecoration(
      // fillColor: fillColor,
      // filled: filled,
      contentPadding: const EdgeInsets.all(8),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: ColorValues.fontColor, width: 2.0),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: ColorValues.lightGreyColor, width: 2.0),
      ),
      hintText: hint,
      labelText: label,
      // label: Text("Something"),
      labelStyle: const TextStyle(color: ColorValues.darkerGreyColor),
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: ColorValues.lightGreyColor)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, sizingInformation) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Form(
            key: form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Puppy ${widget.puppyModel.index}"),
                if (widget.puppyModel.isNew == true)
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: widget.onDelete,
                    ),
                  ),
                // Text("Puppy no 1"),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    initialValue: widget.puppyModel.name,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSaved: (val) => widget.puppyModel.name = val!,
                    validator: (val) => val!.length > 2 || val.isEmpty
                        ? null
                        : 'Puppy name is invalid',
                    style: const TextStyle(
                        fontSize: 15.0, color: ColorValues.fontColor),
                    decoration: decoration(
                        hint: "Enter puppy name here", label: "Puppy Name")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    style: const TextStyle(color: ColorValues.fontColor),
                    initialValue: widget.puppyModel.color,
                    onSaved: (val) => widget.puppyModel.color = val!,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) => val!.length > 2 || val.isEmpty
                        ? null
                        : 'Color is invalid',
                    decoration:
                        decoration(hint: "puppy color", label: "Puppy Color")),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///form validator
  bool validate() {
    var valid = form.currentState!.validate();
    if (valid) form.currentState!.save();
    return valid;
  }
}
