import 'package:flutter/material.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';

class CustomLoaders {
  static Widget loader(BuildContext context, GlobalKey key) {
    return WillPopScope(
      child: Dialog(
        child: Container(
          height: 100,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Please Wait...',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }

  static Widget customAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onPressed,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: Container(
        height: MediaQuery.of(context).size.height / 3.5,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )),
              Text(
                title,
                softWrap: true,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Flexible(
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  if (onPressed != null) {
                    Navigator.of(context).pop();
                    onPressed();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                      color: ColorValues.loginBackground,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Center(
                    child: Text(
                      "Ok",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
