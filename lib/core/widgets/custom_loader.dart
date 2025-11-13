import 'package:flutter/material.dart';
import 'package:petbond_uk/core/values/color_values.dart';

class CustomLoaders {
  static Widget loader(BuildContext context, GlobalKey key) {
    return const PopScope(
      canPop: false,
      child: Dialog(
        child: SizedBox(
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
      child: SizedBox(
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
                    icon: const Icon(Icons.close),
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
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  onPressed();
                                },
                child: Container(
                  width: 80,
                  height: 40,
                  decoration: const BoxDecoration(
                      color: ColorValues.loginBackground,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: const Center(
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
